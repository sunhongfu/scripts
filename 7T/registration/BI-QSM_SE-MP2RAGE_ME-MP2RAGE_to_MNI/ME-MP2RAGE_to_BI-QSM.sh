

# register 0.75 ME-MP2RAGE to 0.75 bi-qsm (one subject)
# subject 01EG
qsm_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii'
qsm_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz'
r2s_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/QSM_MEGE_7T/R2_adj.nii'
r2s_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_to_MNI.nii.gz'
qsm_memp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii'
qsm_memp2rage_to_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_memp2rage2bi.nii.gz'
qsm_memp2rage_to_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_memp2rage2bi_to_MNI.nii.gz'
mat_memp2rage_to_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/qsm_memp2rage2bi_12DOF_normcorr_adj.mat'
r2s_memp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj.nii'
r2s_memp2rage_to_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_memp2rage2bi.nii.gz'
r2s_memp2rage_to_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_memp2rage2bi_to_MNI.nii.gz'
uniden_mp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/t1_brain.nii.gz'
uniden_mp2rage_to_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/UNIDEN/uniden_memp2rage_to_bi.nii.gz'
# register all 0.75mm single-echo MP2RAGE to 0.75mm ME-MP2RAGE, then to MNI
flirt -in $qsm_memp2rage -ref $qsm_bi -out $qsm_memp2rage_to_bi -omat $mat_memp2rage_to_bi -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in $r2s_memp2rage -applyxfm -init $mat_memp2rage_to_bi -out $r2s_memp2rage_to_bi -paddingsize 0.0 -interp trilinear -ref $qsm_bi
flirt -in $uniden_mp2rage -applyxfm -init $mat_memp2rage_to_bi -out $uniden_mp2rage_to_bi -paddingsize 0.0 -interp trilinear -ref $qsm_bi
# antsreg uniden_mp2rage_to_bi to MNI, then apply to QSM and R2* of 0.75_bi and 0.75MEMP2RAGE_to_bi
## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
src=$uniden_mp2rage_to_bi
ref=$mni_brain
transformPrefix=/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/UNIDEN/ants_trans_T1_to_MNI
warpedImage=/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/UNIDEN/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# apply to QSM/R2* of 0.75 bi and 0.75MEMP2RAGE_to_bi
# register QSM to MNI templete
antsApplyTransforms -d 3 -i $qsm_bi -r $mni_brain -o $qsm_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $qsm_memp2rage_to_bi -r $mni_brain -o $qsm_memp2rage_to_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

# register R2* map to MNI templete
antsApplyTransforms -d 3 -i $r2s_bi -r $mni_brain -o $r2s_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $r2s_memp2rage_to_bi -r $mni_brain -o $r2s_memp2rage_to_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 







# register 0.75 ME-MP2RAGE to 0.75 bi-qsm (one subject)
# subject 02SCOTT
qsm_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii'
qsm_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz'
r2s_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/QSM_MEGE_7T/R2_adj.nii'
r2s_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_to_MNI.nii.gz'
qsm_memp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii'
qsm_memp2rage_to_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_memp2rage2bi.nii.gz'
qsm_memp2rage_to_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_memp2rage2bi_to_MNI.nii.gz'
mat_memp2rage_to_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/qsm_memp2rage2bi_12DOF_normcorr_adj.mat'
r2s_memp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj.nii'
r2s_memp2rage_to_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_memp2rage2bi.nii.gz'
r2s_memp2rage_to_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_memp2rage2bi_to_MNI.nii.gz'
uniden_mp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/t1_brain.nii.gz'
uniden_mp2rage_to_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/UNIDEN/uniden_memp2rage_to_bi.nii.gz'
# register all 0.75mm single-echo MP2RAGE to 0.75mm ME-MP2RAGE, then to MNI
flirt -in $qsm_memp2rage -ref $qsm_bi -out $qsm_memp2rage_to_bi -omat $mat_memp2rage_to_bi -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in $r2s_memp2rage -applyxfm -init $mat_memp2rage_to_bi -out $r2s_memp2rage_to_bi -paddingsize 0.0 -interp trilinear -ref $qsm_bi
flirt -in $uniden_mp2rage -applyxfm -init $mat_memp2rage_to_bi -out $uniden_mp2rage_to_bi -paddingsize 0.0 -interp trilinear -ref $qsm_bi
# antsreg uniden_mp2rage_to_bi to MNI, then apply to QSM and R2* of 0.75_bi and 0.75MEMP2RAGE_to_bi
## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
src=$uniden_mp2rage_to_bi
ref=$mni_brain
transformPrefix=/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/UNIDEN/ants_trans_T1_to_MNI
warpedImage=/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/UNIDEN/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# apply to QSM/R2* of 0.75 bi and 0.75MEMP2RAGE_to_bi
# register QSM to MNI templete
antsApplyTransforms -d 3 -i $qsm_bi -r $mni_brain -o $qsm_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $qsm_memp2rage_to_bi -r $mni_brain -o $qsm_memp2rage_to_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

