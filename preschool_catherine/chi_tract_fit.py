# fitting the susceptiblity with the angles (sin2_alpha)
import nibabel as nib
import numpy as np
from matplotlib import pyplot as plt
import glob
import os

# read in registered susceptibility map
# chi = nib.load('/home/hongfu/Desktop/CL_DEV_002/chi_iLSQR_peel1_RAS_ants_to_B0.nii')
chi = nib.load(
    '/home/hongfu/Desktop/CL_DEV_002/chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS_ants_to_B0.nii')
chi_img = np.array(chi.get_data())*1000

# read in the FA map
fa = nib.load(
    '/home/hongfu/Desktop/CL_DEV_002/CL_DEV_002_BVR_sdc_sorted_GR_TV_FP_MD_C_native_FA.nii')
fa_img = np.array(fa.get_data())

# read in the sus_sin2_alpha
sin2 = nib.load('/home/hongfu/Desktop/CL_DEV_002/qsm_sin2_alpha.nii')
sin2_img = np.array(sin2.get_data())


# threshold: remove all susceptiblity values above 0
# chi_thr_mask = np.array(chi_img < 0)

# read in a tract as index
for name in glob.glob('/home/hongfu/Desktop/CL_DEV_002/tracts/*.nii'):
    print(os.path.basename(name))
    tract = nib.load(name)
    # tract = nib.load(
    #     '/home/hongfu/Desktop/CL_DEV_002/tracts/CL_DEV_002_Ax4_BVR_sdc_sorted_GR_TV_FP_MD_C_native_CC_Body.nii')
    tract_img = np.array(tract.get_data())
    tract_mask = tract_img > 0
    # tract_mask = np.logical_and(tract_img > 0, tract_img < 3)

    # apply the sus<0 threshold
    # tract_thr_mask = tract_mask*chi_thr_mask
    tract_thr_mask = tract_mask

    #########################################################################################
    #########################################################################################
    #########################################################################################
    #########################################################################################
    #########################################################################################
    #########################################################################################
    #########################################################################################
    #########################################################################################
    #########################################################################################
    #########################################################################################
    # use the FA to bin the measurements
    tract_thr_mask = np.logical_and(
        tract_thr_mask, np.logical_and(fa_img < 1, fa_img < 1))

    # measure the FA
    fa_img_meas = fa_img[tract_thr_mask]
    # measure the susceptibility
    chi_img_meas = chi_img[tract_thr_mask]
    # measure the sin2
    sin2_img_meas = sin2_img[tract_thr_mask]

    # fit chi = a* sin2 + b
    A = np.concatenate(
        ([sin2_img_meas, ], [np.ones(sin2_img_meas.shape), ]), axis=0)
    x = np.linalg.inv(A@A.T) @ (A@chi_img_meas.T)
    # fig, ax = plt.subplots()
    fig, axs = plt.subplots(2, 2, sharex=False, sharey=True)
    fig.suptitle(os.path.basename(name))
    axs[0, 0].scatter(sin2_img_meas, chi_img_meas)
    axs[0, 0].set_title('withoutFA')
    print(x)

    # new A include FA
    #########################################################################################
    # try to include the FA in the model: chi = a * FA * sin2 + b
    fa_sin2_img_meas = sin2_img_meas * fa_img_meas
    #########################################################################################
    A_new = np.concatenate(
        ([fa_sin2_img_meas, ], [np.ones(fa_sin2_img_meas.shape), ]), axis=0)
    x_new = np.linalg.inv(A_new@A_new.T) @ (A_new@chi_img_meas.T)
    axs[0, 1].scatter(fa_sin2_img_meas, chi_img_meas)
    axs[0, 1].set_title('withFA')
    print(x_new)

    #########################################################################################
    #########################################################################################
    #########################################################################################
    #########################################################################################
    #########################################################################################
    #########################################################################################
    #########################################################################################
    #########################################################################################
    #########################################################################################
    #########################################################################################
    tract_mask = tract_img > 0
    tract_thr_mask = tract_mask
    # use the FA to bin the measurements
    tract_thr_mask = np.logical_and(
        tract_thr_mask, np.logical_and(fa_img > 0.5, fa_img < 1))

    # measure the FA
    fa_img_meas = fa_img[tract_thr_mask]
    # measure the susceptibility
    chi_img_meas = chi_img[tract_thr_mask]
    # measure the sus_sin2_alpha
    sin2_img_meas = sin2_img[tract_thr_mask]

    # fit chi = a* sin2 + b
    A = np.concatenate(
        ([sin2_img_meas, ], [np.ones(sin2_img_meas.shape), ]), axis=0)
    x = np.linalg.inv(A@A.T) @ (A@chi_img_meas.T)
    # fig, ax = plt.subplots()
    axs[1, 0].scatter(sin2_img_meas, chi_img_meas)
    axs[1, 0].set_title('highFA_withoutFA')
    print(x)

    # new A include FA
    #########################################################################################
    # try to include the FA in the model: chi = a * FA * sin2 + b
    fa_sin2_img_meas = sin2_img_meas * fa_img_meas
    #########################################################################################
    A_new = np.concatenate(
        ([fa_sin2_img_meas, ], [np.ones(fa_sin2_img_meas.shape), ]), axis=0)
    x_new = np.linalg.inv(A_new@A_new.T) @ (A_new@chi_img_meas.T)
    # fig, ax = plt.subplots()
    axs[1, 1].scatter(fa_sin2_img_meas, chi_img_meas)
    axs[1, 1].set_title('highFA_withFA')
    print(x_new)
