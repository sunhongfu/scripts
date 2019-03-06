# measure deep grey matter from HarvardOxford-sub
# measure cerebral white matter ALSO from HarvardOxford-sub
# measure cerebral cortex ALSO from HarvardOxford-sub
rois_prob_50=/usr/local/fsl/data/atlases/HarvardOxford/HarvardOxford-sub-maxprob-thr50-1mm.nii


# # generate the ROIs
# # (1) resample the SN_standard and RN_standard to 'resampled' using FSLEYES, match 1mm iso resolution
# # (2) reorient to MNI space
# fslreorient2std /Users/hongfusun/DATA/ME-MP2RAGE/rois/SN_standard_resampled.nii.gz /Users/hongfusun/DATA/ME-MP2RAGE/rois/SN_standard_resampled_reoriented.nii.gz
# fslreorient2std /Users/hongfusun/DATA/ME-MP2RAGE/rois/RN_standard_resampled.nii.gz /Users/hongfusun/DATA/ME-MP2RAGE/rois/RN_standard_resampled_reoriented.nii.gz


roi_sn=/Users/hongfusun/DATA/ME-MP2RAGE/rois/SN_standard_resampled_reoriented.nii.gz
roi_rn=/Users/hongfusun/DATA/ME-MP2RAGE/rois/RN_standard_resampled_reoriented.nii.gz
roi_dwm=/Users/hongfusun/DATA/ME-MP2RAGE/rois/DWM_standard.nii



############################################
# measure QSM and R2* on ME-MP2RAGE
############################################
qsm_1=/Users/hongfusun/DATA/paper_revision/registration/01EG/ME-MP2RAGE_0p75/chi_iLSQR_smvrad2_adj_to_MNI.nii
r2sm_1=/Users/hongfusun/DATA/paper_revision/registration/01EG/ME-MP2RAGE_0p75/R2_adj_to_MNI.nii

qsm_2=/Users/hongfusun/DATA/paper_revision/registration/02SCOTT/ME-MP2RAGE_0p75/chi_iLSQR_smvrad2_adj_to_MNI.nii
r2sm_2=/Users/hongfusun/DATA/paper_revision/registration/02SCOTT/ME-MP2RAGE_0p75/R2_adj_to_MNI.nii

qsm_3=/Users/hongfusun/DATA/paper_revision/registration/03JK/ME-MP2RAGE_0p75/chi_iLSQR_smvrad2_adj_to_MNI.nii
r2sm_3=/Users/hongfusun/DATA/paper_revision/registration/03JK/ME-MP2RAGE_0p75/R2_adj_to_MNI.nii

qsm_4=/Users/hongfusun/DATA/paper_revision/registration/05SG/ME-MP2RAGE_0p75/chi_iLSQR_smvrad2_adj_to_MNI.nii
r2sm_4=/Users/hongfusun/DATA/paper_revision/registration/05SG/ME-MP2RAGE_0p75/R2_adj_to_MNI.nii

qsm_5=/Users/hongfusun/DATA/paper_revision/registration/07JON/ME-MP2RAGE_0p75/chi_iLSQR_smvrad2_adj_to_MNI.nii
r2sm_5=/Users/hongfusun/DATA/paper_revision/registration/07JON/ME-MP2RAGE_0p75/R2_adj_to_MNI.nii

############################################
qsm_6=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/chi_iLSQR_smvrad2_adj_to_MNI.nii
r2sm_6=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/R2_adj_to_MNI.nii

qsm_7=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/chi_iLSQR_smvrad2_adj_to_MNI.nii
r2sm_7=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/R2_adj_to_MNI.nii

qsm_8=/Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75/chi_iLSQR_smvrad2_adj_to_MNI.nii
r2sm_8=/Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75/R2_adj_to_MNI.nii
############################################


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

fslstats -K $rois_prob_50 $qsm_6 -M
fslstats -K $roi_sn $qsm_6 -M
fslstats -K $roi_rn $qsm_6 -M
fslstats -K $roi_dwm $qsm_6 -M

fslstats -K $rois_prob_50 $qsm_7 -M
fslstats -K $roi_sn $qsm_7 -M
fslstats -K $roi_rn $qsm_7 -M
fslstats -K $roi_dwm $qsm_7 -M

fslstats -K $rois_prob_50 $qsm_8 -M
fslstats -K $roi_sn $qsm_8 -M
fslstats -K $roi_rn $qsm_8 -M
fslstats -K $roi_dwm $qsm_8 -M

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

