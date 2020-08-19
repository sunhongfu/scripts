import torch
import numpy as np 
import numpy as np
import nibabel as nib
import scipy.io as scio

if __name__ == '__main__':
    ## lfs_k is the field image with the shape of 2 * H * W * D, where the first channel is real components. 
    nib_lfs_k = nib.load('lfs_k.nii')
    lfs_k = nib_lfs_k.get_fdata() 
    lfs_k = np.array(lfs_k)

    ## for now pytroch does not support fftshift fucntion, but we can use np.fftshift for fftshift. 
    lfs_k = np.fft.ifftshift(lfs_k, axes=(1,2,3))   
    lfs_k = torch.from_numpy(lfs_k)

    lfs_k = lfs_k.permute(1, 2, 3, 0)  ## FFT reconstruciton block. 

    lfs_img = torch.ifft(lfs_k, 3)
    lfs_img = lfs_img[:,:,:,0]  ## get the real channel. 0： real channel, 1, imaginary channel.
    lfs_img = lfs_img.numpy()

    path = 'lfs_img.mat'
    scio.savemat(path, {'PRED':lfs_img})
    print('end')
