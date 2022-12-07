import numpy as np
from scipy.io import loadmat, savemat
import numpy.fft as FFT
# import mat73
from einops import rearrange
import os
import re

k_raw_list = ['/home/Staff/uqhsun8/sunlab/Share/raw_kspace_128/test_dataset/QSMpatients_151_200/PREVENT_190/study/QSM_SPGR_GE/kspace.mat' ,'/home/Staff/uqhsun8/sunlab/Share/raw_kspace_128/test_dataset/QSMpatients_151_200/PREVENT_197/study/QSM_SPGR_GE/kspace.mat' ,'/home/Staff/uqhsun8/sunlab/Share/raw_kspace_128/test_dataset/QSMpatients_151_200/PREVENT_173/study/QSM_SPGR_GE/kspace.mat' ,'/home/Staff/uqhsun8/sunlab/Share/raw_kspace_128/test_dataset/QSMpatients_151_200/PREVENT_158/study/QSM_SPGR_GE/kspace.mat' ,'/home/Staff/uqhsun8/sunlab/Share/raw_kspace_128/test_dataset/QSMpatients_151_200/PREVENT_156/study/QSM_SPGR_GE/kspace.mat' ,'/home/Staff/uqhsun8/sunlab/Share/raw_kspace_128/test_dataset/QSMpatients_151_200/PREVENT_180/study/QSM_SPGR_GE/kspace.mat' ,'/home/Staff/uqhsun8/sunlab/Share/raw_kspace_128/test_dataset/QSMpatients_151_200/PREVENT_177/study/QSM_SPGR_GE/kspace.mat' ,'/home/Staff/uqhsun8/sunlab/Share/raw_kspace_128/test_dataset/QSMpatients_151_200/PREVENT_193/study/QSM_SPGR_GE/kspace.mat' ,'/home/Staff/uqhsun8/sunlab/Share/raw_kspace_128/test_dataset/QSMpatients_151_200/PREVENT_169/study/QSM_SPGR_GE/kspace.mat' ,'/home/Staff/uqhsun8/sunlab/Share/raw_kspace_128/test_dataset/QSMpatients_151_200/PREVENT_187/study/QSM_SPGR_GE/kspace.mat' ,'/home/Staff/uqhsun8/sunlab/Share/raw_kspace_128/test_dataset/QSMpatients_151_200/PREVENT_151/study/QSM_SPGR_GE/kspace.mat' ,'/home/Staff/uqhsun8/sunlab/Share/raw_kspace_128/test_dataset/QSMpatients_151_200/PREVENT_153/study/QSM_SPGR_GE/kspace.mat' ,'/home/Staff/uqhsun8/sunlab/Share/raw_kspace_128/test_dataset/QSMpatients_151_200/PREVENT_191/study/QSM_SPGR_GE/kspace.mat' ,'/home/Staff/uqhsun8/sunlab/Share/raw_kspace_128/test_dataset/QSMpatients_151_200/PREVENT_182/study/QSM_SPGR_GE/kspace.mat' ,'/home/Staff/uqhsun8/sunlab/Share/raw_kspace_128/test_dataset/QSMpatients_151_200/PREVENT_166/study/QSM_SPGR_GE/kspace.mat' ,'/home/Staff/uqhsun8/sunlab/Share/raw_kspace_128/test_dataset/QSMpatients_151_200/PREVENT_162/study/QSM_SPGR_GE/kspace.mat' ,'/home/Staff/uqhsun8/sunlab/Share/raw_kspace_128/test_dataset/QSMpatients_151_200/PREVENT_195/study/QSM_SPGR_GE/kspace.mat' ,'/home/Staff/uqhsun8/sunlab/Share/raw_kspace_128/test_dataset/QSMpatients_151_200/PREVENT_171/study/QSM_SPGR_GE/kspace.mat' ,'/home/Staff/uqhsun8/sunlab/Share/raw_kspace_128/test_dataset/QSMpatients_151_200/PREVENT_192/study/QSM_SPGR_GE/kspace.mat' ,'/home/Staff/uqhsun8/sunlab/Share/raw_kspace_128/test_dataset/QSMpatients_151_200/PREVENT_198/study/QSM_SPGR_GE/kspace.mat' ,'/home/Staff/uqhsun8/sunlab/Share/raw_kspace_128/test_dataset/QSMpatients_151_200/PREVENT_181/study/QSM_SPGR_GE/kspace.mat'] 


# load in the undersampling mask
under_mask = loadmat('/home/Staff/uqhsun8/mask_AF8.mat')['mask']
# read in k
for k_3d_path in k_raw_list:
    k_3d = loadmat(k_3d_path)['k']
    img_3d = FFT.fftshift(FFT.fftn(FFT.fftshift(k_3d, axes=(0, 1, 2)), axes=(0, 1, 2)), axes=(0, 1, 2))
        
    k_2d = FFT.fftshift(FFT.fft(FFT.fftshift(k_3d, axes=2), axis=2), axes=2)
    k_2d_undersampled = k_2d * np.expand_dims(under_mask, (2,3))

    img_2d_undersampled = FFT.fftshift(FFT.fftn(FFT.fftshift(k_2d_undersampled, axes=(0, 1)), axes=(0, 1)), axes=(0, 1))

    img_cat_channels = np.stack((img_3d, img_2d_undersampled, k_2d, k_2d_undersampled), -1)

    img_cat_channels = rearrange(img_cat_channels, 'x y z echo channel -> x y (z echo) channel')


    pathname = os.path.dirname(str(k_3d_path))
    pathname = re.sub(r"\.", '', re.sub(r"\/", '_', re.sub(r"\s+",'_',pathname)))
    pathname = os.path.join("/home/Staff/uqhsun8/sunlab/Hongfu/complex_2d_images_full_undersampled_testdata", pathname)
    os.makedirs(pathname, exist_ok=True)
    slice_echo_no = 0
    for slice_echo_no in range(img_cat_channels.shape[2]):
        filename = pathname + '/' + str(slice_echo_no) + '.npy'
        np.save(filename, img_cat_channels[:,:,slice_echo_no,:]) # 2D slices: x, y, channels (full_img, under_img, full_k, under_k)
        slice_echo_no += 1

