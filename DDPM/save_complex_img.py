import os
import glob
import nibabel as nib
import numpy as np
from scipy.io import savemat

def read_and_save_complex_img(src_folder):
    mag_data = []
    ph_data = []
    for echonum in range(1,9):
        mag_filename = f'mag{echonum}.nii'
        mag_img = nib.load(os.path.join(src_folder,mag_filename))
        mag_data.append(mag_img.get_fdata())
        ph_filename = f'ph{echonum}.nii'
        ph_img = nib.load(os.path.join(src_folder,ph_filename))
        ph_data.append(ph_img.get_fdata())

    mag_data = np.stack(mag_data, axis=3)
    ph_data = np.stack(ph_data, axis=3)
    cpx_data = mag_data * np.exp(1j * ph_data)
    
    # Save the data as .mat file
    output_filename = "complex_image_256x256x128x8.mat"
    output_path = os.path.join(src_folder, output_filename)

    # Save the complex_data as 'data' variable in the .mat file
    savemat(output_path, {"data": cpx_data})


if __name__ == "__main__":
    os.chdir('/Volumes/LaCie_Bottom/MS/QSM_recon')
    src_folders = glob.glob('*/QSM_SPGR_GE/src', recursive=True)
    src_folders = [os.path.abspath(folder) for folder in src_folders]
    [read_and_save_complex_img(src_folder) for src_folder in src_folders]