# register R2* map to MNI templete
antsApplyTransforms -d 3 -i $r2s_bi -r $mni_brain -o $r2s_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $r2s_memp2rage_to_bi -r $mni_brain -o $r2s_memp2rage_to_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 







# subject 03JK
qsm_bi='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii'
qsm_bi_to_MNI='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz'
r2s_bi='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/QSM_MEGE_7T/R2_adj.nii'
r2s_bi_to_MNI='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_to_MNI.nii.gz'
qsm_memp2rage='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii'
qsm_memp2rage_to_bi='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_memp2rage2bi.nii.gz'
qsm_memp2rage_to_bi_to_MNI='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_memp2rage2bi_to_MNI.nii.gz'
mat_memp2rage_to_bi='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/qsm_memp2rage2bi_12DOF_normcorr_adj.mat'
r2s_memp2rage='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj.nii'
r2s_memp2rage_to_bi='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_memp2rage2bi.nii.gz'
r2s_memp2rage_to_bi_to_MNI='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_memp2rage2bi_to_MNI.nii.gz'
uniden_mp2rage='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/t1_brain.nii.gz'
uniden_mp2rage_to_bi='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/UNIDEN/uniden_memp2rage_to_bi.nii.gz'
# register all 0.75mm single-echo MP2RAGE to 0.75mm ME-MP2RAGE, then to MNI
flirt -in $qsm_memp2rage -ref $qsm_bi -out $qsm_memp2rage_to_bi -omat $mat_memp2rage_to_bi -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in $r2s_memp2rage -applyxfm -init $mat_memp2rage_to_bi -out $r2s_memp2rage_to_bi -paddingsize 0.0 -interp trilinear -ref $qsm_bi
flirt -in $uniden_mp2rage -applyxfm -init $mat_memp2rage_to_bi -out $uniden_mp2rage_to_bi -paddingsize 0.0 -interp trilinear -ref $qsm_bi
# antsreg uniden_mp2rage_to_bi to MNI, then apply to QSM and R2* of 0.75_bi and 0.75MEMP2RAGE_to_bi
## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
src=$uniden_mp2rage_to_bi
ref=$mni_brain
transformPrefix=/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/UNIDEN/ants_trans_T1_to_MNI
warpedImage=/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/UNIDEN/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# apply to QSM/R2* of 0.75 bi and 0.75MEMP2RAGE_to_bi
# register QSM to MNI templete
antsApplyTransforms -d 3 -i $qsm_bi -r $mni_brain -o $qsm_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $qsm_memp2rage_to_bi -r $mni_brain -o $qsm_memp2rage_to_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

# register R2* map to MNI templete
antsApplyTransforms -d 3 -i $r2s_bi -r $mni_brain -o $r2s_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $r2s_memp2rage_to_bi -r $mni_brain -o $r2s_memp2rage_to_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 






