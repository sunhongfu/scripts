# fitting the susceptiblity with the angles (sin2_alpha)
import nibabel as nib
import numpy as np
from matplotlib import pyplot as plt

# read in a tract as index
tract_img = nib.load('/home/hongfu/Desktop/CL_DEV_001/tracts/CL_DEV_001_Ax4_BVR_sdc_sorted_GR_TV_FP_MD_C_native_CC_Body.nii')
tract_img_data = tract_img.get_data()
tract_img_data = np.array(tract_img_data,dtype=bool)

# read in registered susceptibility map
chi_img = nib.load('/home/hongfu/Desktop/CL_DEV_001/chi_iLSQR_peel1_RAS_flirt_to_B0.nii.nii.gz')
chi_img_data = chi_img.get_data()
chi_img_data = np.array(chi_img_data)

# read in the sus_sin2_alpha
sin2_alpha_img = nib.load('/home/hongfu/Desktop/CL_DEV_001/qsm_sin2_alpha.nii')
sin2_alpha_img_data = sin2_alpha_img.get_data()
sin2_alpha_img_data = np.array(sin2_alpha_img_data)

# read in the FA map
fa_img = nib.load('/home/hongfu/Desktop/CL_DEV_001/CL_DEV_001_Ax4_BVR_sdc_sorted_GR_TV_FP_MD_C_native_FA.nii')
fa_img_data = fa_img.get_data()
fa_img_data = np.array(fa_img_data)

# extract the chi and sin2 of the tract
chi_tract = chi_img_data[tract_img_data]
sin2_alpha_tract = sin2_alpha_img_data[tract_img_data]

# try to include the FA in the model: chi = a * FA * sin2 + b
fa_sin2_alpha_tract = sin2_alpha_img_data[tract_img_data]*fa_img_data[tract_img_data]

# fit chi = a* sin2 + b
# A = np.concatenate(([sin2_alpha_tract,],[np.ones(sin2_alpha_tract.shape),]),axis = 0)
# new A include FA
A = np.concatenate(([fa_sin2_alpha_tract,],[np.ones(fa_sin2_alpha_tract.shape),]),axis = 0)

x = np.linalg.inv(A@A.T) @ (A@chi_tract.T)

plt.scatter(fa_sin2_alpha_tract,chi_tract)