fslstats -K $rois_prob_50 $r2sm_6 -M
fslstats -K $roi_sn $r2sm_6 -M
fslstats -K $roi_rn $r2sm_6 -M
fslstats -K $roi_dwm $r2sm_6 -M

fslstats -K $rois_prob_50 $r2sm_7 -M
fslstats -K $roi_sn $r2sm_7 -M
fslstats -K $roi_rn $r2sm_7 -M
fslstats -K $roi_dwm $r2sm_7 -M

fslstats -K $rois_prob_50 $r2sm_8 -M
fslstats -K $roi_sn $r2sm_8 -M
fslstats -K $roi_rn $r2sm_8 -M
fslstats -K $roi_dwm $r2sm_8 -M







# ############################################
# # measure QSM and R2* on BI-QSM (direct to MNI)
# ############################################
# qsm_1=/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii
# r2sm_1=/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_to_MNI.nii

# qsm_2=/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii
# r2sm_2=/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_to_MNI.nii

# qsm_3=/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii
# r2sm_3=/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_to_MNI.nii

# qsm_4=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii
# r2sm_4=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_to_MNI.nii

# qsm_5=/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii
# r2sm_5=/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_to_MNI.nii



# # measure QSM
# fslstats -K $rois_prob_50 $qsm_1 -M
# fslstats -K $roi_sn $qsm_1 -M
# fslstats -K $roi_rn $qsm_1 -M
# fslstats -K $roi_dwm $qsm_1 -M

# fslstats -K $rois_prob_50 $qsm_2 -M
# fslstats -K $roi_sn $qsm_2 -M
# fslstats -K $roi_rn $qsm_2 -M
# fslstats -K $roi_dwm $qsm_2 -M

# fslstats -K $rois_prob_50 $qsm_3 -M
# fslstats -K $roi_sn $qsm_3 -M
# fslstats -K $roi_rn $qsm_3 -M
# fslstats -K $roi_dwm $qsm_3 -M

# fslstats -K $rois_prob_50 $qsm_4 -M
# fslstats -K $roi_sn $qsm_4 -M
# fslstats -K $roi_rn $qsm_4 -M
# fslstats -K $roi_dwm $qsm_4 -M

# fslstats -K $rois_prob_50 $qsm_5 -M
# fslstats -K $roi_sn $qsm_5 -M
# fslstats -K $roi_rn $qsm_5 -M
# fslstats -K $roi_dwm $qsm_5 -M

# # measure R2*
# fslstats -K $rois_prob_50 $r2sm_1 -M
# fslstats -K $roi_sn $r2sm_1 -M
# fslstats -K $roi_rn $r2sm_1 -M
# fslstats -K $roi_dwm $r2sm_1 -M

# fslstats -K $rois_prob_50 $r2sm_2 -M
# fslstats -K $roi_sn $r2sm_2 -M
# fslstats -K $roi_rn $r2sm_2 -M
# fslstats -K $roi_dwm $r2sm_2 -M

# fslstats -K $rois_prob_50 $r2sm_3 -M
# fslstats -K $roi_sn $r2sm_3 -M
# fslstats -K $roi_rn $r2sm_3 -M
# fslstats -K $roi_dwm $r2sm_3 -M

# fslstats -K $rois_prob_50 $r2sm_4 -M
# fslstats -K $roi_sn $r2sm_4 -M
# fslstats -K $roi_rn $r2sm_4 -M
# fslstats -K $roi_dwm $r2sm_4 -M

# fslstats -K $rois_prob_50 $r2sm_5 -M
# fslstats -K $roi_sn $r2sm_5 -M
# fslstats -K $roi_rn $r2sm_5 -M
# fslstats -K $roi_dwm $r2sm_5 -M








############################################
# measure QSM and R2* on BI-QSM (to MEMP2RAGE then to MNI)
############################################

qsm_1=/Users/hongfusun/DATA/paper_revision/registration/01EG/BI-QSM_0p75/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii
r2sm_1=/Users/hongfusun/DATA/paper_revision/registration/01EG/BI-QSM_0p75/R2_adj_bi2memp2rage_to_MNI.nii

qsm_2=/Users/hongfusun/DATA/paper_revision/registration/02SCOTT/BI-QSM_0p75/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii
r2sm_2=/Users/hongfusun/DATA/paper_revision/registration/02SCOTT/BI-QSM_0p75/R2_adj_bi2memp2rage_to_MNI.nii

