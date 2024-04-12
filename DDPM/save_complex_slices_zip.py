import os
import glob
import nibabel as nib
import numpy as np
from scipy.io import savemat
import zipfile
import os
import numpy as np
import zipfile
import nibabel as nib
import shutil

def read_and_save_complex_img(src_folder):
    complex_data = []
    os.makedirs(os.path.join(src_folder, 'complex_slices'), exist_ok=True)
    
    for echonum in range(1, 9):
        mag_filename = f'mag{echonum}.nii'
        mag_data = nib.load(os.path.join(src_folder, mag_filename)).get_fdata()
        ph_filename = f'ph{echonum}.nii'
        ph_data = nib.load(os.path.join(src_folder, ph_filename)).get_fdata()
        cpx_data = mag_data * np.exp(1j * ph_data)

        for slicenum in range(1, cpx_data.shape[2] + 1):
            slice_data = cpx_data[:, :, slicenum - 1]
            filename = f"echo_{echonum:02}_slice_{slicenum:03}.npy"
            output_path = os.path.join(src_folder, 'complex_slices', filename)
            np.save(output_path, slice_data)
            complex_data.append((output_path, filename))  # Store the original filename
    
    # Create a zip file and add the saved individual npy files
    zip_path = os.path.join(src_folder, 'complex_slices.zip')
    with zipfile.ZipFile(zip_path, 'w') as zip_file:
        for data_path, data_filename in complex_data:
            zip_file.write(data_path, arcname=data_filename)
    
    # Delete the individual npy files
    shutil.rmtree(os.path.join(src_folder, 'complex_slices'))


if __name__ == "__main__":
    os.chdir('/Volumes/LaCie_Bottom/TIA')
    src_folders = glob.glob('**/QSM_SPGR_GE/src', recursive=True)
    src_folders = [os.path.abspath(folder) for folder in src_folders]
    [read_and_save_complex_img(src_folder) for src_folder in src_folders]

