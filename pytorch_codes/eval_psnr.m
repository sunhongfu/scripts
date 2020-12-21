% evaluate the PSNR and SSIM
ilsqr_left = '/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_LEFT/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad1.nii';
ilsqr_right = '/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_RIGHT/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad1.nii';
ilsqr_central = '/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_CENTER/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad1.nii';
ilsqr_forward = '/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_FORWARD/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad1.nii';
ilsqr_backward = '/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_BACKWARD/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad1.nii';

% different methods
method1 = 'casnet_mixed_alldirs';
method2 = 'casnet2_mixed_alldirs';
method3 = 'casnet3_mixed_alldirs';
method4 = 'image_unet_stack_prjs_alldirs';
method5 = 'multiple_prjs_unet_alldirs';
method6 = 'unet_mixed_alldirs';
method7 = 'unrolledQSM_alldirs';
method8 = 'unrolledQSM_masked_alldirs';

methods = {method1, method2, method3, method4, method5, method6, method7, method8};

for i = 1:length(methods)
    dl_left = ['/Volumes/LaCie/CommQSM/invivo/testing/' methods{i} '/renzo_left_' methods{i} '.nii'];
    dl_right = ['/Volumes/LaCie/CommQSM/invivo/testing/' methods{i} '/renzo_right_' methods{i} '.nii'];
    dl_central = ['/Volumes/LaCie/CommQSM/invivo/testing/' methods{i} '/renzo_central_' methods{i} '.nii'];
    dl_forward = ['/Volumes/LaCie/CommQSM/invivo/testing/' methods{i} '/renzo_forward_' methods{i} '.nii'];
    dl_backward = ['/Volumes/LaCie/CommQSM/invivo/testing/' methods{i} '/renzo_backward_' methods{i} '.nii'];
    dl_central_bigAngle = ['/Volumes/LaCie/CommQSM/invivo/testing/' methods{i} '/renzo_central_bigAngle_' methods{i} '.nii'];