qsm_3=/Users/hongfusun/DATA/paper_revision/registration/03JK/BI-QSM_0p75/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii
r2sm_3=/Users/hongfusun/DATA/paper_revision/registration/03JK/BI-QSM_0p75/R2_adj_bi2memp2rage_to_MNI.nii

qsm_4=/Users/hongfusun/DATA/paper_revision/registration/05SG/BI-QSM_0p75/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii
r2sm_4=/Users/hongfusun/DATA/paper_revision/registration/05SG/BI-QSM_0p75/R2_adj_bi2memp2rage_to_MNI.nii

qsm_5=/Users/hongfusun/DATA/paper_revision/registration/07JON/BI-QSM_0p75/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii
r2sm_5=/Users/hongfusun/DATA/paper_revision/registration/07JON/BI-QSM_0p75/R2_adj_bi2memp2rage_to_MNI.nii

############################################
qsm_6=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/BI-QSM_0p75/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii
r2sm_6=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/BI-QSM_0p75/R2_adj_bi2memp2rage_to_MNI.nii

qsm_7=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/BI-QSM_0p75/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii
r2sm_7=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/BI-QSM_0p75/R2_adj_bi2memp2rage_to_MNI.nii
############################################


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
############################################
fslstats -K $rois_prob_50 $qsm_6 -M
fslstats -K $roi_sn $qsm_6 -M
fslstats -K $roi_rn $qsm_6 -M
fslstats -K $roi_dwm $qsm_6 -M

fslstats -K $rois_prob_50 $qsm_7 -M
fslstats -K $roi_sn $qsm_7 -M
fslstats -K $roi_rn $qsm_7 -M
fslstats -K $roi_dwm $qsm_7 -M
############################################

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
############################################
fslstats -K $rois_prob_50 $r2sm_6 -M
fslstats -K $roi_sn $r2sm_6 -M
fslstats -K $roi_rn $r2sm_6 -M
fslstats -K $roi_dwm $r2sm_6 -M

fslstats -K $rois_prob_50 $r2sm_7 -M
fslstats -K $roi_sn $r2sm_7 -M
fslstats -K $roi_rn $r2sm_7 -M
fslstats -K $roi_dwm $r2sm_7 -M
############################################










############################################
# measure T1map on ME-MP2RAGE
############################################
T1m_1=/Users/hongfusun/DATA/paper_revision/registration/01EG/ME-MP2RAGE_0p75/T1m_to_MNI.nii
T1m_2=/Users/hongfusun/DATA/paper_revision/registration/02SCOTT/ME-MP2RAGE_0p75/T1m_to_MNI.nii
T1m_3=/Users/hongfusun/DATA/paper_revision/registration/03JK/ME-MP2RAGE_0p75/T1m_to_MNI.nii
T1m_4=/Users/hongfusun/DATA/paper_revision/registration/05SG/ME-MP2RAGE_0p75/T1m_to_MNI.nii
T1m_5=/Users/hongfusun/DATA/paper_revision/registration/07JON/ME-MP2RAGE_0p75/T1m_to_MNI.nii
############################################
T1m_6=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/T1m_to_MNI.nii
T1m_7=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/T1m_to_MNI.nii
T1m_8=/Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75/T1m_to_MNI.nii
############################################



# measure T1
fslstats -K $rois_prob_50 $T1m_1 -M
fslstats -K $roi_sn $T1m_1 -M
fslstats -K $roi_rn $T1m_1 -M
fslstats -K $roi_dwm $T1m_1 -M

fslstats -K $rois_prob_50 $T1m_2 -M
fslstats -K $roi_sn $T1m_2 -M
fslstats -K $roi_rn $T1m_2 -M
fslstats -K $roi_dwm $T1m_2 -M

fslstats -K $rois_prob_50 $T1m_3 -M
fslstats -K $roi_sn $T1m_3 -M
fslstats -K $roi_rn $T1m_3 -M
fslstats -K $roi_dwm $T1m_3 -M

fslstats -K $rois_prob_50 $T1m_4 -M
fslstats -K $roi_sn $T1m_4 -M
fslstats -K $roi_rn $T1m_4 -M
fslstats -K $roi_dwm $T1m_4 -M

fslstats -K $rois_prob_50 $T1m_5 -M
fslstats -K $roi_sn $T1m_5 -M
fslstats -K $roi_rn $T1m_5 -M
fslstats -K $roi_dwm $T1m_5 -M
############################################
fslstats -K $rois_prob_50 $T1m_6 -M
fslstats -K $roi_sn $T1m_6 -M
fslstats -K $roi_rn $T1m_6 -M
fslstats -K $roi_dwm $T1m_6 -M

