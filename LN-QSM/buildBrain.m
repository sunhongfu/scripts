% Brain Model
% Simulate a simple brain model with WM, GM, CSF, basal ganglia, red
% nuclei, substantia nigra, and venous vasculature network

%% Load Segmented structures:
clear all;

load('./tissuesMasks');

%%

voxel_size = [0.5 0.5 0.5];
B0_dir = [0 0 1];
TE = 15e-3;
B0 = 3;           % Tesla
gamma = 2*pi*42.58;  % 10^6 cancels out with ppm 
SNR = 30;

TR = 32e-3;
Hct = 0.42;
OEF0 = 0.35;
delta_do = 4*pi*0.27;
delta_o = -4*pi*0.03;
fun_T_1b = @(x)1/(0.83*x+0.28); %calculate blood T1 based Hct

QSMFlag = true;


%% If QSM simulation is desired


%% Assign susceptibility values, T2*, and PD

brainChi = zeros(size(brainMask));
brainT2s = zeros(size(brainMask));
brainT1 = zeros(size(brainMask));
brainPD = zeros(size(brainMask));


%% Initialize susceptibility volume
% reference Liu 2016 Preconditioned total field inversion (TFI) method for
% quantitative susceptibility mapping

% in ppm
brainChi(WM>0.5) = -0.03; % or -0.03
brainChi(GM>0.5) = 0.053;
brainChi(CSF>0.5) = 0;

brainChi(~brainMask) = 9; % set background air susceptibility

%% Initialize T1, T2* values
% referece: Wansapura et al. NMR Relaxation Times in the Human Brain at 3.0
% Tesla, JMRI, 1999


brainT2s(WM>0.5) = 0.045;
brainT2s(GM>0.5) = 0.052;
brainT2s(CSF>0.5) = 0.2;  %guess



brainT1(WM>0.5) = 1.331;
brainT1(GM>0.5) = 0.832;
brainT1(CSF>0.5) = 2; %guess
brainT1(VN>0.5) = fun_T_1b(Hct); %guess


brainPD(WM>0.5) = 0.77;
brainPD(GM>0.5) = 0.86;
brainPD(CSF>0.5) = 1;
brainPD(VN>0.5) = 1;


%% Add venous vasculature to the brain model, comment out if not needed


% [R2sA_0, R2sV_0, R2sC_0] = calcR2s(Hct, OEF0);
% 
% brainT2s(VN>0.5) = 1./R2sV_0;
% brainChi(VN>0.5) = delta_do.*Hct*OEF0+delta_o*Hct;


%%

if QSMFlag

% Reference: my group-level results, corrected to make csf=0
brainChi(CN>0.5) = 0.10; % or -0.03
brainChi(GP>0.5) = 0.2;
brainChi(PU>0.5) = 0.15;
brainChi(RN>0.5) = 0.08; % or -0.03
brainChi(SN>0.5) = 0.18;

% Reference: Santin et al. 2016, Reproducibility...
brainT2s(CN>0.5) = 1/0.022e3;
brainT2s(GP>0.5) = 1/0.030e3;
brainT2s(PU>0.5) = 1/0.023e3;  
brainT2s(RN>0.5) = 1/0.025e3;
brainT2s(SN>0.5) = 1/0.027e3;

% Add T1 and PD for the above structures;
brainPD(GP>0.5) = 0.86;

end



%% Forward field calculation for phase

% JUMP must have used forward field calculation to obtain phase 
padsize = [100 100 100];
% brainChiPadded = padarray(brainChi, padsize);
brainChiPadded = brainChi;
brainFieldPadded = forward_field_calc(brainChiPadded, voxel_size, B0_dir);
% brainField = brainFieldPadded(1+padsize(1):end-padsize(1), 1+padsize(2):end-padsize(2), 1+padsize(3):end-padsize(3));
brainField = brainFieldPadded;
brainPhase = gamma.*brainField.*B0.*TE;

%% Calculating magnitude 

FA = degtorad(20); % flip angle

brainMag = brainPD.*sin(FA).*exp(-TE./brainT2s).*(1-exp(-TR./brainT1))./(1-cos(FA).*exp(-TR./brainT1));

%% Calculate complex signal

simpleComplexData = brainMag.*exp(1i.*brainPhase);

%% Add noise according to SNR - Double check on this
complexData = zeros(size(brainMask));
complexData(:) = awgn(simpleComplexData(:), 500, 'measured', 'linear');


%% 

brainPhaseNoisy=angle(complexData);
brainMagNoisy=abs(complexData);


nii = make_nii(brainChi,voxel_size);
save_nii(nii,'brainChi.nii');
nii = make_nii(brainPhase,voxel_size);
save_nii(nii,'brainPhase.nii');
nii = make_nii(brainPhaseNoisy,voxel_size);
save_nii(nii,'brainPhaseNoisy.nii');
nii = make_nii(brainMagNoisy,voxel_size);
save_nii(nii,'brainMagNoisy.nii');



% (1) calculate everything from unwrapped phase (no noise)
iFreq = brainPhase;
delta_TE = TE;
matrix_size = size(brainMask);
CF = 42.58*3e6;
mask = brainMask;
% iMag = brainMagNoisy;
iMag = mask;
N_std = 1;
% iFreq = unph*TE;

