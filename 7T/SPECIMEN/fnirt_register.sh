#!/bin/bash

# # try FNIRT on QSM instead of magnitude
# cd /home/hongfu/NCIgb5_scratch/hongfu/SPECIMAN/recon

# flirt -ref 6/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii -in 1/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii -omat aff_mag1_to_mag6_qsm.mat

# fnirt --ref=6/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii --in=1/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii --aff=aff_mag1_to_mag6_qsm.mat --cout=warp_mag1_to_mag6_qsm.nii
   
# applywarp --ref=6/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii --in=1/QSM_MEGE_7T/src/mag_corr1_n4.nii --warp=warp_mag1_to_mag6_qsm.nii  --out=1/QSM_MEGE_7T/src/mag_corr1_n4_reg_qsm.nii 

# applywarp --ref=6/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii --in=1/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm.nii --warp=warp_mag1_to_mag6_qsm.nii --out=1/lfs_reshrp_0_smvrad3_reg_qsm.nii 



# flirt -ref 6/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii -in 2/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii -omat aff_mag2_to_mag6_qsm.mat

# fnirt --ref=6/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii --in=2/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii --aff=aff_mag2_to_mag6_qsm.mat --cout=warp_mag2_to_mag6_qsm.nii
   
# applywarp --ref=6/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii --in=2/QSM_MEGE_7T/src/mag_corr1_n4.nii --warp=warp_mag2_to_mag6_qsm.nii  --out=2/QSM_MEGE_7T/src/mag_corr1_n4_reg_qsm.nii 

# applywarp --ref=6/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii --in=2/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm.nii --warp=warp_mag2_to_mag6_qsm.nii --out=2/lfs_reshrp_0_smvrad3_reg_qsm.nii 



# flirt -ref 6/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii -in 3/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii -omat aff_mag3_to_mag6_qsm.mat

# fnirt --ref=6/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii --in=3/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii --aff=aff_mag3_to_mag6_qsm.mat --cout=warp_mag3_to_mag6_qsm.nii
   
# applywarp --ref=6/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii --in=3/QSM_MEGE_7T/src/mag_corr1_n4.nii --warp=warp_mag3_to_mag6_qsm.nii  --out=3/QSM_MEGE_7T/src/mag_corr1_n4_reg_qsm.nii 

# applywarp --ref=6/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii --in=3/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm.nii --warp=warp_mag3_to_mag6_qsm.nii --out=3/lfs_reshrp_0_smvrad3_reg_qsm.nii 



# flirt -ref 6/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii -in 4/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii -omat aff_mag4_to_mag6_qsm.mat

# fnirt --ref=6/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii --in=4/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii --aff=aff_mag4_to_mag6_qsm.mat --cout=warp_mag4_to_mag6_qsm.nii
   
# applywarp --ref=6/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii --in=4/QSM_MEGE_7T/src/mag_corr1_n4.nii --warp=warp_mag4_to_mag6_qsm.nii  --out=4/QSM_MEGE_7T/src/mag_corr1_n4_reg_qsm.nii 

# applywarp --ref=6/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii --in=4/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm.nii --warp=warp_mag4_to_mag6_qsm.nii --out=4/lfs_reshrp_0_smvrad3_reg_qsm.nii 



# flirt -ref 6/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii -in 5/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii -omat aff_mag5_to_mag6_qsm.mat

# fnirt --ref=6/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii --in=5/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii --aff=aff_mag5_to_mag6_qsm.mat --cout=warp_mag5_to_mag6_qsm.nii
   
# applywarp --ref=6/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii --in=5/QSM_MEGE_7T/src/mag_corr1_n4.nii --warp=warp_mag5_to_mag6_qsm.nii  --out=5/QSM_MEGE_7T/src/mag_corr1_n4_reg_qsm.nii 

# applywarp --ref=6/QSM_MEGE_7T/fudge/RESHARP/chi_iLSQR_0_niter50_smvrad3_lsqr_nm.nii --in=5/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm.nii --warp=warp_mag5_to_mag6_qsm.nii --out=5/lfs_reshrp_0_smvrad3_reg_qsm.nii 






cd /home/hongfu/NCIgb5_scratch/hongfu/SPECIMAN/recon

# 1
flirt -ref 6/QSM_MEGE_7T/BET.nii -in 1/QSM_MEGE_7T/BET.nii -omat aff_mag1_to_mag6.mat

