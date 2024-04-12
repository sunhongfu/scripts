import numpy as np
import nibabel as nib

test_sample = np.load('/home/Staff/uqhsun8/sunlab/Hongfu/complex_2d_images_full_undersampled_testdata/_home_Staff_uqhsun8_sunlab_Share_raw_kspace_128_test_dataset_QSMpatients_151_200_PREVENT_173_study_QSM_SPGR_GE/120.npy')[:,:,0] # load in an undersampled condition for sampling
zero_filled_condition = np.stack((np.real(test_sample), np.imag(test_sample), np.abs(test_sample), np.angle(test_sample)), axis=0)
nib.save(nib.Nifti1Image(np.transpose(zero_filled_condition,(1,2,0)), np.eye(4)), '120_gt.nii')

test_sample = np.load('/home/Staff/uqhsun8/sunlab/Hongfu/complex_2d_images_full_undersampled_testdata/_home_Staff_uqhsun8_sunlab_Share_raw_kspace_128_test_dataset_QSMpatients_151_200_PREVENT_173_study_QSM_SPGR_GE/120.npy')[:,:,1] # load in an undersampled condition for sampling
zero_filled_condition = np.stack((np.real(test_sample), np.imag(test_sample), np.abs(test_sample), np.angle(test_sample)), axis=0)
nib.save(nib.Nifti1Image(np.transpose(zero_filled_condition,(1,2,0)), np.eye(4)), '120_us.nii')