mkdir TFS_TFI_ERO0
cd TFS_TFI_ERO0
% (1) TFI of 0 voxel erosion
Mask = mask; % only brain tissue, need whole head later
Mask_G = Mask;
P_B = 30;
P = 1 * Mask + P_B * (1-Mask);
RDF = 0;
wG = 1;
save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF wG
QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 600*2);
nii = make_nii(QSM.*Mask,voxel_size);
save_nii(nii,'TFI_ero0.nii');
cd ..



%%%% TIK-QSM
mkdir TFS_TIK_PRE_ERO0
cd TFS_TIK_PRE_ERO0
tfs_pad = padarray(brainPhase/(gamma*B0*TE),[0 0 20]);
mask_pad = padarray(mask,[0 0 20]);
% R_pad = padarray(R,[0 0 20]);
r=0;
Tik_weight = 2e-3;
TV_weight = 7e-4;
chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight, voxel_size, B0_dir, 200);
nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),voxel_size);
save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight) '_NOPRE_200.nii']);
chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight, voxel_size, B0_dir, 2000);
nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),voxel_size);
save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight) '_NOPRE_2000.nii']);
cd ..





% (1) calculate everything from phase unwrapping
% unwrap the phase with best path
imsize = size(brainMask);
mask_unwrp = uint8(abs(brainMask)*255);
fid = fopen('mask_unwrp.dat','w');
fwrite(fid,mask_unwrp,'uchar');
fclose(fid);

[pathstr, ~, ~] = fileparts(which('3DSRNCP.m'));
setenv('pathstr',pathstr);
setenv('nv',num2str(imsize(1)));
setenv('np',num2str(imsize(2)));
setenv('ns',num2str(imsize(3)));

unph = zeros(imsize);

imsize(4) = 1;
for echo_num = 1:imsize(4)
    setenv('echo_num',num2str(echo_num));
    fid = fopen(['wrapped_phase' num2str(echo_num) '.dat'],'w');
    fwrite(fid,brainPhaseNoisy(:,:,:,echo_num),'float');
    fclose(fid);
    if isdeployed
        bash_script = ['~/bin/3DSRNCP wrapped_phase${echo_num}.dat mask_unwrp.dat ' ...
        'unwrapped_phase${echo_num}.dat $nv $np $ns reliability${echo_num}.dat'];
    else    
        bash_script = ['${pathstr}/3DSRNCP wrapped_phase${echo_num}.dat mask_unwrp.dat ' ...
        'unwrapped_phase${echo_num}.dat $nv $np $ns reliability${echo_num}.dat'];
    end
    unix(bash_script) ;

    fid = fopen(['unwrapped_phase' num2str(echo_num) '.dat'],'r');
    tmp = fread(fid,'float');
    % tmp = tmp - tmp(1);
    unph(:,:,:,echo_num) = reshape(tmp - round(mean(tmp(brainMask==1))/(2*pi))*2*pi -4*pi,imsize(1:3)).*brainMask;
    fclose(fid);

    fid = fopen(['reliability' num2str(echo_num) '.dat'],'r');
    reliability_raw = fread(fid,'float');
    reliability_raw = reshape(reliability_raw,imsize(1:3));
    fclose(fid);

    nii = make_nii(reliability_raw.*brainMask,voxel_size);
    save_nii(nii,['reliability_raw' num2str(echo_num) '.nii']);
end

nii = make_nii(unph,voxel_size);
save_nii(nii,'unph_bestpath.nii');

nii = load_nii('unph_bestpath.nii');
unph = double(nii.img) - 4*pi;

% prelude unwrapping
nii = load_nii('unph_prelude.nii');
unph = double(nii.img) - 4*pi;

% or from traditional tfs (prelude+fitting)
iFreq = unph;
delta_TE = TE;
matrix_size = size(brainMask);
CF = 42.58*3e6;
mask = brainMask;
iMag = brainMagNoisy;
N_std = 1;
% iFreq = unph*TE;

mkdir TFS_TFI_ERO0
cd TFS_TFI_ERO0
% (1) TFI of 0 voxel erosion
Mask = mask; % only brain tissue, need whole head later
Mask_G = Mask;
P_B = 30;
P = 1 * Mask + P_B * (1-Mask);
RDF = 0;
wG = 1;
save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF
QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 600*2);
nii = make_nii(QSM.*Mask,voxel_size);
save_nii(nii,'TFI_ero0_prelude_wG1.nii');
cd ..



%%%% TIK-QSM
mkdir TFS_TIK_ERO0
cd TFS_TIK_ERO0
% tfs_pad = padarray(brainPhase/(gamma*B0*TE),[0 0 20]);
tfs_pad = padarray(iFreq/(gamma*B0*TE),[0 0 20]);

mask_pad = padarray(mask,[0 0 20]);
% R_pad = padarray(R,[0 0 20]);
r=0;
Tik_weight = 1e-8;
TV_weight = 2e-4;
for i = 1:length(Tik_weight)

	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight, voxel_size, B0_dir, 200);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),voxel_size);
	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight) '_NOPRE_200.nii']);
	chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), voxel_size, B0_dir, 2000);
	nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),voxel_size);
	save_nii(nii,['TIK_prelude_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);

end
cd ..

