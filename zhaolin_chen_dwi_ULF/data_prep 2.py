import os
import nibabel as nib
import numpy as np

def save_nifti_slices_as_npy(nifti_dir, save_dir):
   """
   Reads NIFTI files in a directory, extracts 2D slices, and saves them as .npy files,
   """

   filenames = [f for f in os.listdir(nifti_dir) if f.endswith(".nii.gz")]

   for filename in filenames:
       nifti_file_path = os.path.join(nifti_dir, filename)
       basename = os.path.splitext(os.path.splitext(filename)[0])[0]
       img = nib.load(nifti_file_path)
       data = img.get_fdata()

       for i in range(data.shape[2]):
           slice_data = data[:, :, i]
           slice_filename = f"{basename}_slice{i+1:03d}.npy"
           np.save(os.path.join(save_dir,slice_filename), slice_data)


def convert_npy_to_nii(npy_file):
    # Load the data from the npy file
    data = np.load(npy_file)
    data = np.squeeze(data)
    # Create a NIFTI image from the numpy array
    nifti_image = nib.Nifti1Image(data, affine=np.eye(4))

    # Derive the nii file name from the npy file name
    nii_file = os.path.splitext(npy_file)[0] + '.nii'

    # Save the NIFTI image to a file
    nib.save(nifti_image, nii_file)
    return nii_file


   
