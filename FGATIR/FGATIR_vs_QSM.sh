# JS subject

/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/BRAVO_pd_4p5s_TI500_2_BRAVO_pd_4p5s_TI500_20181012133350_2.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/T1weighted_Anatomical_9_T1-weighted_Anatomical_20181012133350_9.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/BRAVO_pd_4p5s_TI500_2_BRAVO_pd_4p5s_TI500_20181012133350_2_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/BRAVO_pd_4p5s_TI500_2_BRAVO_pd_4p5s_TI500_20181012133350_2_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear


/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/BRAVO_pd_4p5s_TI500_COR_new_8_BRAVO_pd_4p5s_TI500_COR_new_20181012133350_8.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/T1weighted_Anatomical_9_T1-weighted_Anatomical_20181012133350_9.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/BRAVO_pd_4p5s_TI500_COR_new_8_BRAVO_pd_4p5s_TI500_COR_new_20181012133350_8_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/BRAVO_pd_4p5s_TI500_COR_new_8_BRAVO_pd_4p5s_TI500_COR_new_20181012133350_8_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear


/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/BRAVO_pd_4p5s_TI550_3_BRAVO_pd_4p5s_TI550_20181012133350_3.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/T1weighted_Anatomical_9_T1-weighted_Anatomical_20181012133350_9.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/BRAVO_pd_4p5s_TI550_3_BRAVO_pd_4p5s_TI550_20181012133350_3_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/BRAVO_pd_4p5s_TI550_3_BRAVO_pd_4p5s_TI550_20181012133350_3_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear


/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/BRAVO_pd_4p5s_TI550_COR_4_BRAVO_pd_4p5s_TI500_COR_20181012133350_4.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/T1weighted_Anatomical_9_T1-weighted_Anatomical_20181012133350_9.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/BRAVO_pd_4p5s_TI550_COR_4_BRAVO_pd_4p5s_TI500_COR_20181012133350_4_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/BRAVO_pd_4p5s_TI550_COR_4_BRAVO_pd_4p5s_TI500_COR_20181012133350_4_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear


# QSM 1mm to T1
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/src/mag1.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/T1weighted_Anatomical_9_T1-weighted_Anatomical_20181012133350_9.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.mat -bins 256 -cost mutualinfo -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 12  -interp trilinear
# apply mag MAT FLIRT trans to QSM
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/RESHARP/sus_resharp_tik_0.0001_tv_0.0005_num_500.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/RESHARP/sus_resharp_tik_0.0001_tv_0.0005_num_500_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI1000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI1000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI1500_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI1500_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI2000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI2000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI5000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI5000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz



# QSM 0.75mm to T1
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/src/mag1.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/T1weighted_Anatomical_9_T1-weighted_Anatomical_20181012133350_9.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -bins 256 -cost mutualinfo -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 12  -interp trilinear
# apply mag MAT FLIRT trans to QSM
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/RESHARP/sus_resharp_tik_0.0001_tv_0.0005_num_500.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/RESHARP/sus_resharp_tik_0.0001_tv_0.0005_num_500_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1500_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1500_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI2000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI2000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI5000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI5000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz


# apply mag MAT FLIRT trans to R2*
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/R2.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/R2_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz


# # apply mag MAT FLIRT trans to BET mask
# /usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/BET_mask.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/BET_mask_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz



# ANTs registration
mni=/usr/local/fsl/data/standard/MNI152_T1_1mm.nii.gz

## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/T1weighted_Anatomical_9_T1-weighted_Anatomical_20181012133350_9.nii
ref=$mni
transformPrefix=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/ants_trans_T1_to_MNI
warpedImage=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/Js/14902/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]










# HS subject

/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/BRAVO_pd_4p5s_TI500_2_BRAVO_pd_4p5s_TI500_20181012143413_2.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/T1weighted_Anatomical_5_T1-weighted_Anatomical_20181012143413_5.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/BRAVO_pd_4p5s_TI500_2_BRAVO_pd_4p5s_TI500_20181012143413_2_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/BRAVO_pd_4p5s_TI500_2_BRAVO_pd_4p5s_TI500_20181012143413_2_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear



