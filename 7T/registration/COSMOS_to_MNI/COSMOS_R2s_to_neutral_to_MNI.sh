# register all the COSMOS subjects R2s maps (0.6mm) from neutral to MNI space

cd /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/neutral/QSM_MEGE_7T
nii_coord_adj('R2.nii','src/mag_corr1_dicoms.nii');

# note that ants_trans_T1_to_MNI: t1_brain is already registered to QSM_neutral
# so this is equivlent to qsm_neutral_to_MNI
# therefore as long as other images are registerd to QSM_neutral
# can apply this ants_trans_T1_to_MNI to morpy into MNI space

mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
r2s_neutral=/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/neutral/QSM_MEGE_7T/R2_adj.nii
r2s_neutral_to_mni=/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/neutral/QSM_MEGE_7T/R2_adj_to_MNI.nii.gz
transformPrefix=/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $r2s_neutral -r $mni_brain -o $r2s_neutral_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 



cd /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/neutral/QSM_MEGE_7T
nii_coord_adj('R2.nii','src/mag_corr1_dicoms.nii');

mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
r2s_neutral=/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/neutral/QSM_MEGE_7T/R2_adj.nii
r2s_neutral_to_mni=/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/neutral/QSM_MEGE_7T/R2_adj_to_MNI.nii.gz
transformPrefix=/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $r2s_neutral -r $mni_brain -o $r2s_neutral_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 



cd /home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/neutral/QSM_MEGE_7T
nii_coord_adj('R2.nii','src/mag_corr1_dicoms.nii');

mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
r2s_neutral=/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/neutral/QSM_MEGE_7T/R2_adj.nii
r2s_neutral_to_mni=/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/neutral/QSM_MEGE_7T/R2_adj_to_MNI.nii.gz
transformPrefix=/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $r2s_neutral -r $mni_brain -o $r2s_neutral_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 



cd /home/hongfu/cj97_scratch/hongfu/COSMOS/04JG/neutral/QSM_MEGE_7T
nii_coord_adj('R2.nii','src/mag_corr1_dicoms.nii');

mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
r2s_neutral=/home/hongfu/cj97_scratch/hongfu/COSMOS/04JG/neutral/QSM_MEGE_7T/R2_adj.nii
r2s_neutral_to_mni=/home/hongfu/cj97_scratch/hongfu/COSMOS/04JG/neutral/QSM_MEGE_7T/R2_adj_to_MNI.nii.gz
transformPrefix=/home/hongfu/cj97_scratch/hongfu/COSMOS/04JG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $r2s_neutral -r $mni_brain -o $r2s_neutral_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 



cd /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/neutral/QSM_MEGE_7T
nii_coord_adj('R2.nii','src/mag_corr1_dicoms.nii');

mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
r2s_neutral=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/neutral/QSM_MEGE_7T/R2_adj.nii
r2s_neutral_to_mni=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/neutral/QSM_MEGE_7T/R2_adj_to_MNI.nii.gz
transformPrefix=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $r2s_neutral -r $mni_brain -o $r2s_neutral_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 



cd /home/hongfu/cj97_scratch/hongfu/COSMOS/06PS/neutral/QSM_MEGE_7T
nii_coord_adj('R2.nii','src/mag_corr1_dicoms.nii');

mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
r2s_neutral=/home/hongfu/cj97_scratch/hongfu/COSMOS/06PS/neutral/QSM_MEGE_7T/R2_adj.nii
r2s_neutral_to_mni=/home/hongfu/cj97_scratch/hongfu/COSMOS/06PS/neutral/QSM_MEGE_7T/R2_adj_to_MNI.nii.gz
transformPrefix=/home/hongfu/cj97_scratch/hongfu/COSMOS/06PS/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $r2s_neutral -r $mni_brain -o $r2s_neutral_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 



cd /home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/neutral/QSM_MEGE_7T
nii_coord_adj('R2.nii','src/mag_corr1_dicoms.nii');

mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
r2s_neutral=/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/neutral/QSM_MEGE_7T/R2_adj.nii
r2s_neutral_to_mni=/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/neutral/QSM_MEGE_7T/R2_adj_to_MNI.nii.gz
transformPrefix=/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/ants_brain/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $r2s_neutral -r $mni_brain -o $r2s_neutral_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 