# register 0.75 ME-MP2RAGE to 0.75 bi-qsm (one subject)
# subject 05SG
qsm_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii'
qsm_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz'
r2s_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/QSM_MEGE_7T/R2_adj.nii'
r2s_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_to_MNI.nii.gz'
qsm_memp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii'
qsm_memp2rage_to_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_memp2rage2bi.nii.gz'
qsm_memp2rage_to_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_memp2rage2bi_to_MNI.nii.gz'
mat_memp2rage_to_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/qsm_memp2rage2bi_12DOF_normcorr_adj.mat'
r2s_memp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj.nii'
r2s_memp2rage_to_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_memp2rage2bi.nii.gz'
r2s_memp2rage_to_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_memp2rage2bi_to_MNI.nii.gz'
uniden_mp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/t1_brain.nii.gz'
uniden_mp2rage_to_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/UNIDEN/uniden_memp2rage_to_bi.nii.gz'
# register all 0.75mm single-echo MP2RAGE to 0.75mm ME-MP2RAGE, then to MNI
flirt -in $qsm_memp2rage -ref $qsm_bi -out $qsm_memp2rage_to_bi -omat $mat_memp2rage_to_bi -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in $r2s_memp2rage -applyxfm -init $mat_memp2rage_to_bi -out $r2s_memp2rage_to_bi -paddingsize 0.0 -interp trilinear -ref $qsm_bi
flirt -in $uniden_mp2rage -applyxfm -init $mat_memp2rage_to_bi -out $uniden_mp2rage_to_bi -paddingsize 0.0 -interp trilinear -ref $qsm_bi
# antsreg uniden_mp2rage_to_bi to MNI, then apply to QSM and R2* of 0.75_bi and 0.75MEMP2RAGE_to_bi
## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
src=$uniden_mp2rage_to_bi
ref=$mni_brain
transformPrefix=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/UNIDEN/ants_trans_T1_to_MNI
warpedImage=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/UNIDEN/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# apply to QSM/R2* of 0.75 bi and 0.75MEMP2RAGE_to_bi
# register QSM to MNI templete
antsApplyTransforms -d 3 -i $qsm_bi -r $mni_brain -o $qsm_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $qsm_memp2rage_to_bi -r $mni_brain -o $qsm_memp2rage_to_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

# register R2* map to MNI templete
antsApplyTransforms -d 3 -i $r2s_bi -r $mni_brain -o $r2s_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $r2s_memp2rage_to_bi -r $mni_brain -o $r2s_memp2rage_to_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 







# subject 07JON
qsm_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii'
qsm_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz'
r2s_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/QSM_MEGE_7T/R2_adj.nii'
r2s_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_to_MNI.nii.gz'
qsm_memp2rage='/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii'
qsm_memp2rage_to_bi='/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_memp2rage2bi.nii.gz'
qsm_memp2rage_to_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_memp2rage2bi_to_MNI.nii.gz'
mat_memp2rage_to_bi='/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/RESHARP/qsm_memp2rage2bi_12DOF_normcorr_adj.mat'
r2s_memp2rage='/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/R2_I2_adj.nii'
r2s_memp2rage_to_bi='/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/R2_I2_adj_memp2rage2bi.nii.gz'
r2s_memp2rage_to_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/R2_I2_adj_memp2rage2bi_to_MNI.nii.gz'
uniden_mp2rage='/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/UNIDEN_comboecho/t1_brain.nii.gz'
uniden_mp2rage_to_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/UNIDEN/uniden_memp2rage_to_bi.nii.gz'
# register all 0.75mm single-echo MP2RAGE to 0.75mm ME-MP2RAGE, then to MNI
flirt -in $qsm_memp2rage -ref $qsm_bi -out $qsm_memp2rage_to_bi -omat $mat_memp2rage_to_bi -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in $r2s_memp2rage -applyxfm -init $mat_memp2rage_to_bi -out $r2s_memp2rage_to_bi -paddingsize 0.0 -interp trilinear -ref $qsm_bi
flirt -in $uniden_mp2rage -applyxfm -init $mat_memp2rage_to_bi -out $uniden_mp2rage_to_bi -paddingsize 0.0 -interp trilinear -ref $qsm_bi
# antsreg uniden_mp2rage_to_bi to MNI, then apply to QSM and R2* of 0.75_bi and 0.75MEMP2RAGE_to_bi
## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
src=$uniden_mp2rage_to_bi
ref=$mni_brain
transformPrefix=/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/UNIDEN/ants_trans_T1_to_MNI
warpedImage=/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/UNIDEN/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# apply to QSM/R2* of 0.75 bi and 0.75MEMP2RAGE_to_bi
# register QSM to MNI templete
antsApplyTransforms -d 3 -i $qsm_bi -r $mni_brain -o $qsm_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $qsm_memp2rage_to_bi -r $mni_brain -o $qsm_memp2rage_to_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

# register R2* map to MNI templete
antsApplyTransforms -d 3 -i $r2s_bi -r $mni_brain -o $r2s_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $r2s_memp2rage_to_bi -r $mni_brain -o $r2s_memp2rage_to_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 