fslstats -K $rois_prob_50 $T1m_7 -M
fslstats -K $roi_sn $T1m_7 -M
fslstats -K $roi_rn $T1m_7 -M
fslstats -K $roi_dwm $T1m_7 -M

fslstats -K $rois_prob_50 $T1m_8 -M
fslstats -K $roi_sn $T1m_8 -M
fslstats -K $roi_rn $T1m_8 -M
fslstats -K $roi_dwm $T1m_8 -M
############################################







############################################
# measure T1map on ME-MP2RAGE
############################################
T1m_e1_1=/Users/hongfusun/DATA/paper_revision/registration/01EG/ME-MP2RAGE_0p75/T1m_e1_to_MNI.nii
T1m_e1_2=/Users/hongfusun/DATA/paper_revision/registration/02SCOTT/ME-MP2RAGE_0p75/T1m_e1_to_MNI.nii
T1m_e1_3=/Users/hongfusun/DATA/paper_revision/registration/03JK/ME-MP2RAGE_0p75/T1m_e1_to_MNI.nii
T1m_e1_4=/Users/hongfusun/DATA/paper_revision/registration/05SG/ME-MP2RAGE_0p75/T1m_e1_to_MNI.nii
T1m_e1_5=/Users/hongfusun/DATA/paper_revision/registration/07JON/ME-MP2RAGE_0p75/T1m_e1_to_MNI.nii
############################################
T1m_e1_6=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/T1m_e1_to_MNI.nii
T1m_e1_7=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/T1m_e1_to_MNI.nii
T1m_e1_8=/Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75/T1m_e1_to_MNI.nii
############################################



# measure T1
fslstats -K $rois_prob_50 $T1m_e1_1 -M
fslstats -K $roi_sn $T1m_e1_1 -M
fslstats -K $roi_rn $T1m_e1_1 -M
fslstats -K $roi_dwm $T1m_e1_1 -M

fslstats -K $rois_prob_50 $T1m_e1_2 -M
fslstats -K $roi_sn $T1m_e1_2 -M
fslstats -K $roi_rn $T1m_e1_2 -M
fslstats -K $roi_dwm $T1m_e1_2 -M

fslstats -K $rois_prob_50 $T1m_e1_3 -M
fslstats -K $roi_sn $T1m_e1_3 -M
fslstats -K $roi_rn $T1m_e1_3 -M
fslstats -K $roi_dwm $T1m_e1_3 -M

fslstats -K $rois_prob_50 $T1m_e1_4 -M
fslstats -K $roi_sn $T1m_e1_4 -M
fslstats -K $roi_rn $T1m_e1_4 -M
fslstats -K $roi_dwm $T1m_e1_4 -M

fslstats -K $rois_prob_50 $T1m_e1_5 -M
fslstats -K $roi_sn $T1m_e1_5 -M
fslstats -K $roi_rn $T1m_e1_5 -M
fslstats -K $roi_dwm $T1m_e1_5 -M
############################################
fslstats -K $rois_prob_50 $T1m_e1_6 -M
fslstats -K $roi_sn $T1m_e1_6 -M
fslstats -K $roi_rn $T1m_e1_6 -M
fslstats -K $roi_dwm $T1m_e1_6 -M

fslstats -K $rois_prob_50 $T1m_e1_7 -M
fslstats -K $roi_sn $T1m_e1_7 -M
fslstats -K $roi_rn $T1m_e1_7 -M
fslstats -K $roi_dwm $T1m_e1_7 -M

fslstats -K $rois_prob_50 $T1m_e1_8 -M
fslstats -K $roi_sn $T1m_e1_8 -M
fslstats -K $roi_rn $T1m_e1_8 -M
fslstats -K $roi_dwm $T1m_e1_8 -M
############################################





