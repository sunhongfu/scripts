clear
load raw.mat

for echo_num = 1:9
    fid = fopen(['/Volumes/LaCie_Bottom/collaborators/Fatima_Nasrallah/20221011/BBB_019/BBB-019_MEGRE_QSM_16_e' num2str(echo_num) '.json']); % Opening the file
    raw = fread(fid,inf); % Reading the contents
    str = char(raw'); % Transformation
    fclose(fid);
    header = jsondecode(str);
    TE(echo_num) = header.EchoTime;
end

mkdir QSM_individual
cd QSM_individual 

% nii = load_nii('../QSM_new/unph.nii');
% unph = single(nii.img);

% nii = load_nii('../QSM_new/fit_residual_blur0.nii');
% fit_residual_blur = single(nii.img);

% nii = load_nii('../QSM_new/mask_thr.nii');
% mask = single(nii.img);

% % [tfs1, fit_residual1] = echofit(unph,mag,TE,1); 
% % nii = make_nii(tfs1,voxel_size);
% % save_nii(nii,'tfs1.nii');
% % nii = make_nii(fit_residual1,voxel_size);
% % save_nii(nii,'fit_residual1.nii');

% r_mask = 1;
% fit_thr = 20;
% % extra filtering according to fitting residuals
% if r_mask
%     % generate reliability map
%     R = ones(size(fit_residual_blur));
%     R(fit_residual_blur >= fit_thr) = 0;
% else
%     R = 1;
% end



% disp('--> RESHARP to remove background field ...');
smv_rad = 3;
% tik_reg = 1e-4;
cgs_num = 200;
% tv_reg = 2e-4;
% z_prjs = B0_dir;
% inv_num = 500;

nii = load_untouch_nii(['/Volumes/LaCie_Bottom/collaborators/Fatima_Nasrallah/20221011/BBB_019/BBB-019_MEGRE_QSM_15_e1.nii']);

z_prjs = nii.hdr.hist.srow_z(1:3)./nii.hdr.dime.pixdim(2:4)
voxel_size = nii.hdr.dime.pixdim(2:4)
imsize = size(nii.img)


for echo = 1:size(unph,4)
    [phase_resharp(:,:,:,echo), mask_resharp] = resharp_stencil(unph(:,:,:,echo),mask.*R_0,voxel_size,smv_rad,tik_reg,cgs_num);
end

nii = make_nii(phase_resharp, voxel_size);
save_nii(nii,'phase_resharp.nii')

% iLSQR method
for echo = 1:size(unph,4)
    chi_iLSQR(:,:,:,echo) = QSM_iLSQR(phase_resharp(:,:,:,echo),mask_resharp,'H',z_prjs,'voxelsize',voxel_size,'niter',50,'TE',TE(echo)*1000,'B0',3);
end
nii = make_nii(chi_iLSQR,voxel_size);
save_nii(nii,'chi_iLSQR_all.nii');





% remember to add folder "decomposeQSMv0.6.2" to MATLAB path
%%% required input
% input mag and qsm can be 3D or 4D, with the last dimension being the time
% magAll = niftiread('sample_data/test_mag.nii'); 
% qsmAll = niftiread('sample_data/test_QSM.nii');
% load('sample_data/acq_param.mat'); % contains TE, B0 info
%%% set saving directory
savename='./decompose_results/test'; 
% path connect to the prefix of the outout file name
% outputs inside folder './decompose_results' are 
%       test_PCS.nii, test_DCS.nii, test_decompose_maps.mat

%%% set up number of CPUs and compute
parallel_flag = 4; % 24 threads of CPUs

% [PCS, DCS, Composite_susc] = decompose_qsm_arr_v06(magAll, qsmAll, TE, B0, savename, parallel_flag, paraV, maxIter)
% paraV, maxIter are optional see helper file _decompose_qsm_arr_v06.m
[PCS, DCS, composite_chi] = decompose_qsm_arr_v06(mag_corr, chi_iLSQR, TE*1000, 3, savename, parallel_flag);

nii = make_nii(PCS, voxel_size);
save_nii(nii,'./decompose_results/PCS.nii');

nii = make_nii(-DCS, voxel_size);
save_nii(nii,'./decompose_results/DCS.nii');


nii = make_nii(composite_chi, voxel_size);
save_nii(nii,'./decompose_results/composite_chi.nii');

nii = make_nii(PCS+DCS, voxel_size);
save_nii(nii,'./decompose_results/composite_chi2.nii');

% TRY TO ERODE MORE VOXELS, MATCHING PREVIOUS RESULTS IN QSM_NEW FOLDER
% SHOW THE RESULTS TO JEFF AND TY