/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/BRAVO_pd_4p5s_TI500_COR_4_BRAVO_pd_4p5s_TI500_COR_20181012143413_4.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/T1weighted_Anatomical_5_T1-weighted_Anatomical_20181012143413_5.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/BRAVO_pd_4p5s_TI500_COR_4_BRAVO_pd_4p5s_TI500_COR_20181012143413_4_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/BRAVO_pd_4p5s_TI500_COR_4_BRAVO_pd_4p5s_TI500_COR_20181012143413_4_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear



/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/BRAVO_pd_4p5s_TI550_3_BRAVO_pd_4p5s_TI550_20181012143413_3.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/T1weighted_Anatomical_5_T1-weighted_Anatomical_20181012143413_5.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/BRAVO_pd_4p5s_TI550_3_BRAVO_pd_4p5s_TI550_20181012143413_3_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/BRAVO_pd_4p5s_TI550_3_BRAVO_pd_4p5s_TI550_20181012143413_3_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear

# QSM 1mm to T1, then to MNI
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/src/mag1.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/T1weighted_Anatomical_5_T1-weighted_Anatomical_20181012143413_5.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.mat -bins 256 -cost mutualinfo -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 12  -interp trilinear
# apply mag MAT FLIRT trans to QSM
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/RESHARP/sus_resharp_tik_0.0001_tv_0.0005_num_500.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/RESHARP/sus_resharp_tik_0.0001_tv_0.0005_num_500_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI1000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI1000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI1500_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI1500_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI2000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI2000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI5000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI5000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz

# QSM 0.75mm to T1, then to MNI
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/src/mag1.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/T1weighted_Anatomical_5_T1-weighted_Anatomical_20181012143413_5.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -bins 256 -cost mutualinfo -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 12  -interp trilinear
# apply mag MAT FLIRT trans to QSM
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/RESHARP/sus_resharp_tik_0.0001_tv_0.0005_num_500.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/RESHARP/sus_resharp_tik_0.0001_tv_0.0005_num_500_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1500_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1500_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI2000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI2000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI5000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI5000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz

# apply mag MAT FLIRT trans to R2*
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/R2.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/R2_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz



# ANTs registration
mni=/usr/local/fsl/data/standard/MNI152_T1_1mm.nii.gz

## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/T1weighted_Anatomical_5_T1-weighted_Anatomical_20181012143413_5.nii
ref=$mni
transformPrefix=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/ants_trans_T1_to_MNI
warpedImage=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/Hs/14903/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]









# Physio_03016 subject

# QSM 0.75mm to T1, then to MNI
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/src/mag1.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/BRAVO_600_ms_6_BRAVO_600_ms_20180919161434_6.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -bins 256 -cost mutualinfo -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 12  -interp trilinear
# apply mag MAT FLIRT trans to QSM
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/RESHARP/sus_resharp_tik_0.0001_tv_0.0005_num_500.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/RESHARP/sus_resharp_tik_0.0001_tv_0.0005_num_500_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1500_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1500_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI2000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI2000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI5000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI5000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz


# apply mag MAT FLIRT trans to R2*
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/R2.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/R2_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz


# ANTs registration
mni=/usr/local/fsl/data/standard/MNI152_T1_1mm.nii.gz

## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/BRAVO_600_ms_6_BRAVO_600_ms_20180919161434_6.nii
ref=$mni
transformPrefix=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/ants_trans_T1_to_MNI
warpedImage=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/Physio_03016/14754/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# register T1 map to MNI templete
# antsApplyTransforms -d 3 -i $t1m -r $mni -o $t1m_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 







# Dr subject

/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/BRAVO_pd_4p5s_TI500_HS_3_BRAVO_pd_4p5s_TI500_HS_20180925161329_3.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/BRAVO_pd_4p5s_TI500_2_BRAVO_pd_4p5s_TI500_20180925161329_2.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/BRAVO_pd_4p5s_TI500_HS_3_BRAVO_pd_4p5s_TI500_HS_20180925161329_3_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/BRAVO_pd_4p5s_TI500_HS_3_BRAVO_pd_4p5s_TI500_HS_20180925161329_3_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear


/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/BRAVO_pd_4p5s_TI600_4_BRAVO_pd_4p5s_TI600_20180925161329_4.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/BRAVO_pd_4p5s_TI500_2_BRAVO_pd_4p5s_TI500_20180925161329_2.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/BRAVO_pd_4p5s_TI600_4_BRAVO_pd_4p5s_TI600_20180925161329_4_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/BRAVO_pd_4p5s_TI600_4_BRAVO_pd_4p5s_TI600_20180925161329_4_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear


