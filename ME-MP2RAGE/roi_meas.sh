rois_prob_50=/usr/local/fsl/data/atlases/HarvardOxford/HarvardOxford-sub-maxprob-thr50-1mm.nii

# generate the ROIs
# (1) resample the SN_standard and RN_standard to 'resampled' using FSLEYES, match 1mm iso resolution
# (2) reorient to MNI space
fslreorient2std /Users/hongfusun/DATA/ME-MP2RAGE/rois/SN_standard_resampled.nii.gz /Users/hongfusun/DATA/ME-MP2RAGE/rois/SN_standard_resampled_reoriented.nii.gz
fslreorient2std /Users/hongfusun/DATA/ME-MP2RAGE/rois/RN_standard_resampled.nii.gz /Users/hongfusun/DATA/ME-MP2RAGE/rois/RN_standard_resampled_reoriented.nii.gz


roi_sn=/Users/hongfusun/DATA/ME-MP2RAGE/rois/SN_standard_resampled_reoriented.nii.gz
roi_rn=/Users/hongfusun/DATA/ME-MP2RAGE/rois/RN_standard_resampled_reoriented.nii.gz
roi_dwm=/Users/hongfusun/DATA/ME-MP2RAGE/rois/DWM_standard.nii



qsm_1=/Users/hongfusun/DATA/ME-MP2RAGE/01_VM_H257/chi_iLSQR_smvrad2_adj_to_MNI.nii
r2sm_1=/Users/hongfusun/DATA/ME-MP2RAGE/01_VM_H257/R2_I2_adj_to_MNI.nii
t1m_1=/Users/hongfusun/DATA/ME-MP2RAGE/01_VM_H257/T1m_to_MNI.nii

qsm_2=/Users/hongfusun/DATA/ME-MP2RAGE/02_JF_H446/chi_iLSQR_smvrad2_adj_to_MNI.nii
r2sm_2=/Users/hongfusun/DATA/ME-MP2RAGE/02_JF_H446/R2_I2_adj_to_MNI.nii
t1m_2=/Users/hongfusun/DATA/ME-MP2RAGE/02_JF_H446/T1m_to_MNI.nii

qsm_3=/Users/hongfusun/DATA/ME-MP2RAGE/03_MP_H447/chi_iLSQR_smvrad2_adj_to_MNI.nii
r2sm_3=/Users/hongfusun/DATA/ME-MP2RAGE/03_MP_H447/R2_I2_adj_to_MNI.nii
t1m_3=/Users/hongfusun/DATA/ME-MP2RAGE/03_MP_H447/T1m_to_MNI.nii

qsm_4=/Users/hongfusun/DATA/ME-MP2RAGE/04_BH_451/chi_iLSQR_smvrad2_adj_to_MNI.nii
r2sm_4=/Users/hongfusun/DATA/ME-MP2RAGE/04_BH_451/R2_I2_adj_to_MNI.nii
t1m_4=/Users/hongfusun/DATA/ME-MP2RAGE/04_BH_451/T1m_to_MNI.nii

qsm_5=/Users/hongfusun/DATA/ME-MP2RAGE/05_JON_H476/chi_iLSQR_smvrad2_adj_to_MNI.nii
r2sm_5=/Users/hongfusun/DATA/ME-MP2RAGE/05_JON_H476/R2_I2_adj_to_MNI.nii
t1m_5=/Users/hongfusun/DATA/ME-MP2RAGE/05_JON_H476/T1m_to_MNI.nii


# measure QSM
fslstats -K $rois_prob_50 $qsm_1 -M
fslstats -K $roi_sn $qsm_1 -M
fslstats -K $roi_rn $qsm_1 -M
fslstats -K $roi_dwm $qsm_1 -M

fslstats -K $rois_prob_50 $qsm_2 -M
fslstats -K $roi_sn $qsm_2 -M
fslstats -K $roi_rn $qsm_2 -M
fslstats -K $roi_dwm $qsm_2 -M

fslstats -K $rois_prob_50 $qsm_3 -M
fslstats -K $roi_sn $qsm_3 -M
fslstats -K $roi_rn $qsm_3 -M
fslstats -K $roi_dwm $qsm_3 -M

fslstats -K $rois_prob_50 $qsm_4 -M
fslstats -K $roi_sn $qsm_4 -M
fslstats -K $roi_rn $qsm_4 -M
fslstats -K $roi_dwm $qsm_4 -M

fslstats -K $rois_prob_50 $qsm_5 -M
fslstats -K $roi_sn $qsm_5 -M
fslstats -K $roi_rn $qsm_5 -M
fslstats -K $roi_dwm $qsm_5 -M




# measure R2*
fslstats -K $rois_prob_50 $r2sm_1 -M
fslstats -K $roi_sn $r2sm_1 -M
fslstats -K $roi_rn $r2sm_1 -M
fslstats -K $roi_dwm $r2sm_1 -M

fslstats -K $rois_prob_50 $r2sm_2 -M
fslstats -K $roi_sn $r2sm_2 -M
fslstats -K $roi_rn $r2sm_2 -M
fslstats -K $roi_dwm $r2sm_2 -M

fslstats -K $rois_prob_50 $r2sm_3 -M
fslstats -K $roi_sn $r2sm_3 -M
fslstats -K $roi_rn $r2sm_3 -M
fslstats -K $roi_dwm $r2sm_3 -M

fslstats -K $rois_prob_50 $r2sm_4 -M
fslstats -K $roi_sn $r2sm_4 -M
fslstats -K $roi_rn $r2sm_4 -M
fslstats -K $roi_dwm $r2sm_4 -M

fslstats -K $rois_prob_50 $r2sm_5 -M
fslstats -K $roi_sn $r2sm_5 -M
fslstats -K $roi_rn $r2sm_5 -M
fslstats -K $roi_dwm $r2sm_5 -M




# measure T1 map
fslstats -K $rois_prob_50 $t1m_1 -M
fslstats -K $roi_sn $t1m_1 -M
fslstats -K $roi_rn $t1m_1 -M
fslstats -K $roi_dwm $t1m_1 -M

fslstats -K $rois_prob_50 $t1m_2 -M
fslstats -K $roi_sn $t1m_2 -M
fslstats -K $roi_rn $t1m_2 -M
fslstats -K $roi_dwm $t1m_2 -M

fslstats -K $rois_prob_50 $t1m_3 -M
fslstats -K $roi_sn $t1m_3 -M
fslstats -K $roi_rn $t1m_3 -M
fslstats -K $roi_dwm $t1m_3 -M

fslstats -K $rois_prob_50 $t1m_4 -M
fslstats -K $roi_sn $t1m_4 -M
fslstats -K $roi_rn $t1m_4 -M
fslstats -K $roi_dwm $t1m_4 -M

fslstats -K $rois_prob_50 $t1m_5 -M
fslstats -K $roi_sn $t1m_5 -M
fslstats -K $roi_rn $t1m_5 -M
fslstats -K $roi_dwm $t1m_5 -M

