# register all COSMOS to 03JK COSMOS
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=/Volumes/LaCie/COSMOS_7T/01EG/cosmos_5_12DOF_cgs_smvrad2_1mm.nii
ref=/Volumes/LaCie/COSMOS_7T/03JK/cosmos_5_12DOF_cgs_smvrad2_1mm.nii
mkdir /Volumes/LaCie/COSMOS_7T/01EG/ants_brain_1mm_to_03JK
transformPrefix=/Volumes/LaCie/COSMOS_7T/01EG/ants_brain_1mm_to_03JK/ants_to_03JK
warpedImage=/Volumes/LaCie/COSMOS_7T/01EG/ants_brain_1mm_to_03JK/ants_to_03JK.nii.gz
############################################################################
# src=$t1
# ref=$mni
# mkdir /Volumes/LaCie/COSMOS_7T/01EG/ants_head
# transformPrefix=/Volumes/LaCie/COSMOS_7T/01EG/ants_head/ants_trans_T1_to_MNI
# warpedImage=/Volumes/LaCie/COSMOS_7T/01EG//ants_head/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]










# apply ANTs registration to MNI
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/01EG/cosmos_5_12DOF_cgs_smvrad2_1mm.nii','/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/deeplearning/DeepQSM_Recon_01EG.nii','/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/deeplearning/QSMnet+_Recon_01EG.nii','/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_NoisyTrain_Recon_01EG.nii','/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_Recon_01EG.nii','/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/deeplearning/xQSM_syn_Recon_01EG.nii','/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2.nii','/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2.nii','/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
# note that ants_trans_T1_to_MNI: t1_brain is already registered to QSM_neutral
# so this is equivlent to qsm_neutral_to_MNI
# therefore as long as other images are registerd to QSM_neutral
# can apply this ants_trans_T1_to_MNI to morpy into MNI space

mni_brain=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
cosmos=/Volumes/LaCie/COSMOS_7T/01EG/cosmos_5_12DOF_cgs_smvrad2_1mm_adj.nii
cosmos_to_mni=/Volumes/LaCie/COSMOS_7T/01EG/cosmos_5_12DOF_cgs_smvrad2_1mm_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/01EG/ants_brain_1mm_to_03JK/_T1_to_MNI
antsApplyTransforms -d 3 -i $cosmos -r $mni_brain -o $cosmos_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

deepqsm=/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/deeplearning/DeepQSM_Recon_01EG_adj.nii
deepqsm_to_mni=/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/deeplearning/DeepQSM_Recon_01EG_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/01EG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $deepqsm -r $mni_brain -o $deepqsm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

qsmnet=/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/deeplearning/QSMnet+_Recon_01EG_adj.nii
qsmnet_to_mni=/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/deeplearning/QSMnet+_Recon_01EG_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/01EG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $qsmnet -r $mni_brain -o $qsmnet_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo_noisy=/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_NoisyTrain_Recon_01EG_adj.nii
xqsm_invivo_noisy_to_mni=/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_NoisyTrain_Recon_01EG_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/01EG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $xqsm_invivo_noisy -r $mni_brain -o $xqsm_invivo_noisy_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo=/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_Recon_01EG_adj.nii
xqsm_invivo_to_mni=/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_Recon_01EG_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/01EG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $xqsm_invivo -r $mni_brain -o $xqsm_invivo_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_syn=/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/deeplearning/xQSM_syn_Recon_01EG_adj.nii
xqsm_syn_to_mni=/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/deeplearning/xQSM_syn_Recon_01EG_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/01EG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $xqsm_syn -r $mni_brain -o $xqsm_syn_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

iLSQR=/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii
iLSQR_to_mni=/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/01EG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $iLSQR -r $mni_brain -o $iLSQR_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

MEDI=/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_adj.nii
MEDI_to_mni=/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/01EG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $MEDI -r $mni_brain -o $MEDI_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 