# QSM 1mm to T1, then to MNI
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/src/mag1.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/BRAVO_pd_4p5s_TI500_2_BRAVO_pd_4p5s_TI500_20180925161329_2.nii.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.mat -bins 256 -cost mutualinfo -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 12  -interp trilinear
# apply mag MAT FLIRT trans to QSM
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/RESHARP/sus_resharp_tik_0.0001_tv_0.0005_num_500.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/RESHARP/sus_resharp_tik_0.0001_tv_0.0005_num_500_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI1000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI1000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI1500_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI1500_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI2000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI2000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI5000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/RESHARP/MEDI5000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_1mm/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz

# QSM 0.75mm to T1, then to MNI
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/src/mag1.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/BRAVO_pd_4p5s_TI500_2_BRAVO_pd_4p5s_TI500_20180925161329_2.nii.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -bins 256 -cost mutualinfo -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 12  -interp trilinear
# apply mag MAT FLIRT trans to QSM
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/RESHARP/sus_resharp_tik_0.0001_tv_0.0005_num_500.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/RESHARP/sus_resharp_tik_0.0001_tv_0.0005_num_500_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1500_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1500_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI2000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI2000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI5000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI5000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz


# apply mag MAT FLIRT trans to R2*
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/R2.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/R2_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz



# ANTs registration
mni=/usr/local/fsl/data/standard/MNI152_T1_1mm.nii.gz

## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/BRAVO_pd_4p5s_TI500_2_BRAVO_pd_4p5s_TI500_20180925161329_2.nii
ref=$mni
transformPrefix=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/ants_trans_T1_to_MNI
warpedImage=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/Dr/14792/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]










# B_A subject

/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/BRAVO_pd_4p5s_TI400_7_BRAVO_pd_4p5s_TI400_20181016130759_7.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/T1weighted_Anatomical_9_T1-weighted_Anatomical_20181016130759_9.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/BRAVO_pd_4p5s_TI400_7_BRAVO_pd_4p5s_TI400_20181016130759_7_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/BRAVO_pd_4p5s_TI400_7_BRAVO_pd_4p5s_TI400_20181016130759_7_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear



/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/BRAVO_pd_4p5s_TI450_5_BRAVO_pd_4p5s_TI450_20181016130759_5.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/T1weighted_Anatomical_9_T1-weighted_Anatomical_20181016130759_9.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/BRAVO_pd_4p5s_TI450_5_BRAVO_pd_4p5s_TI450_20181016130759_5_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/BRAVO_pd_4p5s_TI450_5_BRAVO_pd_4p5s_TI450_20181016130759_5_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear



/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/BRAVO_pd_4p5s_TI500_3_BRAVO_pd_4p5s_TI500_20181016130759_3.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/T1weighted_Anatomical_9_T1-weighted_Anatomical_20181016130759_9.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/BRAVO_pd_4p5s_TI500_3_BRAVO_pd_4p5s_TI500_20181016130759_3_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/BRAVO_pd_4p5s_TI500_3_BRAVO_pd_4p5s_TI500_20181016130759_3_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear


/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/BRAVO_TI650_radfb_11_BRAVO_TI650_radfb_20181016130759_11.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/T1weighted_Anatomical_9_T1-weighted_Anatomical_20181016130759_9.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/BRAVO_TI650_radfb_11_BRAVO_TI650_radfb_20181016130759_11_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/BRAVO_TI650_radfb_11_BRAVO_TI650_radfb_20181016130759_11_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear


/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/MEBRAVO_TI500_15_MEBRAVO_TI500_20181016130759_15_e1.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/T1weighted_Anatomical_9_T1-weighted_Anatomical_20181016130759_9.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/MEBRAVO_TI500_15_MEBRAVO_TI500_20181016130759_15_e1_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/MEBRAVO_TI500_15_MEBRAVO_TI500_20181016130759_15_e1_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear



# QSM 0.75mm to T1, then to MNI
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/src/mag1.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/T1weighted_Anatomical_9_T1-weighted_Anatomical_20181016130759_9.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -bins 256 -cost mutualinfo -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 12  -interp trilinear
# apply mag MAT FLIRT trans to QSM
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1500_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1500_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI2000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI2000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI5000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI5000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz

# apply mag MAT FLIRT trans to R2*
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/R2.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/R2_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz



