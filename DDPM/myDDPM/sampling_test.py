import torch
from modules import UNet 
from ddpm import Diffusion
import numpy as np
from utils import *
import os
from scipy.io import loadmat, savemat
import numpy as np

# print(torch.cuda.is_available())
# print(torch.cuda.device_count())
# print(torch.cuda.device(0))
# print(torch.cuda.get_device_name(0))


# load in the trained model
# device = "cpu"
device = "cuda"
model = UNet(device=device).to(device)
ckpt = torch.load("/home/Staff/uqhsun8/myDDPM/modules/DDPM_Unconditional/ckpt.pt", map_location=device)
model.load_state_dict(ckpt)
diffusion = Diffusion(img_size=128, device=device)


# # inference on a batch (12) of samples -- unconditionally
# sampled_images = diffusion.sample(model, n=12)
# os.makedirs(os.path.join("sampling_results"), exist_ok=True)
# save_images(sampled_images, os.path.join("sampling_results", f"12samples_epoch105"))


# add kspace guidance for conditional sampling
# load in the undersampled kspace
test_sample = np.load('/home/Staff/uqhsun8/sunlab/Hongfu/complex_2d_images_full_undersampled_testdata/_home_Staff_uqhsun8_sunlab_Share_raw_kspace_128_test_dataset_QSMpatients_151_200_PREVENT_173_study_QSM_SPGR_GE/120.npy')[:,:,3] # load in an undersampled condition for sampling
under_k = test_sample[None, None, :, :] # numpy
under_k = torch.from_numpy(under_k).cfloat()
# under_k will be normalized during DDPM in ddpm.py

# load in the sampling mask
under_mask = loadmat('/home/Staff/uqhsun8/mask_AF8.mat')['mask'] #size: 128*128
under_mask = torch.unsqueeze(torch.unsqueeze(torch.from_numpy(under_mask).float(), 0), 0) # torch tensor

sampled_images = diffusion.sample_guided(model, under_k, under_mask)
os.makedirs(os.path.join("sampling_results"), exist_ok=True)
save_images(sampled_images, os.path.join("sampling_results", f"conditional_result"))