

# register SE-MP2RAGE to ME-MP2RAGE
/home/hongfu/bin/mricrogl_lx/dcm2niix -f UNIDEN -o /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/UNI-DEN /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/UNI-DEN/1.7.72.2.1.2.21/dicom_series
/home/hongfu/bin/mricrogl_lx/dcm2niix -f T1map -o /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/T1 /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/T1/1.7.72.2.1.2.20/dicom_series

UNI_SE='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32.nii'
UNI_ME='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii'
UNI_SE_to_ME='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32_SE_to_ME.nii.gz'
mat_UNI_SE_to_ME='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/UNI-DEN/UNI_SE_to_ME_12DOF_normcorr_adj.mat'
UNI_SE_to_ME_brain='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32_SE_to_ME_brain.nii.gz'
T1_SE='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/T1/T1map_c32.nii'
T1_SE_to_ME='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/T1/T1map_c32_SE_to_ME.nii.gz'
T1_SE_to_ME_brain='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/T1/T1map_c32_SE_to_ME_brain.nii.gz'
UNI_SE_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32_SE_to_ME_to_MNI.nii.gz'
T1_SE_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/T1/T1map_c32_SE_to_ME_to_MNI.nii.gz'
flirt -in $UNI_SE -ref $UNI_ME -out $UNI_SE_to_ME -omat $mat_UNI_SE_to_ME -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in $T1_SE -applyxfm -init $mat_UNI_SE_to_ME -out $T1_SE_to_ME -paddingsize 0.0 -interp trilinear -ref $UNI_ME
mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
transformPrefix=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI
# skull stripping of UNIDEN and T1m
BET_mask=/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/BET_mask_adj.nii 
fslmaths $UNI_SE_to_ME -mas $BET_mask $UNI_SE_to_ME_brain
fslmaths $T1_SE_to_ME -mas $BET_mask $T1_SE_to_ME_brain
antsApplyTransforms -d 3 -i $UNI_SE_to_ME_brain -r $mni_brain -o $UNI_SE_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $T1_SE_to_ME_brain -r $mni_brain -o $T1_SE_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 





/home/hongfu/bin/mricrogl_lx/dcm2niix -f UNIDEN -o /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/UNI-DEN /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/UNI-DEN/1.7.72.3.1.3.6/dicom_series
/home/hongfu/bin/mricrogl_lx/dcm2niix -f T1map -o /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/T1 /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/T1/1.7.72.3.1.3.5/dicom_series

UNI_SE='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32.nii'
UNI_ME='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii'
UNI_SE_to_ME='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32_SE_to_ME.nii.gz'
mat_UNI_SE_to_ME='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/UNI-DEN/UNI_SE_to_ME_12DOF_normcorr_adj.mat'
UNI_SE_to_ME_brain='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32_SE_to_ME_brain.nii.gz'
T1_SE='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/T1/T1map_c32.nii'
T1_SE_to_ME='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/T1/T1map_c32_SE_to_ME.nii.gz'
T1_SE_to_ME_brain='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/T1/T1map_c32_SE_to_ME_brain.nii.gz'
UNI_SE_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32_SE_to_ME_to_MNI.nii.gz'
T1_SE_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/T1/T1map_c32_SE_to_ME_to_MNI.nii.gz'
flirt -in $UNI_SE -ref $UNI_ME -out $UNI_SE_to_ME -omat $mat_UNI_SE_to_ME -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in $T1_SE -applyxfm -init $mat_UNI_SE_to_ME -out $T1_SE_to_ME -paddingsize 0.0 -interp trilinear -ref $UNI_ME
mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
transformPrefix=/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI
# skull stripping of UNIDEN and T1m
BET_mask=/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/BET_mask_adj.nii 
fslmaths $UNI_SE_to_ME -mas $BET_mask $UNI_SE_to_ME_brain
fslmaths $T1_SE_to_ME -mas $BET_mask $T1_SE_to_ME_brain
antsApplyTransforms -d 3 -i $UNI_SE_to_ME_brain -r $mni_brain -o $UNI_SE_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $T1_SE_to_ME_brain -r $mni_brain -o $T1_SE_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
# antsApplyTransforms -d 3 -i $UNI_SE_to_ME -r $mni_brain -o $UNI_SE_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
# antsApplyTransforms -d 3 -i $T1_SE_to_ME -r $mni_brain -o $T1_SE_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 




/home/hongfu/bin/mricrogl_lx/dcm2niix -f UNIDEN -o /scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/UNI-DEN /scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/UNI-DEN/1.7.72.5.1.3.20/dicom_series
/home/hongfu/bin/mricrogl_lx/dcm2niix -f T1map -o /scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/T1 /scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/T1/1.7.72.5.1.3.19/dicom_series

UNI_SE='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32.nii'
UNI_ME='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii'
UNI_SE_to_ME='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32_SE_to_ME.nii.gz'
mat_UNI_SE_to_ME='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/UNI-DEN/UNI_SE_to_ME_12DOF_normcorr_adj.mat'
UNI_SE_to_ME_brain='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32_SE_to_ME_brain.nii.gz'
T1_SE='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/T1/T1map_c32.nii'
T1_SE_to_ME='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/T1/T1map_c32_SE_to_ME.nii.gz'
T1_SE_to_ME_brain='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/T1/T1map_c32_SE_to_ME_brain.nii.gz'
UNI_SE_to_MNI='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32_SE_to_ME_to_MNI.nii.gz'
T1_SE_to_MNI='/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/T1/T1map_c32_SE_to_ME_to_MNI.nii.gz'
flirt -in $UNI_SE -ref $UNI_ME -out $UNI_SE_to_ME -omat $mat_UNI_SE_to_ME -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in $T1_SE -applyxfm -init $mat_UNI_SE_to_ME -out $T1_SE_to_ME -paddingsize 0.0 -interp trilinear -ref $UNI_ME
mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
transformPrefix=/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI
# skull stripping of UNIDEN and T1m
BET_mask=/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/BET_mask_adj.nii 
fslmaths $UNI_SE_to_ME -mas $BET_mask $UNI_SE_to_ME_brain
fslmaths $T1_SE_to_ME -mas $BET_mask $T1_SE_to_ME_brain
antsApplyTransforms -d 3 -i $UNI_SE_to_ME_brain -r $mni_brain -o $UNI_SE_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $T1_SE_to_ME_brain -r $mni_brain -o $T1_SE_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 






