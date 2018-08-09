# create average map and std map
# python code
import nibabel as nib
import numpy as np

qsm_neutral_to_mni = nib.load('/media/data/7T_reg/07JON/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1_to_MNI.nii.gz')
qsm_neutral_to_mni_data = qsm_neutral_to_mni.get_data()

qsm_left_to_mni = nib.load('/media/data/7T_reg/07JON/left/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1_flirt_to_MNI.nii.gz')
qsm_left_to_mni_data = qsm_left_to_mni.get_data()

qsm_right_to_mni = nib.load('/media/data/7T_reg/07JON/right/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1_flirt_to_MNI.nii.gz')
qsm_right_to_mni_data = qsm_right_to_mni.get_data()

qsm_extension_to_mni = nib.load('/media/data/7T_reg/07JON/extension/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1_flirt_to_MNI.nii.gz')
qsm_extension_to_mni_data = qsm_extension_to_mni.get_data()

qsm_flexion_to_mni = nib.load('/media/data/7T_reg/07JON/flexion/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1_flirt_to_MNI.nii.gz')
qsm_flexion_to_mni_data = qsm_flexion_to_mni.get_data()

# stack all into 4D
qsm_all_to_mni_data = np.stack((qsm_neutral_to_mni_data, qsm_left_to_mni_data, qsm_right_to_mni_data, qsm_extension_to_mni_data, qsm_flexion_to_mni_data), axis = 3)

# generate mean and std
qsm_all_to_mni_mean_data = np.mean(qsm_all_to_mni_data, axis =3)
qsm_all_to_mni_std_data = np.std(qsm_all_to_mni_data, axis =3)

# save the mean and std into nii
qsm_all_to_mni_mean = nib.Nifti1Image(qsm_all_to_mni_mean_data, qsm_neutral_to_mni.affine, qsm_neutral_to_mni.header)
qsm_all_to_mni_mean.to_filename('/media/data/7T_reg/07JON/qsm_mean.nii')

qsm_all_to_mni_std = nib.Nifti1Image(qsm_all_to_mni_std_data, qsm_neutral_to_mni.affine, qsm_neutral_to_mni.header)
qsm_all_to_mni_std.to_filename('/media/data/7T_reg/07JON/qsm_std.nii')