# ANTs registration
mni=/usr/local/fsl/data/standard/MNI152_T1_1mm.nii.gz

## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/T1weighted_Anatomical_9_T1-weighted_Anatomical_20181016130759_9.nii
ref=$mni
transformPrefix=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/ants_trans_T1_to_MNI
warpedImage=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/B_A/14922/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]













# Qmrims_022 subject

/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/BRAVO_pd_4p5s_TI450_5_BRAVO_pd_4p5s_TI450_20181018100507_5.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/T1weighted_Anatomical_9_T1-weighted_Anatomical_20181018100507_9.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/BRAVO_pd_4p5s_TI450_5_BRAVO_pd_4p5s_TI450_20181018100507_5_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/BRAVO_pd_4p5s_TI450_5_BRAVO_pd_4p5s_TI450_20181018100507_5_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear



/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/BRAVO_pd_4p5s_TI500_3_BRAVO_pd_4p5s_TI500_20181018100507_3.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/T1weighted_Anatomical_9_T1-weighted_Anatomical_20181018100507_9.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/BRAVO_pd_4p5s_TI500_3_BRAVO_pd_4p5s_TI500_20181018100507_3_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/BRAVO_pd_4p5s_TI500_3_BRAVO_pd_4p5s_TI500_20181018100507_3_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear



/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/MEBRAVO_TI300_TR4S_11_MEBRAVO_TI300_TR4S_20181018100507_11_e1.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/T1weighted_Anatomical_9_T1-weighted_Anatomical_20181018100507_9.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/MEBRAVO_TI300_TR4S_11_MEBRAVO_TI300_TR4S_20181018100507_11_e1_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/MEBRAVO_TI300_TR4S_11_MEBRAVO_TI300_TR4S_20181018100507_11_e1_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear


/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/MEBRAVO_TI1000_7_MEBRAVO_TI1000_20181018100507_7_e1.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/T1weighted_Anatomical_9_T1-weighted_Anatomical_20181018100507_9.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/MEBRAVO_TI1000_7_MEBRAVO_TI1000_20181018100507_7_e1_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/MEBRAVO_TI1000_7_MEBRAVO_TI1000_20181018100507_7_e1_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear




# QSM 0.75mm to T1, then to MNI
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/src/mag1.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/T1weighted_Anatomical_9_T1-weighted_Anatomical_20181018100507_9.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -bins 256 -cost mutualinfo -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 12  -interp trilinear
# apply mag MAT FLIRT trans to QSM
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1500_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1500_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI2000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI2000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI5000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI5000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz


# apply mag MAT FLIRT trans to R2*
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/R2.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/R2_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz



# ANTs registration
mni=/usr/local/fsl/data/standard/MNI152_T1_1mm.nii.gz

## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/T1weighted_Anatomical_9_T1-weighted_Anatomical_20181018100507_9.nii
ref=$mni
transformPrefix=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/ants_trans_T1_to_MNI
warpedImage=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_022/14946/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]














# Qmrims_025 subject

/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/BRAVO_pd_4p5s_TI450_11_BRAVO_pd_4p5s_TI450_20181023080905_11.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/T1weighted_Anatomical_8_T1-weighted_Anatomical_20181023080905_8.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/BRAVO_pd_4p5s_TI450_11_BRAVO_pd_4p5s_TI450_20181023080905_11_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/BRAVO_pd_4p5s_TI450_11_BRAVO_pd_4p5s_TI450_20181023080905_11_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear



/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/BRAVO_pd_4p5s_TI500_2_BRAVO_pd_4p5s_TI500_20181023080905_2.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/T1weighted_Anatomical_8_T1-weighted_Anatomical_20181023080905_8.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/BRAVO_pd_4p5s_TI500_2_BRAVO_pd_4p5s_TI500_20181023080905_2_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/BRAVO_pd_4p5s_TI500_2_BRAVO_pd_4p5s_TI500_20181023080905_2_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear



/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/MB_TI1p2_TR2p54_4bi_ax_10_MB_TI1p2_TR2p54_4bi_ax_20181023080905_10_e1.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/T1weighted_Anatomical_8_T1-weighted_Anatomical_20181023080905_8.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/MB_TI1p2_TR2p54_4bi_ax_10_MB_TI1p2_TR2p54_4bi_ax_20181023080905_10_e1_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/MB_TI1p2_TR2p54_4bi_ax_10_MB_TI1p2_TR2p54_4bi_ax_20181023080905_10_e1_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear


