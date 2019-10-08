#!/usr/bin/env python3
import nibabel as nib
import sys
import math
import numpy as np
import os

# Use: ./run_fixGEphaseFFTshift.py filesTofix.nii.gz

print("Number of files: ", len(sys.argv)-1)

for fileIdx in range(1,len(sys.argv)):
        filename = sys.argv[fileIdx]
        print(filename)
        img = nib.load(filename)
        data = img.get_data()
        print(data.shape)

        if data.shape[3]==3:
                complex_data_image = data[:,:,:,1] + 1j * data[:,:,:,2]
                scaling = np.sqrt(complex_data_image.size)

                complex_data_kspace = np.fft.fftshift (np.fft.fftshift (np.fft.fftn(  np.fft.fftshift(complex_data_image))), axes=2) / scaling
        
                # real_data_kspace = np.real(complex_data_kspace)
                # imag_data_kspace = np.imag(complex_data_kspace)
                
                # real_data_kspace_img = nib.Nifti1Image(real_data_kspace, img.affine, img.header)
                # imag_data_kspace = nib.Nifti1Image(imag_data_kspace, img.affine, img.header)

                # org_filename = os.path.splitext(filename)[0]

                # nib.save(real_data_kspace_img, org_filename+'_real_kspace.nii.gz')
                # nib.save(imag_data_kspace, org_filename+'_imag_kspace.nii.gz')

                complex_data_correct_image = np.fft.fftshift(np.fft.ifftn(np.fft.fftshift(complex_data_kspace))) * scaling        

                phase_data = np.angle(complex_data_correct_image)
                mag_data = np.abs(complex_data_correct_image)

                phase_img = nib.Nifti1Image(phase_data, img.affine, img.header)
                mag_img = nib.Nifti1Image(mag_data, img.affine, img.header)

                org_filename = os.path.splitext(filename)[0]

                nib.save(phase_img, org_filename+'_gre_P.nii.gz')
                nib.save(mag_img, org_filename+'_gre_M.nii.gz')
        else:
                print("File does not have enough dimensions to contain Imag/Real")

