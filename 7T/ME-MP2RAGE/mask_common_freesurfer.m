cd /Users/hongfusun/DATA/freesurfer/01EG_R2s/BI-QSM_0p75
nii = load_untouch_nii('r2s_to_mean.nii');
r2s = single(nii.img);
mask1 = (r2s ~= 0);

cd /Users/hongfusun/DATA/freesurfer/01EG_R2s/ME-MP2RAGE_0p75
nii = load_untouch_nii('r2s_to_mean.nii');
r2s = single(nii.img);
mask2 = (r2s ~= 0);

mask = mask1.*mask2;
nii = make_nii(mask);
save_nii(nii,'/Users/hongfusun/DATA/freesurfer/01EG_R2s/mask.nii')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd /Users/hongfusun/DATA/freesurfer/03JK_QSM/BI-QSM_0p75
nii = load_untouch_nii('qsm_to_mean.nii');
qsm = single(nii.img);
mask1 = (qsm ~= 0);

cd /Users/hongfusun/DATA/freesurfer/03JK_QSM/ME-MP2RAGE_0p75
nii = load_untouch_nii('qsm_to_mean.nii');
qsm = single(nii.img);
mask2 = (qsm ~= 0);

mask = mask1.*mask2;
nii = make_nii(mask);
save_nii(nii,'/Users/hongfusun/DATA/freesurfer/03JK_QSM/mask.nii')