/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/MB_TI1p2_TR2p54_4uni_ax_4_MB_TI1p2_TR2p54_4uni_ax_20181023080905_4_e1.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/T1weighted_Anatomical_8_T1-weighted_Anatomical_20181023080905_8.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/MB_TI1p2_TR2p54_4uni_ax_4_MB_TI1p2_TR2p54_4uni_ax_20181023080905_4_e1_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/MB_TI1p2_TR2p54_4uni_ax_4_MB_TI1p2_TR2p54_4uni_ax_20181023080905_4_e1_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear




# QSM 0.75mm to T1, then to MNI
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/src/mag1.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/T1weighted_Anatomical_8_T1-weighted_Anatomical_20181023080905_8.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -bins 256 -cost mutualinfo -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 12  -interp trilinear
# apply mag MAT FLIRT trans to QSM
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1500_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1500_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI2000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI2000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI5000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI5000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz


# apply mag MAT FLIRT trans to R2*
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/R2.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/R2_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz




# ANTs registration
mni=/usr/local/fsl/data/standard/MNI152_T1_1mm.nii.gz

## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/T1weighted_Anatomical_8_T1-weighted_Anatomical_20181023080905_8.nii
ref=$mni
transformPrefix=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/ants_trans_T1_to_MNI
warpedImage=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_025/14982/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]











# Qmrims_023 subject

/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/BRAVO_pd_4p5s_TI450_3_BRAVO_pd_4p5s_TI450_20181031110957_3.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/T1weighted_Anatomical_6_T1-weighted_Anatomical_20181031110957_6.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/BRAVO_pd_4p5s_TI450_3_BRAVO_pd_4p5s_TI450_20181031110957_3_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/BRAVO_pd_4p5s_TI450_3_BRAVO_pd_4p5s_TI450_20181031110957_3_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear



/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/MB_TI1p2_TR2p54_4bi_ax_GRAPPA1p5_8_MB_TI1p2_TR2p54_4bi_ax_GRAPPA1p5_20181031110957_8_e1.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/T1weighted_Anatomical_6_T1-weighted_Anatomical_20181031110957_6.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/MB_TI1p2_TR2p54_4bi_ax_GRAPPA1p5_8_MB_TI1p2_TR2p54_4bi_ax_GRAPPA1p5_20181031110957_8_e1_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/MB_TI1p2_TR2p54_4bi_ax_GRAPPA1p5_8_MB_TI1p2_TR2p54_4bi_ax_GRAPPA1p5_20181031110957_8_e1_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear



/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/MB_TI1p15_TR2p54_4bi_ax_5_MB_TI1p15_TR2p54_4bi_ax_20181031110957_5_e1.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/T1weighted_Anatomical_6_T1-weighted_Anatomical_20181031110957_6.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/MB_TI1p15_TR2p54_4bi_ax_5_MB_TI1p15_TR2p54_4bi_ax_20181031110957_5_e1_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/MB_TI1p15_TR2p54_4bi_ax_5_MB_TI1p15_TR2p54_4bi_ax_20181031110957_5_e1_FLIRT.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear




# QSM 0.75mm to T1, then to MNI
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/src/mag1.nii -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/T1weighted_Anatomical_6_T1-weighted_Anatomical_20181031110957_6.nii -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii -omat /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -bins 256 -cost mutualinfo -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 12  -interp trilinear
# apply mag MAT FLIRT trans to QSM
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1500_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI1500_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI2000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI2000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI5000_RESHARP_smvrad3.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/RESHARP/MEDI5000_RESHARP_smvrad3_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz


# apply mag MAT FLIRT trans to R2*
/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/R2.nii -applyxfm -init /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.mat -out /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/R2_FLIRT.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/QSM_p75/QSM_SPGR_GE/src/mag1_FLIRT.nii.gz




# ANTs registration
mni=/usr/local/fsl/data/standard/MNI152_T1_1mm.nii.gz

## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/T1weighted_Anatomical_6_T1-weighted_Anatomical_20181031110957_6.nii
ref=$mni
transformPrefix=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/ants_trans_T1_to_MNI
warpedImage=/Users/hongfusun/DATA/FGATIR/sorted_dicoms/Qmrims_023/15043/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

