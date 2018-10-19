

qsm_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii'
qsm_memp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii'
qsm_bi_to_memp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_bi2memp2rage.nii.gz'
mat_bi_to_memp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/qsm_bi2memp2rage_12DOF_normcorr_adj.mat'
r2s_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/QSM_MEGE_7T/R2_adj.nii'
r2s_bi_to_memp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_bi2memp2rage.nii.gz'
qsm_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii.gz'
r2s_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_bi2memp2rage_to_MNI.nii.gz'
flirt -in $qsm_bi -ref $qsm_memp2rage -out $qsm_bi_to_memp2rage -omat $mat_bi_to_memp2rage -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in $r2s_bi -applyxfm -init $mat_bi_to_memp2rage -out $r2s_bi_to_memp2rage -paddingsize 0.0 -interp trilinear -ref $qsm_memp2rage
mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
transformPrefix=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $qsm_bi_to_memp2rage -r $mni_brain -o $qsm_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $r2s_bi_to_memp2rage -r $mni_brain -o $r2s_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 




qsm_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii'
qsm_memp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii'
qsm_bi_to_memp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_bi2memp2rage.nii.gz'
mat_bi_to_memp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/qsm_bi2memp2rage_12DOF_normcorr_adj.mat'
r2s_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/QSM_MEGE_7T/R2_adj.nii'
r2s_bi_to_memp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_bi2memp2rage.nii.gz'
qsm_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii.gz'
r2s_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_bi2memp2rage_to_MNI.nii.gz'
flirt -in $qsm_bi -ref $qsm_memp2rage -out $qsm_bi_to_memp2rage -omat $mat_bi_to_memp2rage -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in $r2s_bi -applyxfm -init $mat_bi_to_memp2rage -out $r2s_bi_to_memp2rage -paddingsize 0.0 -interp trilinear -ref $qsm_memp2rage
mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
transformPrefix=/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $qsm_bi_to_memp2rage -r $mni_brain -o $qsm_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $r2s_bi_to_memp2rage -r $mni_brain -o $r2s_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 




qsm_bi='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii'
qsm_memp2rage='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii'
qsm_bi_to_memp2rage='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_bi2memp2rage.nii.gz'
mat_bi_to_memp2rage='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/qsm_bi2memp2rage_12DOF_normcorr_adj.mat'
r2s_bi='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/QSM_MEGE_7T/R2_adj.nii'
r2s_bi_to_memp2rage='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_bi2memp2rage.nii.gz'
qsm_bi_to_MNI='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii.gz'
r2s_bi_to_MNI='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_bi2memp2rage_to_MNI.nii.gz'
flirt -in $qsm_bi -ref $qsm_memp2rage -out $qsm_bi_to_memp2rage -omat $mat_bi_to_memp2rage -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in $r2s_bi -applyxfm -init $mat_bi_to_memp2rage -out $r2s_bi_to_memp2rage -paddingsize 0.0 -interp trilinear -ref $qsm_memp2rage
mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
transformPrefix=/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $qsm_bi_to_memp2rage -r $mni_brain -o $qsm_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $r2s_bi_to_memp2rage -r $mni_brain -o $r2s_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 




qsm_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii'
qsm_memp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii'
qsm_bi_to_memp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_bi2memp2rage.nii.gz'
mat_bi_to_memp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/qsm_bi2memp2rage_12DOF_normcorr_adj.mat'
r2s_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/QSM_MEGE_7T/R2_adj.nii'
r2s_bi_to_memp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_bi2memp2rage.nii.gz'
qsm_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii.gz'
r2s_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_bi2memp2rage_to_MNI.nii.gz'
flirt -in $qsm_bi -ref $qsm_memp2rage -out $qsm_bi_to_memp2rage -omat $mat_bi_to_memp2rage -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in $r2s_bi -applyxfm -init $mat_bi_to_memp2rage -out $r2s_bi_to_memp2rage -paddingsize 0.0 -interp trilinear -ref $qsm_memp2rage
mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
transformPrefix=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $qsm_bi_to_memp2rage -r $mni_brain -o $qsm_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $r2s_bi_to_memp2rage -r $mni_brain -o $r2s_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 




qsm_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii'
qsm_memp2rage='/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii'
qsm_bi_to_memp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_bi2memp2rage.nii.gz'
mat_bi_to_memp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/qsm_bi2memp2rage_12DOF_normcorr_adj.mat'
r2s_bi='/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/QSM_MEGE_7T/R2_adj.nii'
r2s_bi_to_memp2rage='/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_bi2memp2rage.nii.gz'
qsm_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii.gz'
r2s_bi_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_bi2memp2rage_to_MNI.nii.gz'
flirt -in $qsm_bi -ref $qsm_memp2rage -out $qsm_bi_to_memp2rage -omat $mat_bi_to_memp2rage -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in $r2s_bi -applyxfm -init $mat_bi_to_memp2rage -out $r2s_bi_to_memp2rage -paddingsize 0.0 -interp trilinear -ref $qsm_memp2rage
mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
transformPrefix=/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/UNIDEN_comboecho/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $qsm_bi_to_memp2rage -r $mni_brain -o $qsm_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $r2s_bi_to_memp2rage -r $mni_brain -o $r2s_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 