nii_coord_adj('/Volumes/LaCie/COSMOS_7T/02SCOTT/cosmos_5_12DOF_cgs_smvrad2.nii','/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/deeplearning/DeepQSM_Recon_02SCOTT.nii','/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/deeplearning/QSMnet+_Recon_02SCOTT.nii','/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_NoisyTrain_Recon_02SCOTT.nii','/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_Recon_02SCOTT.nii','/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/deeplearning/xQSM_syn_Recon_02SCOTT.nii','/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2.nii','/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2.nii','/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
# note that ants_trans_T1_to_MNI: t1_brain is already registered to QSM_neutral
# so this is equivlent to qsm_neutral_to_MNI
# therefore as long as other images are registerd to QSM_neutral
# can apply this ants_trans_T1_to_MNI to morpy into MNI space

mni_brain=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
cosmos=/Volumes/LaCie/COSMOS_7T/02SCOTT/cosmos_5_12DOF_cgs_smvrad2_adj.nii
cosmos_to_mni=/Volumes/LaCie/COSMOS_7T/02SCOTT/cosmos_5_12DOF_cgs_smvrad2_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/02SCOTT/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $cosmos -r $mni_brain -o $cosmos_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

deepqsm=/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/deeplearning/DeepQSM_Recon_02SCOTT_adj.nii
deepqsm_to_mni=/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/deeplearning/DeepQSM_Recon_02SCOTT_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/02SCOTT/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $deepqsm -r $mni_brain -o $deepqsm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

qsmnet=/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/deeplearning/QSMnet+_Recon_02SCOTT_adj.nii
qsmnet_to_mni=/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/deeplearning/QSMnet+_Recon_02SCOTT_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/02SCOTT/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $qsmnet -r $mni_brain -o $qsmnet_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo_noisy=/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_NoisyTrain_Recon_02SCOTT_adj.nii
xqsm_invivo_noisy_to_mni=/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_NoisyTrain_Recon_02SCOTT_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/02SCOTT/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $xqsm_invivo_noisy -r $mni_brain -o $xqsm_invivo_noisy_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo=/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_Recon_02SCOTT_adj.nii
xqsm_invivo_to_mni=/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_Recon_02SCOTT_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/02SCOTT/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $xqsm_invivo -r $mni_brain -o $xqsm_invivo_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_syn=/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/deeplearning/xQSM_syn_Recon_02SCOTT_adj.nii
xqsm_syn_to_mni=/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/deeplearning/xQSM_syn_Recon_02SCOTT_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/02SCOTT/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $xqsm_syn -r $mni_brain -o $xqsm_syn_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

iLSQR=/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii
iLSQR_to_mni=/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/02SCOTT/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $iLSQR -r $mni_brain -o $iLSQR_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

MEDI=/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_adj.nii
MEDI_to_mni=/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/02SCOTT/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $MEDI -r $mni_brain -o $MEDI_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 











nii_coord_adj('/Volumes/LaCie/COSMOS_7T/03JK/cosmos_5_12DOF_cgs_smvrad2.nii','/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/deeplearning/DeepQSM_Recon_03JK.nii','/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/deeplearning/QSMnet+_Recon_03JK.nii','/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_NoisyTrain_Recon_03JK.nii','/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_Recon_03JK.nii','/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/deeplearning/xQSM_syn_Recon_03JK.nii','/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2.nii','/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2.nii','/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
# note that ants_trans_T1_to_MNI: t1_brain is already registered to QSM_neutral
# so this is equivlent to qsm_neutral_to_MNI
# therefore as long as other images are registerd to QSM_neutral
# can apply this ants_trans_T1_to_MNI to morpy into MNI space

mni_brain=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
cosmos=/Volumes/LaCie/COSMOS_7T/03JK/cosmos_5_12DOF_cgs_smvrad2_adj.nii
cosmos_to_mni=/Volumes/LaCie/COSMOS_7T/03JK/cosmos_5_12DOF_cgs_smvrad2_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/03JK/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $cosmos -r $mni_brain -o $cosmos_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

deepqsm=/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/deeplearning/DeepQSM_Recon_03JK_adj.nii
deepqsm_to_mni=/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/deeplearning/DeepQSM_Recon_03JK_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/03JK/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $deepqsm -r $mni_brain -o $deepqsm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

qsmnet=/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/deeplearning/QSMnet+_Recon_03JK_adj.nii
qsmnet_to_mni=/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/deeplearning/QSMnet+_Recon_03JK_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/03JK/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $qsmnet -r $mni_brain -o $qsmnet_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo_noisy=/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_NoisyTrain_Recon_03JK_adj.nii
xqsm_invivo_noisy_to_mni=/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_NoisyTrain_Recon_03JK_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/03JK/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $xqsm_invivo_noisy -r $mni_brain -o $xqsm_invivo_noisy_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo=/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_Recon_03JK_adj.nii
xqsm_invivo_to_mni=/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_Recon_03JK_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/03JK/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $xqsm_invivo -r $mni_brain -o $xqsm_invivo_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_syn=/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/deeplearning/xQSM_syn_Recon_03JK_adj.nii
xqsm_syn_to_mni=/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/deeplearning/xQSM_syn_Recon_03JK_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/03JK/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $xqsm_syn -r $mni_brain -o $xqsm_syn_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

iLSQR=/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii
iLSQR_to_mni=/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/03JK/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $iLSQR -r $mni_brain -o $iLSQR_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

MEDI=/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_adj.nii
MEDI_to_mni=/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/03JK/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $MEDI -r $mni_brain -o $MEDI_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 













nii_coord_adj('/Volumes/LaCie/COSMOS_7T/04JG/cosmos_5_12DOF_cgs_smvrad2.nii','/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/deeplearning/DeepQSM_Recon_04JG.nii','/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/deeplearning/QSMnet+_Recon_04JG.nii','/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_NoisyTrain_Recon_04JG.nii','/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_Recon_04JG.nii','/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/deeplearning/xQSM_syn_Recon_04JG.nii','/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2.nii','/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2.nii','/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
# note that ants_trans_T1_to_MNI: t1_brain is already registered to QSM_neutral
# so this is equivlent to qsm_neutral_to_MNI
# therefore as long as other images are registerd to QSM_neutral
# can apply this ants_trans_T1_to_MNI to morpy into MNI space

mni_brain=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
cosmos=/Volumes/LaCie/COSMOS_7T/04JG/cosmos_5_12DOF_cgs_smvrad2_adj.nii
cosmos_to_mni=/Volumes/LaCie/COSMOS_7T/04JG/cosmos_5_12DOF_cgs_smvrad2_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/04JG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $cosmos -r $mni_brain -o $cosmos_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

deepqsm=/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/deeplearning/DeepQSM_Recon_04JG_adj.nii
deepqsm_to_mni=/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/deeplearning/DeepQSM_Recon_04JG_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/04JG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $deepqsm -r $mni_brain -o $deepqsm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

qsmnet=/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/deeplearning/QSMnet+_Recon_04JG_adj.nii
qsmnet_to_mni=/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/deeplearning/QSMnet+_Recon_04JG_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/04JG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $qsmnet -r $mni_brain -o $qsmnet_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo_noisy=/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_NoisyTrain_Recon_04JG_adj.nii
xqsm_invivo_noisy_to_mni=/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_NoisyTrain_Recon_04JG_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/04JG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $xqsm_invivo_noisy -r $mni_brain -o $xqsm_invivo_noisy_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo=/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_Recon_04JG_adj.nii
xqsm_invivo_to_mni=/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_Recon_04JG_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/04JG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $xqsm_invivo -r $mni_brain -o $xqsm_invivo_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_syn=/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/deeplearning/xQSM_syn_Recon_04JG_adj.nii
xqsm_syn_to_mni=/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/deeplearning/xQSM_syn_Recon_04JG_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/04JG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $xqsm_syn -r $mni_brain -o $xqsm_syn_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

iLSQR=/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii
iLSQR_to_mni=/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/04JG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $iLSQR -r $mni_brain -o $iLSQR_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

MEDI=/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_adj.nii
MEDI_to_mni=/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/04JG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $MEDI -r $mni_brain -o $MEDI_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

















nii_coord_adj('/Volumes/LaCie/COSMOS_7T/05SG/cosmos_5_12DOF_cgs_smvrad2.nii','/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/deeplearning/DeepQSM_Recon_05SG.nii','/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/deeplearning/QSMnet+_Recon_05SG.nii','/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_NoisyTrain_Recon_05SG.nii','/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_Recon_05SG.nii','/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/deeplearning/xQSM_syn_Recon_05SG.nii','/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2.nii','/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2.nii','/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
# note that ants_trans_T1_to_MNI: t1_brain is already registered to QSM_neutral
# so this is equivlent to qsm_neutral_to_MNI
# therefore as long as other images are registerd to QSM_neutral
# can apply this ants_trans_T1_to_MNI to morpy into MNI space

mni_brain=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
cosmos=/Volumes/LaCie/COSMOS_7T/05SG/cosmos_5_12DOF_cgs_smvrad2_adj.nii
cosmos_to_mni=/Volumes/LaCie/COSMOS_7T/05SG/cosmos_5_12DOF_cgs_smvrad2_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/05SG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $cosmos -r $mni_brain -o $cosmos_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

deepqsm=/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/deeplearning/DeepQSM_Recon_05SG_adj.nii
deepqsm_to_mni=/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/deeplearning/DeepQSM_Recon_05SG_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/05SG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $deepqsm -r $mni_brain -o $deepqsm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

qsmnet=/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/deeplearning/QSMnet+_Recon_05SG_adj.nii
qsmnet_to_mni=/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/deeplearning/QSMnet+_Recon_05SG_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/05SG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $qsmnet -r $mni_brain -o $qsmnet_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo_noisy=/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_NoisyTrain_Recon_05SG_adj.nii
xqsm_invivo_noisy_to_mni=/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_NoisyTrain_Recon_05SG_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/05SG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $xqsm_invivo_noisy -r $mni_brain -o $xqsm_invivo_noisy_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo=/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_Recon_05SG_adj.nii
xqsm_invivo_to_mni=/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_Recon_05SG_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/05SG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $xqsm_invivo -r $mni_brain -o $xqsm_invivo_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_syn=/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/deeplearning/xQSM_syn_Recon_05SG_adj.nii
xqsm_syn_to_mni=/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/deeplearning/xQSM_syn_Recon_05SG_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/05SG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $xqsm_syn -r $mni_brain -o $xqsm_syn_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

iLSQR=/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii
iLSQR_to_mni=/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/05SG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $iLSQR -r $mni_brain -o $iLSQR_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

MEDI=/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_adj.nii
MEDI_to_mni=/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/05SG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $MEDI -r $mni_brain -o $MEDI_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 















nii_coord_adj('/Volumes/LaCie/COSMOS_7T/06PS/cosmos_5_12DOF_cgs_smvrad2.nii','/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/deeplearning/DeepQSM_Recon_06PS.nii','/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/deeplearning/QSMnet+_Recon_06PS.nii','/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_NoisyTrain_Recon_06PS.nii','/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_Recon_06PS.nii','/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/deeplearning/xQSM_syn_Recon_06PS.nii','/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2.nii','/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2.nii','/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
# note that ants_trans_T1_to_MNI: t1_brain is already registered to QSM_neutral
# so this is equivlent to qsm_neutral_to_MNI
# therefore as long as other images are registerd to QSM_neutral
# can apply this ants_trans_T1_to_MNI to morpy into MNI space

mni_brain=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
cosmos=/Volumes/LaCie/COSMOS_7T/06PS/cosmos_5_12DOF_cgs_smvrad2_adj.nii
cosmos_to_mni=/Volumes/LaCie/COSMOS_7T/06PS/cosmos_5_12DOF_cgs_smvrad2_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/06PS/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $cosmos -r $mni_brain -o $cosmos_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

deepqsm=/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/deeplearning/DeepQSM_Recon_06PS_adj.nii
deepqsm_to_mni=/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/deeplearning/DeepQSM_Recon_06PS_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/06PS/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $deepqsm -r $mni_brain -o $deepqsm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

qsmnet=/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/deeplearning/QSMnet+_Recon_06PS_adj.nii
qsmnet_to_mni=/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/deeplearning/QSMnet+_Recon_06PS_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/06PS/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $qsmnet -r $mni_brain -o $qsmnet_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo_noisy=/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_NoisyTrain_Recon_06PS_adj.nii
xqsm_invivo_noisy_to_mni=/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_NoisyTrain_Recon_06PS_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/06PS/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $xqsm_invivo_noisy -r $mni_brain -o $xqsm_invivo_noisy_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo=/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_Recon_06PS_adj.nii
xqsm_invivo_to_mni=/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_Recon_06PS_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/06PS/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $xqsm_invivo -r $mni_brain -o $xqsm_invivo_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_syn=/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/deeplearning/xQSM_syn_Recon_06PS_adj.nii
xqsm_syn_to_mni=/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/deeplearning/xQSM_syn_Recon_06PS_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/06PS/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $xqsm_syn -r $mni_brain -o $xqsm_syn_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

iLSQR=/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii
iLSQR_to_mni=/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/06PS/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $iLSQR -r $mni_brain -o $iLSQR_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

MEDI=/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_adj.nii
MEDI_to_mni=/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/06PS/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $MEDI -r $mni_brain -o $MEDI_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 














nii_coord_adj('/Volumes/LaCie/COSMOS_7T/07JON/cosmos_5_12DOF_cgs_smvrad2.nii','/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/deeplearning/DeepQSM_Recon_07JON.nii','/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/deeplearning/QSMnet+_Recon_07JON.nii','/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_NoisyTrain_Recon_07JON.nii','/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_Recon_07JON.nii','/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/deeplearning/xQSM_syn_Recon_07JON.nii','/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2.nii','/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
nii_coord_adj('/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2.nii','/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/src/mag_corr1_dicoms.nii');
# note that ants_trans_T1_to_MNI: t1_brain is already registered to QSM_neutral
# so this is equivlent to qsm_neutral_to_MNI
# therefore as long as other images are registerd to QSM_neutral
# can apply this ants_trans_T1_to_MNI to morpy into MNI space

mni_brain=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
cosmos=/Volumes/LaCie/COSMOS_7T/07JON/cosmos_5_12DOF_cgs_smvrad2_adj.nii
cosmos_to_mni=/Volumes/LaCie/COSMOS_7T/07JON/cosmos_5_12DOF_cgs_smvrad2_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/07JON/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $cosmos -r $mni_brain -o $cosmos_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

deepqsm=/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/deeplearning/DeepQSM_Recon_07JON_adj.nii
deepqsm_to_mni=/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/deeplearning/DeepQSM_Recon_07JON_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/07JON/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $deepqsm -r $mni_brain -o $deepqsm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

qsmnet=/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/deeplearning/QSMnet+_Recon_07JON_adj.nii
qsmnet_to_mni=/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/deeplearning/QSMnet+_Recon_07JON_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/07JON/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $qsmnet -r $mni_brain -o $qsmnet_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo_noisy=/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_NoisyTrain_Recon_07JON_adj.nii
xqsm_invivo_noisy_to_mni=/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_NoisyTrain_Recon_07JON_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/07JON/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $xqsm_invivo_noisy -r $mni_brain -o $xqsm_invivo_noisy_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo=/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_Recon_07JON_adj.nii
xqsm_invivo_to_mni=/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/deeplearning/xQSM_invivo_Recon_07JON_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/07JON/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $xqsm_invivo -r $mni_brain -o $xqsm_invivo_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_syn=/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/deeplearning/xQSM_syn_Recon_07JON_adj.nii
xqsm_syn_to_mni=/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/deeplearning/xQSM_syn_Recon_07JON_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/07JON/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $xqsm_syn -r $mni_brain -o $xqsm_syn_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

iLSQR=/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii
iLSQR_to_mni=/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/07JON/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $iLSQR -r $mni_brain -o $iLSQR_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

MEDI=/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_adj.nii
MEDI_to_mni=/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_adj_to_MNI.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/07JON/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $MEDI -r $mni_brain -o $MEDI_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 


