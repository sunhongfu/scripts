cd /Users/hongfusun/DATA/paper_revision/flip_angle_memp2rage/4-5_MEvsSE/ME
!gunzip *.gz
% load in the segments of CSF=1, GM=2, WM=3
nii = load_untouch_nii('BET_seg.nii');
segs = single(nii.img);
% generate masks
msk_csf = (segs==1);
msk_gm = (segs==2);
msk_wm = (segs==3);

% load in the registered uniden of multi-echo
nii2 = load_untouch_nii('mag_to_mean.nii');
uni_me = single(nii2.img);

% load in the registered uniden of single-echo
cd /Users/hongfusun/DATA/paper_revision/flip_angle_memp2rage/4-5_MEvsSE/SE
nii3 = load_untouch_nii('mag_to_mean.nii');
uni_se = single(nii3.img);

% measurements
mean_csf_me = mean(uni_me(msk_csf(:)))
mean_csf_se = mean(uni_se(msk_csf(:)))
median_csf_me = median(uni_me(msk_csf(:)))
median_csf_se = median(uni_se(msk_csf(:)))
std_csf_me = std(uni_me(msk_csf(:)))
std_csf_se = std(uni_se(msk_csf(:)))

mean_wm_me = mean(uni_me(msk_wm(:)))
mean_wm_se = mean(uni_se(msk_wm(:)))
median_wm_me = median(uni_me(msk_wm(:)))
median_wm_se = median(uni_se(msk_wm(:)))
std_wm_me = std(uni_me(msk_wm(:)))
std_wm_se = std(uni_se(msk_wm(:)))

mean_gm_me = mean(uni_me(msk_gm(:)))
mean_gm_se = mean(uni_se(msk_gm(:)))
median_gm_me = median(uni_me(msk_gm(:)))
median_gm_se = median(uni_se(msk_gm(:)))
std_gm_me = std(uni_me(msk_gm(:)))
std_gm_se = std(uni_se(msk_gm(:)))

