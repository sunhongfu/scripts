for i = 1:9
    load(['/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_24Sep21/meas_MID00351_FID05065_wip925b_TI2_ECHO2_VC_CS9_SAM54/ksp_echo' num2str(i) '_inv2.mat']);
    k(:,:,:,i,:)=ksp;
end


num_svd = 8;                   % no of SVD channels for compression (num_svd = 16 works well for 32 chan array)

temp = reshape(k, [], size(k,5));

[V,D] = eig(temp'*temp);
V = flipdim(V,2);


% coil compressed image, where 1st chan is the virtual body coil to be used as phase reference:
k = reshape(temp * V(:,1:num_svd), [size(k,[1 2 3 4]), num_svd]);
clear temp
k = permute(k,[1 2 3 5 4]);
k = permute(k,[2 3 1 4 5]);
save('/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_24Sep21/meas_MID00351_FID05065_wip925b_TI2_ECHO2_VC_CS9_SAM54/dcrnet/k_cc8.mat','k','-v7.3');
clear k ksp


deepMRI_root = '~/Downloads/deepMRI'; % where deepMRI git repo is downloaded/cloned to;
checkpoints  = '~/Downloads/DCRNet_data/checkpoints'; % where the network is stored;
ksp_path     = '/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_24Sep21/meas_MID00351_FID05065_wip925b_TI2_ECHO2_VC_CS9_SAM54/dcrnet/k_cc8.mat';  % where the subsampled kspace data is (in ".mat" format)
ReconDir     = '/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_24Sep21/meas_MID00351_FID05065_wip925b_TI2_ECHO2_VC_CS9_SAM54/dcrnet';  %% where to save reconstruction output
vox          = [0.75 0.75 0.75]; % voxel size;
TE           = [0.0018    0.0045    0.0073    0.0100    0.0128    0.0155    0.0183    0.0210    0.0238];
AF           = 8; % accelerating factors. 4 or 8; set it consistent with your network;
dc_weights   = 0.8;  % data consistency weights subject to [0, 1]. 0 means no data consistency;
                  % rec_dc(k) = (1 - dc_weights) * rec(k) * mask + dc_weights * k_sub + (1 - mask) * rec(k);

% optional inputs
% MaskPath     = '~/Downloads/DCRNet_data/demo/multi_channel/mask_sub_AF8.mat'; %% subsampling mask;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% add MATLAB paths
addpath(genpath([deepMRI_root,'/DCRNet/DCRNet_fcns/']));  % add necessary utility function for saving data and echo-fitting;
addpath(genpath([deepMRI_root,'/utils']));  %  add NIFTI saving and loading functions;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load data
if ~ exist('ksp_path','var') || isempty(ksp_path)
    error('Please specify the kspace data path!')
else
    inp = load(ksp_path);
    f = fields(inp);
    ksp = inp.(f{1});  % load kspace data;
end

[n_ky, n_kz, n_kx, n_chan, n_echo]  = size(ksp);

% load undersampling mask if available
if ~ exist('MaskPath','var') || isempty(MaskPath)
    mask = abs(ksp(:,:,round(n_kx/2),1,1)) > 1e-9;
else
    inp = load(MaskPath);
    f = fields(inp);
    mask = inp.(f{1}); % load mask data;
end

%% mkdir for output folders
if ~exist(ReconDir, 'dir')
    mkdir(ReconDir)
end

cd(ReconDir)

%% reconstruction setting;
InferencePath = [deepMRI_root, '/DCRNet/PythonCodes/Evaluation/multi_channel/Inference.py'];
switch AF
    case 4
        network_path = [checkpoints, '/DCRNet_AF4.pth'];
    case 8
        network_path = [checkpoints, '/DCRNet_AF8.pth'];
end

%% combine coils first
img_zf = fftshift(fft(fftshift(fftshift(fft(fftshift(fftshift(fft(fftshift(ksp,1),[],1),1),2),[],2),2),3),[],3),3);

% [ph_cmb,mag_cmb,coil_sen] = poem_lr(permute(abs(img_zf),[1 2 3 5 4]),permute(angle(img_zf),[1 2 3 5 4]),vox,TE,[],[2*round(n_ky/AF/4),2*round(n_kz/AF/4),n_kx]);
[ph_cmb, mag_cmb, coil_sens] = poem(permute(abs(img_zf),[1 2 3 5 4]),permute(angle(img_zf),[1 2 3 5 4]),vox,TE,[]);
% [ph_cmb, mag_cmb, coil_sens] = geme_cmb(permute((img_zf),[1 2 3 5 4]),vox,TE,ones(size(img_zf,[1 2 3])),[],0);

clear img_zf


nii = make_nii(mag_cmb, vox);
save_nii(nii, [ReconDir,'/mag_zf_cmb.nii']);

nii = make_nii(ph_cmb, vox);
save_nii(nii, [ReconDir,'/ph_zf_cmb.nii']);

for echo_num = 1 : n_echo  % number of echos;
    
    % temp_k = ksp(:,:,:,:,echo_num);  % get one echo-data;
    
    % %% POEM combinations to get zero-filling images;
    % [zf] = POEM(temp_k);
    
    % zf = zf(:,:,imsize(3) / 4 + 1: 3 * imsize(3) / 4);  %% only use the middle slices (due to readout over-sampling);
    
    % coil_sens = Cal_Sens(zf, temp_k); %% calculate the sensitivity for the zero-filling images; 
    
    %% processing zero-filling images to save network input 
    k_sub = ifftshift(ifftn(ifftshift(mag_cmb(:,:,:,echo_num).*exp(1j*ph_cmb(:,:,:,echo_num)))));  %% k_sub; 
    
    Amp_Nor_factors = max(abs(k_sub(:)));
    
    k_sub = k_sub / Amp_Nor_factors;  %% normalization
    
    inputs_img = fftshift(fftn(fftshift(k_sub)));
    
    inputs_img = inputs_img / 30; 
    
    save([ReconDir, '/NetworkInput.mat'],'inputs_img', '-v7.3');
    
    %% Call Python script to conduct the reconstruction;
    
    PythonRecon(InferencePath, [ReconDir,'/NetworkInput.mat'], ReconDir, network_path);
    
    %% load python reconstruction data;
    
    recon_r_path = [ReconDir,'/rec_real.mat'];
    recon_i_path = [ReconDir,'/rec_imag.mat'];
    
    load(recon_r_path);
    load(recon_i_path);
    
    %% load amplitude normlaization factors;
    % load(['Amp_Nor_factors_', num2str(FileNo),'.mat']);
    
    %% postprocessing starts;
    recs = recons_r + 1j * recons_i;
    
    disp('PostProcessing Starts')
    
    recs_no_dc(:,:,:,echo_num) = Amp_Nor_factors * recs * 30; % inverse the amplitude normlization for each echo;

    %% data consistency
    % [rec_dc_combined, rec_dc_mc]= DataConsistency_multi_channel(recs_new, ksp(:,:,:,:,echo_num), mask, coil_sens, dc_weights); 
    rec_dc_mc = DataConsistency_multi_channel(recs_no_dc(:,:,:,echo_num), ksp(:,:,:,:,echo_num), mask, coil_sens, dc_weights);

    % recs_dc_espirit_cmb(:,:,:,echo_num) = rec_dc_combined;
    mag(:,:,:,:,echo_num) = abs(rec_dc_mc);
    ph(:,:,:,:,echo_num) = angle(rec_dc_mc);
end

clear ksp k_sub coil_sens mag_cmb ph_cmb rec_dc_mc

nii = make_nii(abs(recs_no_dc), vox);
save_nii(nii, [ReconDir,'/mag_nodc_cmb.nii']);

nii = make_nii(angle(recs_no_dc), vox);
save_nii(nii, [ReconDir,'/ph_nodc_cmb.nii']);

clear recs_no_dc

% combine coils after data consistency
[ph_dc_cmb,mag_dc_cmb] = poem(permute(mag,[1 2 3 5 4]),permute(ph,[1 2 3 5 4]),vox,TE,[]);

nii = make_nii(mag_dc_cmb, vox);
save_nii(nii, [ReconDir,'/mag_dc_cmb.nii']);

nii = make_nii(ph_dc_cmb, vox);
save_nii(nii, [ReconDir,'/ph_dc_cmb.nii']);

% nii = make_nii(abs(recs_dc_espirit_cmb), vox);
% save_nii(nii, [ReconDir,'/mag_dc_espirit_cmb.nii']);

% nii = make_nii(angle(recs_dc_espirit_cmb), vox);
% save_nii(nii, [ReconDir,'/ph_dc_espirit_cmb.nii'])];

delete([ReconDir,'/NetworkInput.mat']);
delete([ReconDir,'/rec_real.mat']);
delete([ReconDir,'/rec_imag.mat']);
delete([ReconDir,'/mask_unwrp.dat']);
delete([ReconDir,'/offsets_raw.nii']);
delete([ReconDir,'/offsets_smooth.nii']);
delete([ReconDir,'/ph_diff.nii']);
delete([ReconDir,'/reliability_diff.dat']);
delete([ReconDir,'/sen_mag_raw.nii']);
delete([ReconDir,'/sen_mag_smooth.nii']);
delete([ReconDir,'/unph_diff.nii']);
delete([ReconDir,'/unwrapped_phase_diff.dat']);
delete([ReconDir,'/wrapped_phase_diff.dat']);