############################################
# measure T1map on SE-MP2RAGE (to ME-MP2RAGE first, then to MNI)
############################################
T1m_1=/Users/hongfusun/DATA/paper_revision/registration/01EG/SE-MP2RAGE_0p75/T1map_c32_SE_to_ME_to_MNI.nii
T1m_2=/Users/hongfusun/DATA/paper_revision/registration/02SCOTT/SE-MP2RAGE_0p75/T1map_c32_SE_to_ME_to_MNI.nii
T1m_3=/Users/hongfusun/DATA/paper_revision/registration/03JK/SE-MP2RAGE_0p75/T1map_c32_SE_to_ME_to_MNI.nii
T1m_4=/Users/hongfusun/DATA/paper_revision/registration/05SG/SE-MP2RAGE_0p75/T1map_c32_SE_to_ME_to_MNI.nii
T1m_5=/Users/hongfusun/DATA/paper_revision/registration/07JON/SE-MP2RAGE_0p9/T1map_c32_SE_to_ME_to_MNI.nii
############################################
T1m_6=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/SE-MP2RAGE_0p75/T1map_c32_SE_to_ME_to_MNI.nii
T1m_7=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/SE-MP2RAGE_0p75/T1map_c32_SE_to_ME_to_MNI.nii
T1m_8=/Users/hongfusun/DATA/paper_revision/registration/Wu_524/SE-MP2RAGE_0p75/T1map_c32_SE_to_ME_to_MNI.nii
############################################

# measure T1
fslstats -K $rois_prob_50 $T1m_1 -M
fslstats -K $roi_sn $T1m_1 -M
fslstats -K $roi_rn $T1m_1 -M
fslstats -K $roi_dwm $T1m_1 -M

fslstats -K $rois_prob_50 $T1m_2 -M
fslstats -K $roi_sn $T1m_2 -M
fslstats -K $roi_rn $T1m_2 -M
fslstats -K $roi_dwm $T1m_2 -M

fslstats -K $rois_prob_50 $T1m_3 -M
fslstats -K $roi_sn $T1m_3 -M
fslstats -K $roi_rn $T1m_3 -M
fslstats -K $roi_dwm $T1m_3 -M

fslstats -K $rois_prob_50 $T1m_4 -M
fslstats -K $roi_sn $T1m_4 -M
fslstats -K $roi_rn $T1m_4 -M
fslstats -K $roi_dwm $T1m_4 -M

fslstats -K $rois_prob_50 $T1m_5 -M
fslstats -K $roi_sn $T1m_5 -M
fslstats -K $roi_rn $T1m_5 -M
fslstats -K $roi_dwm $T1m_5 -M
############################################
fslstats -K $rois_prob_50 $T1m_6 -M
fslstats -K $roi_sn $T1m_6 -M
fslstats -K $roi_rn $T1m_6 -M
fslstats -K $roi_dwm $T1m_6 -M

fslstats -K $rois_prob_50 $T1m_7 -M
fslstats -K $roi_sn $T1m_7 -M
fslstats -K $roi_rn $T1m_7 -M
fslstats -K $roi_dwm $T1m_7 -M

fslstats -K $rois_prob_50 $T1m_8 -M
fslstats -K $roi_sn $T1m_8 -M
fslstats -K $roi_rn $T1m_8 -M
fslstats -K $roi_dwm $T1m_8 -M
############################################


# # measure T1map on SE-MP2RAGE (directly to MNI)

# T1m_1=/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/T1/T1map_c32_to_MNI.nii
# T1m_2=/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/T1/T1map_c32_to_MNI.nii
# T1m_3=/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/T1/T1map_c32_to_MNI.nii
# T1m_4=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/T1/T1map_c32_to_MNI.nii
# T1m_5=/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/T1/T1map_c32_to_MNI.nii


# # measure T1
# fslstats -K $rois_prob_50 $T1m_1 -M
# fslstats -K $roi_sn $T1m_1 -M
# fslstats -K $roi_rn $T1m_1 -M
# fslstats -K $roi_dwm $T1m_1 -M

# fslstats -K $rois_prob_50 $T1m_2 -M
# fslstats -K $roi_sn $T1m_2 -M
# fslstats -K $roi_rn $T1m_2 -M
# fslstats -K $roi_dwm $T1m_2 -M

# fslstats -K $rois_prob_50 $T1m_3 -M
# fslstats -K $roi_sn $T1m_3 -M
# fslstats -K $roi_rn $T1m_3 -M
# fslstats -K $roi_dwm $T1m_3 -M

# fslstats -K $rois_prob_50 $T1m_4 -M
# fslstats -K $roi_sn $T1m_4 -M
# fslstats -K $roi_rn $T1m_4 -M
# fslstats -K $roi_dwm $T1m_4 -M

# fslstats -K $rois_prob_50 $T1m_5 -M
# fslstats -K $roi_sn $T1m_5 -M
# fslstats -K $roi_rn $T1m_5 -M
# fslstats -K $roi_dwm $T1m_5 -M
