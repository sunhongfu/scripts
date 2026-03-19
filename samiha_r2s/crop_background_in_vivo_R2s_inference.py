import nibabel as nib
import numpy as np
import os


def crop_nifti(input_path, output_path, padding=5, threshold=1e-6):
    """
    Crop a NIfTI image by removing background zeros, with adjustable padding.

    Parameters:
        input_path (str): Path to input NIfTI file.
        output_path (str): Path to save cropped NIfTI file.
        padding (int): Number of voxels to add around the cropped region.
        threshold (float): Minimum intensity to consider as non-background.
    """

    # Load the NIfTI file
    nii_img = nib.load(input_path)
    nii_data = nii_img.get_fdata()

    # Find non-zero voxels with a threshold (avoid noise issues)
    nonzero_coords = np.argwhere(nii_data > threshold)

    if nonzero_coords.size == 0:
        print(" No nonzero voxels found. Skipping cropping.")
        return

    # Get the bounding box of the non-zero region
    min_coords = nonzero_coords.min(axis=0)
    max_coords = nonzero_coords.max(axis=0) + 1  # +1 to include the last index

    # Add padding and ensure bounds are within image size
    min_coords = np.maximum(min_coords - padding, 0)
    max_coords = np.minimum(max_coords + padding, nii_data.shape)

    # Crop the image
    cropped_data = nii_data[min_coords[0]:max_coords[0],
                   min_coords[1]:max_coords[1],
                   min_coords[2]:max_coords[2]]

    # Adjust the affine matrix to maintain spatial alignment
    new_affine = nii_img.affine.copy()
    new_affine[:3, 3] += min_coords * nii_img.header.get_zooms()

    # Save the new cropped NIfTI image
    cropped_nii = nib.Nifti1Image(cropped_data.astype(np.float32), new_affine, nii_img.header)
    nib.save(cropped_nii, output_path)

    print(f"✅ Cropped NIfTI saved to: {output_path}")
    print(f"Original shape: {nii_data.shape} → Cropped shape: {cropped_data.shape}")


# Example usage
input_nifti = "//home/samiha/PycharmProjects/ROI_graphs/isotropic_experiemnts/iso_0.5_0.5_0.5/resized/R2s_NLLS/R2_8echo_2_2_2_nlls.nii"
output_nifti = "/home/samiha/PycharmProjects/ROI_graphs/isotropic_experiemnts/iso_0.5_0.5_0.5/resized/R2s_NLLS/R2_8echo_2_2_2_nlls_cropped.nii"
crop_nifti(input_nifti, output_nifti)