/home/hongfu/bin/mricrogl_lx/dcm2niix -f UNIDEN -o /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/UNI-DEN /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/UNI-DEN/1.7.72.4.1.2.8/dicom_series
/home/hongfu/bin/mricrogl_lx/dcm2niix -f T1map -o /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/T1 /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/T1/1.7.72.4.1.2.7/dicom_series

UNI_SE='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32.nii'
UNI_ME='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii'
UNI_SE_to_ME='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32_SE_to_ME.nii.gz'
mat_UNI_SE_to_ME='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/UNI-DEN/UNI_SE_to_ME_12DOF_normcorr_adj.mat'
UNI_SE_to_ME_brain='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32_SE_to_ME_brain.nii.gz'
T1_SE='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/T1/T1map_c32.nii'
T1_SE_to_ME='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/T1/T1map_c32_SE_to_ME.nii.gz'
T1_SE_to_ME_brain='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/T1/T1map_c32_SE_to_ME_brain.nii.gz'
UNI_SE_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32_SE_to_ME_to_MNI.nii.gz'
T1_SE_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/T1/T1map_c32_SE_to_ME_to_MNI.nii.gz'
flirt -in $UNI_SE -ref $UNI_ME -out $UNI_SE_to_ME -omat $mat_UNI_SE_to_ME -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in $T1_SE -applyxfm -init $mat_UNI_SE_to_ME -out $T1_SE_to_ME -paddingsize 0.0 -interp trilinear -ref $UNI_ME
mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
transformPrefix=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI
# skull stripping of UNIDEN and T1m
BET_mask=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/BET_mask_adj.nii 
fslmaths $UNI_SE_to_ME -mas $BET_mask $UNI_SE_to_ME_brain
fslmaths $T1_SE_to_ME -mas $BET_mask $T1_SE_to_ME_brain
antsApplyTransforms -d 3 -i $UNI_SE_to_ME_brain -r $mni_brain -o $UNI_SE_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $T1_SE_to_ME_brain -r $mni_brain -o $T1_SE_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
# antsApplyTransforms -d 3 -i $UNI_SE_to_ME -r $mni_brain -o $UNI_SE_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
# antsApplyTransforms -d 3 -i $T1_SE_to_ME -r $mni_brain -o $T1_SE_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 







/home/hongfu/bin/mricrogl_lx/dcm2niix -f UNIDEN -o /home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/UNI-DEN /home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/UNI-DEN/1.10.3.74.1.7.8/dicom_series
/home/hongfu/bin/mricrogl_lx/dcm2niix -f T1map -o /home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/T1 /home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/T1/1.10.3.74.1.7.7/dicom_series

UNI_SE='/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/UNI-DEN/UNIDEN_c32.nii'
UNI_ME='/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/UNIDEN_comboecho/20171031_141844mp2rage0p75BiPlos4TEVariedBWtx220s015a4001.nii'
UNI_SE_to_ME='/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/UNI-DEN/UNIDEN_c32_SE_to_ME.nii.gz'
mat_UNI_SE_to_ME='/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/UNI-DEN/UNI_SE_to_ME_12DOF_normcorr_adj.mat'
UNI_SE_to_ME_brain='/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/UNI-DEN/UNIDEN_c32_SE_to_ME_brain.nii.gz'
T1_SE='/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/T1/T1map_c32.nii'
T1_SE_to_ME='/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/T1/T1map_c32_SE_to_ME.nii.gz'
T1_SE_to_ME_brain='/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/T1/T1map_c32_SE_to_ME_brain.nii.gz'
UNI_SE_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/UNI-DEN/UNIDEN_c32_SE_to_ME_to_MNI.nii.gz'
T1_SE_to_MNI='/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/T1/T1map_c32_SE_to_ME_to_MNI.nii.gz'
flirt -in $UNI_SE -ref $UNI_ME -out $UNI_SE_to_ME -omat $mat_UNI_SE_to_ME -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in $T1_SE -applyxfm -init $mat_UNI_SE_to_ME -out $T1_SE_to_ME -paddingsize 0.0 -interp trilinear -ref $UNI_ME
mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
transformPrefix=/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/UNIDEN_comboecho/ants_trans_T1_to_MNI
# skull stripping of UNIDEN and T1m
BET_mask=/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/BET_mask_adj.nii 
fslmaths $UNI_SE_to_ME -mas $BET_mask $UNI_SE_to_ME_brain
fslmaths $T1_SE_to_ME -mas $BET_mask $T1_SE_to_ME_brain
antsApplyTransforms -d 3 -i $UNI_SE_to_ME_brain -r $mni_brain -o $UNI_SE_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $T1_SE_to_ME_brain -r $mni_brain -o $T1_SE_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
# antsApplyTransforms -d 3 -i $UNI_SE_to_ME -r $mni_brain -o $UNI_SE_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
# antsApplyTransforms -d 3 -i $T1_SE_to_ME -r $mni_brain -o $T1_SE_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 



