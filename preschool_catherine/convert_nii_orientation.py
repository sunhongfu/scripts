import nibabel as nib
import numpy as np
import os
import pandas as pd
import fnmatch

# qsm directories
halfPi_list = os.listdir('/media/data/project_preschool/recon/halfPi')
halfPi_qsm_dir = '/media/data/project_preschool/recon/halfPi/'
halfPi_qsm_dir_list = [halfPi_qsm_dir + s + '/QSM_SPGR_GE_halfpi' for s in halfPi_list]
halfPi_nii_output_dir_list = [halfPi_qsm_dir + s for s in halfPi_list]

pi_list = os.listdir('/media/data/project_preschool/recon/pi')
pi_qsm_dir = '/media/data/project_preschool/recon/pi/'
pi_qsm_dir_list = [pi_qsm_dir + s + '/QSM_SPGR_GE_pi' for s in pi_list]
pi_nii_output_dir_list = [pi_qsm_dir + s for s in pi_list]


no_echo1_list = os.listdir('/media/data/project_preschool/recon/no_echo1')
no_echo1_qsm_dir = '/media/data/project_preschool/recon/no_echo1/'
no_echo1_qsm_dir_list = [no_echo1_qsm_dir + s + '/QSM_SPGR_GE_no_echo1' for s in no_echo1_list]
no_echo1_nii_output_dir_list = [no_echo1_qsm_dir + s for s in no_echo1_list]


qsm_list = halfPi_list + pi_list + no_echo1_list
qsm_dir_list = halfPi_qsm_dir_list + pi_qsm_dir_list + no_echo1_qsm_dir_list
nii_output_dir_list = halfPi_nii_output_dir_list + pi_nii_output_dir_list + no_echo1_nii_output_dir_list
                                
dcm_list = []
# dicom directories
for subject in qsm_list:
    dcm_dir = '/media/data/project_preschool/PreschoolData_clean/' + subject
    dcm_dir = os.path.join(dcm_dir, os.listdir(dcm_dir)[0])
    dcm_list.append(dcm_dir)


# create a pandas dataframe
df = pd.DataFrame({'qsm_list':qsm_list, 'qsm_dir_list':qsm_dir_list, 'dcm_list':dcm_list, 'nii_output_dir':nii_output_dir_list})
# df.set_index('qsm_list', inplace=True)


print(df.iloc[0]['qsm_list'])
print(df.iloc[0]['qsm_dir_list'])
print(df.iloc[0]['dcm_list'])
print(df.iloc[0]['nii_output_dir'])



for index, row in df.iterrows():
    # run dcm2niix 
    # input dir: df['dcm_list']
    # output dir: 
    bash_command = '/home/hongfu/apps/mricrogl_lx/dcm2niix -o ' + "'" + row['nii_output_dir'] + "'" + ' -f megre_dcm ' + "'" + row['dcm_list'] + "'"
    os.system(bash_command)



# find original .nii files under QSM recon
for index, row in df.iterrows():
	# list the megre_dcm*.nii and pick the first one
	megre = fnmatch.filter(os.listdir(row['nii_output_dir']), 'megre_dcm*.nii')[0]
	dcm2nii_img = nib.load(os.path.join(row['nii_output_dir'], megre))
	# print(os.path.join(row['nii_output_dir'], 'megre_dcm.nii'))
	matches = []
	for root, dirnames, filenames in os.walk(row['qsm_dir_list']):
	    for filename in fnmatch.filter(filenames, '*.nii'):
	        matches.append(os.path.join(root, filename))
	# print(matches)
	for nii_orig in matches:
		nii_orig_img = nib.load(nii_orig)
		nii_orig_img_data = nii_orig_img.get_data()
		# currently data arranged in DICOM LPS orientation
		# flip to ANALYZE LAS orientation (this is how dcm2niix stores/arranges the data structure)
		# anat_img_data = np.flip(anat_img_data,0)
		nii_orig_img_data = np.flip(nii_orig_img_data,1)
		nii_new = nib.Nifti1Image(nii_orig_img_data, dcm2nii_img.affine, dcm2nii_img.header)
		nii_new.to_filename(os.path.splitext(nii_orig)[0] + '_RAS' + os.path.splitext(nii_orig)[1])