fnirt --ref=6/QSM_MEGE_7T/src/mag_corr1_n4.nii --in=1/QSM_MEGE_7T/src/mag_corr1_n4.nii --aff=aff_mag1_to_mag6.mat --cout=warp_mag1_to_mag6.nii
      
applywarp --ref=6/QSM_MEGE_7T/src/mag_corr1_n4.nii --in=1/QSM_MEGE_7T/src/mag_corr1_n4.nii --warp=warp_mag1_to_mag6.nii  --out=1/QSM_MEGE_7T/src/mag_corr1_n4_reg.nii 

applywarp --ref=6/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm.nii --in=1/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm.nii --warp=warp_mag1_to_mag6.nii --out=1/lfs_reshrp_0_smvrad3_reg.nii 


# 2
flirt -ref 6/QSM_MEGE_7T/BET.nii -in 2/QSM_MEGE_7T/BET.nii -omat aff_mag2_to_mag6.mat

fnirt --ref=6/QSM_MEGE_7T/src/mag_corr1_n4.nii --in=2/QSM_MEGE_7T/src/mag_corr1_n4.nii --aff=aff_mag2_to_mag6.mat --cout=warp_mag2_to_mag6.nii
    
applywarp --ref=6/QSM_MEGE_7T/src/mag_corr1_n4.nii --in=2/QSM_MEGE_7T/src/mag_corr1_n4.nii --warp=warp_mag2_to_mag6.nii  --out=2/QSM_MEGE_7T/src/mag_corr1_n4_reg.nii 


applywarp --ref=6/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm.nii --in=2/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm.nii --warp=warp_mag2_to_mag6.nii --out=2/lfs_reshrp_0_smvrad3_reg.nii 


# 3
flirt -ref 6/QSM_MEGE_7T/BET.nii -in 3/QSM_MEGE_7T/BET.nii -omat aff_mag3_to_mag6.mat

fnirt --ref=6/QSM_MEGE_7T/src/mag_corr1_n4.nii --in=3/QSM_MEGE_7T/src/mag_corr1_n4.nii --aff=aff_mag3_to_mag6.mat --cout=warp_mag3_to_mag6.nii
    
applywarp --ref=6/QSM_MEGE_7T/src/mag_corr1_n4.nii --in=3/QSM_MEGE_7T/src/mag_corr1_n4.nii --warp=warp_mag3_to_mag6.nii  --out=3/QSM_MEGE_7T/src/mag_corr1_n4_reg.nii 


applywarp --ref=6/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm.nii --in=3/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm.nii --warp=warp_mag3_to_mag6.nii --out=3/lfs_reshrp_0_smvrad3_reg.nii 


# 4
flirt -ref 6/QSM_MEGE_7T/BET.nii -in 4/QSM_MEGE_7T/BET.nii -omat aff_mag4_to_mag6.mat

fnirt --ref=6/QSM_MEGE_7T/src/mag_corr1_n4.nii --in=4/QSM_MEGE_7T/src/mag_corr1_n4.nii --aff=aff_mag4_to_mag6.mat --cout=warp_mag4_to_mag6.nii
    
applywarp --ref=6/QSM_MEGE_7T/src/mag_corr1_n4.nii --in=4/QSM_MEGE_7T/src/mag_corr1_n4.nii --warp=warp_mag4_to_mag6.nii  --out=4/QSM_MEGE_7T/src/mag_corr1_n4_reg.nii 


applywarp --ref=6/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm.nii --in=4/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm.nii --warp=warp_mag4_to_mag6.nii --out=4/lfs_reshrp_0_smvrad3_reg.nii 


# 5
flirt -ref 6/QSM_MEGE_7T/BET.nii -in 5/QSM_MEGE_7T/BET.nii -omat aff_mag5_to_mag6.mat

fnirt --ref=6/QSM_MEGE_7T/src/mag_corr1_n4.nii --in=5/QSM_MEGE_7T/src/mag_corr1_n4.nii --aff=aff_mag5_to_mag6.mat --cout=warp_mag5_to_mag6.nii
    
applywarp --ref=6/QSM_MEGE_7T/src/mag_corr1_n4.nii --in=5/QSM_MEGE_7T/src/mag_corr1_n4.nii --warp=warp_mag5_to_mag6.nii  --out=5/QSM_MEGE_7T/src/mag_corr1_n4_reg.nii 


applywarp --ref=6/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm.nii --in=5/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm.nii --warp=warp_mag5_to_mag6.nii --out=5/lfs_reshrp_0_smvrad3_reg.nii 