% boxplot of everything
boxplot([uni_me(msk_csf(:)); uni_se(msk_csf(:)); uni_me(msk_wm(:)); uni_se(msk_wm(:)); uni_me(msk_gm(:)); uni_se(msk_gm(:))],[1,2,3,4,5,6]')
data = [uni_me(msk_csf(:)); uni_se(msk_csf(:)); uni_me(msk_wm(:)); uni_se(msk_wm(:)); uni_me(msk_gm(:)); uni_se(msk_gm(:))];
grp = [zeros(1,sum(msk_csf(:))), ones(1,sum(msk_csf(:))), 2*ones(1,sum(msk_wm(:))), 3*ones(1,sum(msk_wm(:))), 4*ones(1,sum(msk_gm(:))), 5*ones(1,sum(msk_gm(:)))]';



cd /Users/hongfusun/DATA/paper_revision/flip_angle_memp2rage/4-5
nii = load_untouch_nii('uniden_comb.nii');
img = single(nii.img);
img = padarray(img,[0 0 1],'post');
img = flipdim(flipdim(img,1),2);
nii_new = make_nii(img,[0.75 0.75 0.75]);
save_nii(nii_new,'uniden_new.nii');


cd /Users/hongfusun/DATA/paper_revision/flip_angle_memp2rage/8-10
nii = load_untouch_nii('uniden_comb_8-10.nii');
img = single(nii.img);
img = padarray(img,[0 0 1],'post');
img = flipdim(flipdim(img,1),2);
nii_new = make_nii(img,[0.75 0.75 0.75]);
save_nii(nii_new,'uniden_new.nii');


#####################################################################
# register SUN 4_bi MEMP2RAGE to 9_bi MEGRE
cd /Users/hongfusun/DATA/paper_revision/r2s_residual/SUN/4_bi
mri_convert -vs 0.75 0.75 0.75 mag_corr1.nii mag_corr1.mgz
mri_convert -vs 0.75 0.75 0.75 R2.nii R2.mgz

cd /Users/hongfusun/DATA/paper_revision/r2s_residual/SUN/9_GRE
mri_convert -vs 0.75 0.75 0.75 mag_corr1_n4.nii mag_corr1_n4.mgz
mri_convert -vs 0.75 0.75 0.75 R2.nii R2.mgz
mri_convert -vs 0.75 0.75 0.75 R2_3echoes.nii R2_3echoes.mgz
mri_convert -vs 0.75 0.75 0.75 R2_4echoes.nii R2_4echoes.mgz

cd /Users/hongfusun/DATA/paper_revision/r2s_residual/SUN
mri_robust_template --mov 4_bi/mag_corr1.mgz 9_GRE/mag_corr1_n4.mgz --template mag_mean.mgz --lta 4_bi/mp2_lta.lta 9_GRE/gre_lta.lta --mapmov 4_bi/mag_to_mean.mgz 9_GRE/mag_to_mean.mgz --average 0 --iscale --satit
mri_convert 4_bi/mag_to_mean.mgz 4_bi/mag_to_mean.nii
mri_convert 9_GRE/mag_to_mean.mgz 9_GRE/mag_to_mean.nii


cd 4_bi
mri_convert -at mp2_lta.lta R2.mgz R2_to_gre.mgz
mri_convert R2_to_gre.mgz R2_to_gre.nii

cd ..
cd 9_GRE
mri_convert -at gre_lta.lta R2.mgz R2_to_mp2.mgz
mri_convert R2_to_mp2.mgz R2_to_mp2.nii

mri_convert -at gre_lta.lta R2_3echoes.mgz R2_3echoes_to_mp2.mgz
mri_convert R2_3echoes_to_mp2.mgz R2_3echoes_to_mp2.nii

mri_convert -at gre_lta.lta R2_4echoes.mgz R2_4echoes_to_mp2.mgz
mri_convert R2_4echoes_to_mp2.mgz R2_4echoes_to_mp2.nii

cd /Users/hongfusun/DATA/paper_revision/r2s_residual/SUN/4_bi
nii = load_untouch_nii('dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181128110350_11.nii');
img = single(nii.img);
img = padarray(img,[0 0 1],'post');
img = flipdim(flipdim(img,1),2);
nii_new = make_nii(img,[0.75 0.75 0.75]);
save_nii(nii_new,'uniden_new.nii');

mri_convert -vs 0.75 0.75 0.75 uniden_new.nii uniden_new.mgz
mri_convert -at mp2_lta.lta uniden_new.mgz uniden_new_to_gre.mgz
mri_convert uniden_new_to_gre.mgz uniden_new_to_gre.nii

# BET first
cd /Users/hongfusun/DATA/paper_revision/r2s_residual/SUN/4_bi
bet2 uniden_new_to_gre.nii BET -f 0.2 -m -w 2
gunzip -f *.nii.gz


/usr/local/fsl/bin/fast -t 1 -n 3 -H 0.1 -I 4 -l 20.0 -g -B -b -o BET BET

# segment the GM and WM
cd /Users/hongfusun/DATA/paper_revision/r2s_residual/SUN/4_bi
fslmaths 'R2_to_gre.nii' -mas 'BET_seg_1.nii.gz' 'R2_to_gre_GM.nii'
fslmaths 'R2_to_gre.nii' -mas 'BET_seg_2.nii.gz' 'R2_to_gre_WM.nii'
gunzip -f *.nii.gz

cd /Users/hongfusun/DATA/paper_revision/r2s_residual/SUN/9_GRE
fslmaths 'R2_to_mp2.nii' -mas 'BET_seg_1.nii' 'R2_to_mp2_GM.nii'
fslmaths 'R2_to_mp2.nii' -mas 'BET_seg_2.nii' 'R2_to_mp2_WM.nii'
fslmaths 'R2_3echoes_to_mp2.nii' -mas 'BET_seg_1.nii' 'R2_3echoes_to_mp2_GM.nii'
fslmaths 'R2_3echoes_to_mp2.nii' -mas 'BET_seg_2.nii' 'R2_3echoes_to_mp2_WM.nii'
fslmaths 'R2_4echoes_to_mp2.nii' -mas 'BET_seg_1.nii' 'R2_4echoes_to_mp2_GM.nii'
fslmaths 'R2_4echoes_to_mp2.nii' -mas 'BET_seg_2.nii' 'R2_4echoes_to_mp2_WM.nii'
gunzip -f *.nii.gz

#####################################################################



# register the two flip angles
mri_convert -vs 0.75 0.75 0.75 4-5/R2.nii 4-5/R2.mgz
mri_convert -vs 0.75 0.75 0.75 4-5/chi_iLSQR_smvrad2.nii 4-5/chi_iLSQR_smvrad2.mgz
mri_convert -vs 0.75 0.75 0.75 4-5/uniden_new.nii 4-5/uniden_new.mgz

mri_convert -vs 0.75 0.75 0.75 8-10/R2.nii 8-10/R2.mgz
mri_convert -vs 0.75 0.75 0.75 8-10/chi_iLSQR_smvrad2_8-10.nii 8-10/chi_iLSQR_smvrad2.mgz
mri_convert -vs 0.75 0.75 0.75 8-10/uniden_new.nii 8-10/uniden_new.mgz

mri_robust_template --mov 4-5/uniden_new.mgz 8-10/uniden_new.mgz --template mag_mean.mgz --lta 4-5/45_lta.lta 8-10/810_lta.lta --mapmov 4-5/mag_to_mean.mgz 8-10/mag_to_mean.mgz --average 0 --iscale --satit

mri_convert 4-5/mag_to_mean.mgz 4-5/mag_to_mean.nii
mri_convert 8-10/mag_to_mean.mgz 8-10/mag_to_mean.nii

cd 4-5
mri_convert -at 45_lta.lta R2.mgz R2_to_810.mgz
mri_convert -at 45_lta.lta chi_iLSQR_smvrad2.mgz chi_to_810.mgz
mri_convert R2_to_810.mgz R2_to_810.nii
mri_convert chi_to_810.mgz chi_to_810.nii

cd ..
cd 8-10
mri_convert -at 810_lta.lta R2.mgz R2_to_45.mgz
mri_convert -at 810_lta.lta chi_iLSQR_smvrad2.mgz chi_to_45.mgz
mri_convert R2_to_45.mgz R2_to_45.nii
mri_convert chi_to_45.mgz chi_to_45.nii

# FAST segmentation
# BET first
cd /Users/hongfusun/DATA/paper_revision/flip_angle_memp2rage/4-5
bet2 mag_to_mean.nii BET -f 0.3 -m -w 2
gunzip -f *.nii.gz
cd /Users/hongfusun/DATA/paper_revision/flip_angle_memp2rage/8-10
bet2 mag_to_mean.nii BET -f 0.3 -m -w 2
gunzip -f *.nii.gz


cd /Users/hongfusun/DATA/paper_revision/flip_angle_memp2rage
# compare the bias-field correction
N4BiasFieldCorrection -i 4-5/mag_to_mean.nii -x 4-5/BET_mask.nii -r 1 -o [4-5/mag_to_mean_N4corr.nii, 4-5/mag_to_mean_N4bias.nii]
N4BiasFieldCorrection -i 8-10/mag_to_mean.nii -x 8-10/BET_mask.nii -r 1 -o [8-10/mag_to_mean_N4corr.nii, 8-10/mag_to_mean_N4bias.nii]



/usr/local/fsl/bin/fast -t 1 -n 3 -H 0.1 -I 4 -l 20.0 -g -B -b -o /Users/hongfusun/DATA/paper_revision/flip_angle_memp2rage/4-5/BET /Users/hongfusun/DATA/paper_revision/flip_angle_memp2rage/4-5/BET





# register SE with ME
cd /Users/hongfusun/DATA/paper_revision/flip_angle_memp2rage/4-5_MEvsSE/SE
nii = load_untouch_nii('uniden.nii');
img = single(nii.img);
img = flipdim(flipdim(img,1),2);
nii_new = make_nii(img,[0.75 0.75 0.75]);
save_nii(nii_new,'uniden_new.nii');

# copy '/Users/hongfusun/DATA/paper_revision/flip_angle_memp2rage/4-5' to ME

# register and comparing ME with SE (for uniden image)
cd /Users/hongfusun/DATA/paper_revision/flip_angle_memp2rage/4-5_MEvsSE
mri_convert -vs 0.75 0.75 0.75 SE/uniden_new.nii SE/uniden_new.mgz
mri_convert -vs 0.75 0.75 0.75 ME/uniden_new.nii ME/uniden_new.mgz

mri_robust_template --mov SE/uniden_new.mgz ME/uniden_new.mgz --template mag_mean.mgz --lta SE/SE_lta.lta ME/ME_lta.lta --mapmov SE/mag_to_mean.mgz ME/mag_to_mean.mgz --average 0 --iscale --satit

mri_convert ME/mag_to_mean.mgz ME/mag_to_mean.nii
mri_convert SE/mag_to_mean.mgz SE/mag_to_mean.nii

# compare the bias-field correction
N4BiasFieldCorrection -i ME/mag_to_mean.nii -o [ME/mag_to_mean_N4corr.nii, ME/mag_to_mean_N4bias.nii]
N4BiasFieldCorrection -i SE/mag_to_mean.nii -o [SE/mag_to_mean_N4corr.nii, SE/mag_to_mean_N4bias.nii]


# FAST
# BET first
cd /Users/hongfusun/DATA/paper_revision/flip_angle_memp2rage/4-5_MEvsSE/ME
bet2 mag_to_mean.nii BET -f 0.3 -m

/usr/local/fsl/bin/fast -t 1 -n 3 -H 0.1 -I 4 -l 20.0 -g -B -b -o /Users/hongfusun/DATA/paper_revision/flip_angle_memp2rage/4-5_MEvsSE/ME/BET /Users/hongfusun/DATA/paper_revision/flip_angle_memp2rage/4-5_MEvsSE/ME/BET


load('raw.mat','mag_corr','TE','mask','imsize','vox');
[R2 T2 amp] = r2imgfit(double(mag_corr),TE,repmat(mask,[1 1 1 9]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');



load('raw.mat','mag_corr','TE','mask','imsize','vox');
[R2 T2 amp] = r2imgfit(double(mag_corr(:,:,:,1:3)),TE(1:3),repmat(mask,[1 1 1 3]));
nii = make_nii(R2,vox);
save_nii(nii,'R2_3echoes.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2_3echoes.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp_3echoes.nii');


load('raw.mat','mag_corr','TE','mask','imsize','vox');
[R2 T2 amp] = r2imgfit(double(mag_corr(:,:,:,1:4)),TE(1:4),repmat(mask,[1 1 1 4]));
nii = make_nii(R2,vox);
save_nii(nii,'R2_4echoes.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2_4echoes.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp_4echoes.nii');


load('raw.mat','mag_corr','TE','mask','imsize','vox');
[R2 T2 amp] = r2imgfit(double(mag_corr(:,:,:,1:4)),TE(1:4),repmat(mask,[1 1 1 4]));
nii = make_nii(R2,vox);
save_nii(nii,'R2_4echoes.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2_4echoes.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp_4echoes.nii');




load('raw.mat','mag_corr','TE','mask','imsize','vox');
[R2 T2 amp] = r2imgfit(double(mag_corr),TE,repmat(mask,[1 1 1 4]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');


load('all_new.mat','mag_corr','TE','mask','imsize','vox');
[R2 T2 amp sse F] = r2imgfit(double(mag_corr),TE,repmat(mask,[1 1 1 4]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');
nii = make_nii(sse,vox);
save_nii(nii,'sse.nii');
nii = make_nii(F,vox);
save_nii(nii,'F.nii');


load('all_new.mat','mag_corr','TE','mask','imsize','vox');
[R2 T2 amp sse] = r2imgfit(double(mag_corr),TE,repmat(mask,[1 1 1 9]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');
nii = make_nii(sse,vox);
save_nii(nii,'sse.nii');



load('all_new.mat','mag_corr','TE','mask','imsize','vox');
mag_corr = mag_corr(:,:,:,1:3);
TE = TE(1:3);
[R2 T2 amp sse] = r2imgfit(double(mag_corr),TE,repmat(mask,[1 1 1 3]));
nii = make_nii(R2,vox);
save_nii(nii,'R2_3echo.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2_3echo.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp_3echo.nii');
nii = make_nii(sse,vox);
save_nii(nii,'sse_3echo.nii');



########## magnitude and QSM

cd 3_mono/
mri_convert -vs 0.75 0.75 0.75 mag_corr1.nii mag_corr1.mgz
mri_convert -vs 0.75 0.75 0.75 chi_iLSQR_smvrad2.nii chi_iLSQR_smvrad2.mgz


cd ..
mri_robust_template --mov 4_bi/mag_corr1.mgz 3_mono/mag_corr1.mgz --template mag_mean.mgz --lta 4_bi/bi_lta.lta 3_mono/mono_lta.lta --mapmov 4_bi/mag_to_mean.mgz 3_mono/mag_to_mean.mgz --average 0 --iscale --satit

mri_convert 3_mono/mag_to_mean.mgz 3_mono/mag_to_mean.nii
mri_convert 4_bi/mag_to_mean.mgz 4_bi/mag_to_mean.nii

mri_convert -at 3_mono/mono_lta.lta 3_mono/chi_iLSQR_smvrad2.mgz 3_mono/chi_registered_to_4bi.mgz
mri_convert -at 4_bi/bi_lta.lta 4_bi/chi_iLSQR_smvrad2.mgz 4_bi/chi_registered_to_3mono.mgz

mri_convert 3_mono/chi_registered_to_4bi.mgz 3_mono/chi_registered_to_4bi.nii
mri_convert 4_bi/chi_registered_to_3mono.mgz 4_bi/chi_registered_to_3mono.nii



# another subject (~/DATA/freesurfer/Sun_14_2179/ME-MP2RAGE)
cd 4_bi
mri_convert -vs 0.75 0.75 0.75 mag_corr1.nii mag_corr1.mgz
mri_convert -vs 0.75 0.75 0.75 chi_iLSQR_smvrad2.nii chi_iLSQR_smvrad2.mgz

cd ../6_bi_swapped
mri_convert -vs 0.75 0.75 0.75 mag_corr1.nii mag_corr1.mgz
mri_convert -vs 0.75 0.75 0.75 chi_iLSQR_smvrad2.nii chi_iLSQR_smvrad2.mgz

cd ..
mri_robust_template --mov 4_bi/mag_corr1.mgz 6_bi_swapped/mag_corr1.mgz --template mag_mean.mgz --lta 4_bi/bi_lta.lta 6_bi_swapped/6_bi_swapped_lta.lta --mapmov 4_bi/mag_to_mean.mgz 6_bi_swapped/mag_to_mean.mgz --average 0 --iscale --satit


mri_convert 6_bi_swapped/mag_to_mean.mgz 6_bi_swapped/mag_to_mean.nii
mri_convert 4_bi/mag_to_mean.mgz 4_bi/mag_to_mean.nii

mri_convert -at 6_bi_swapped/6_bi_swapped_lta.lta 6_bi_swapped/chi_iLSQR_smvrad2.mgz 6_bi_swapped/chi_registered_to_4bi.mgz
mri_convert -at 4_bi/bi_lta.lta 4_bi/chi_iLSQR_smvrad2.mgz 4_bi/chi_registered_to_6bi_swapped.mgz

mri_convert 6_bi_swapped/chi_registered_to_4bi.mgz 6_bi_swapped/chi_registered_to_4bi.nii
mri_convert 4_bi/chi_registered_to_6bi_swapped.mgz 4_bi/chi_registered_to_6bi_swapped.nii




mri_convert -vs 0.75 0.75 0.75 6_bi_swapped/R2.nii 6_bi_swapped/R2.mgz
mri_convert -vs 0.75 0.75 0.75 4_bi/R2.nii 4_bi/R2.mgz

mri_convert -at 6_bi_swapped/6_bi_swapped_lta.lta 6_bi_swapped/R2.mgz 6_bi_swapped/R2_to_4bi.mgz
mri_convert -at 4_bi/bi_lta.lta 4_bi/R2.mgz 4_bi/R2_to_6bi_swapped.mgz

mri_convert 6_bi_swapped/R2_to_4bi.mgz 6_bi_swapped/R2_to_4bi.nii
mri_convert 4_bi/R2_to_6bi_swapped.mgz 4_bi/R2_to_6bi_swapped.nii





######### R2*

cd 3_mono/
mri_convert -vs 0.75 0.75 0.75 R2.nii R2.mgz
cd ..
cd 4_bi/
mri_convert -vs 0.75 0.75 0.75 R2.nii R2.mgz

mri_convert -at 3_mono/mono_lta.lta 3_mono/R2.mgz 3_mono/R2_to_4bi.mgz
mri_convert -at 4_bi/bi_lta.lta 4_bi/R2.mgz 4_bi/R2_to_3mono.mgz

mri_convert 3_mono/R2_to_4bi.mgz 3_mono/R2_to_4bi.nii
mri_convert 4_bi/R2_to_3mono.mgz 4_bi/R2_to_3mono.nii


######### UNIDEN

cd 3_mono/
mri_convert -vs 0.75 0.75 0.75 dicom_series_mp2rage-wip944_0p75MonoPlos3TEMatchedtoSE_20181127102251_57.nii uniden.mgz
cd ..
cd 4_bi/
mri_convert -vs 0.75 0.75 0.75 dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181127102251_11.nii uniden.mgz

cd ..
mri_robust_template --mov 4_bi/uniden.mgz 3_mono/uniden.mgz --template mag_mean.mgz --lta 4_bi/bi_lta.lta 3_mono/mono_lta.lta --mapmov 4_bi/uniden_to_mean.mgz 3_mono/uniden_to_mean.mgz --average 0 --iscale --satit

mri_convert 3_mono/uniden_to_mean.mgz 3_mono/uniden_to_mean.nii
mri_convert 4_bi/uniden_to_mean.mgz 4_bi/uniden_to_mean.nii






# register 4_bi with 4_mono_swapped
# for subject ~/DATA/freesurfer/Tuccio_525/ME-MP2RAGE
mri_robust_template --mov 4_bi/mag_corr1.mgz 4_mono_swapped/mag_corr1.mgz --template mag_mean.mgz --lta 4_bi/bi_lta.lta 4_mono_swapped/mono_lta.lta --mapmov 4_bi/mag_to_mean.mgz 4_mono_swapped/mag_to_mean.mgz --average 0 --iscale --satit


cd 4_mono_swapped
mri_convert -vs 0.75 0.75 0.75 R2.nii R2.mgz
mri_convert -at mono_lta.lta R2.mgz R2_to_4bi.mgz
mri_convert R2_to_4bi.mgz R2_to_4bi.nii

cd ../4_bi
mri_convert -at bi_lta.lta R2.mgz R2_to_4mono_swapped.mgz
mri_convert R2_to_4mono_swapped.mgz R2_to_4mono_swapped.nii






# register the R2* from 9-echo BI-GRE (3 echoes and all 9 echoes) with ME-MP2RAGE
cd /Users/hongfusun/DATA/paper_revision/r2s_residual/01EG

mri_convert -vs 0.75 0.75 0.75 BI_GRE/R2.nii BI_GRE/R2.mgz
mri_convert -vs 0.75 0.75 0.75 BI_GRE/R2_3echo.nii BI_GRE/R2_3echo.mgz
mri_convert -vs 0.75 0.75 0.75 BI_GRE/sse.nii BI_GRE/sse.mgz
mri_convert -vs 0.75 0.75 0.75 BI_GRE/sse_3echo.nii BI_GRE/sse_3echo.mgz
mri_convert -vs 0.75 0.75 0.75 BI_GRE/mag_corr1_n4.nii BI_GRE/mag_corr1_n4.mgz

mri_convert -vs 0.75 0.75 0.75 ME-MP2RAGE/R2.nii ME-MP2RAGE/R2.mgz
mri_convert -vs 0.75 0.75 0.75 ME-MP2RAGE/sse.nii ME-MP2RAGE/sse.mgz
mri_convert -vs 0.75 0.75 0.75 ME-MP2RAGE/mag_corr1_n4.nii ME-MP2RAGE/mag_corr1_n4.mgz

mri_robust_template --mov BI_GRE/mag_corr1_n4.mgz ME-MP2RAGE/mag_corr1_n4.mgz --template mag_mean.mgz --lta BI_GRE/bi_lta.lta ME-MP2RAGE/mp2_lta.lta --mapmov BI_GRE/mag_to_mean.mgz ME-MP2RAGE/mag_to_mean.mgz --average 0 --iscale --satit

# apply trans to R2* and SSE
cd BI_GRE
mri_convert -at bi_lta.lta R2.mgz R2_to_mp2.mgz
mri_convert -at bi_lta.lta R2_3echo.mgz R2_3echo_to_mp2.mgz
mri_convert -at bi_lta.lta sse.mgz sse_to_mp2.mgz
mri_convert -at bi_lta.lta sse_3echo.mgz sse_3echo_to_mp2.mgz

mri_convert R2_to_mp2.mgz R2_to_mp2.nii
mri_convert R2_3echo_to_mp2.mgz R2_3echo_to_mp2.nii
mri_convert sse_to_mp2.mgz sse_to_mp2.nii
mri_convert sse_3echo_to_mp2.mgz sse_3echo_to_mp2.nii

cd ..

cd ME-MP2RAGE
mri_convert -at mp2_lta.lta R2.mgz R2_to_bi.mgz
mri_convert -at mp2_lta.lta sse.mgz sse_to_bi.mgz

mri_convert R2_to_bi.mgz R2_to_bi.nii
mri_convert sse_to_bi.mgz sse_to_bi.nii

cd ..
# generage mask using FSLMATH
fslmaths BI_GRE/R2_to_mp2.nii -bin BI_GRE/R2_to_mp2_mask.nii
fslmaths ME-MP2RAGE/R2_to_bi.nii -bin ME-MP2RAGE/R2_to_bi_mask.nii



