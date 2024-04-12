import torch
from modules import UNet 
from ddpm_conditional import Diffusion
import numpy as np
from utils import *
import os

# load in the trained model
device = "cuda"
model = UNet().to(device)
epoch = 153
ckpt = torch.load("/home/Staff/uqhsun8/myDDPM_conditional/modules/DDPM_Unconditional/ckpt_epoch" + str(epoch) + ".pt", map_location='cuda:0')
model.load_state_dict(ckpt)
diffusion = Diffusion(img_size=128, device=device)

# inference on a sample
test_sample = np.load('/home/Staff/uqhsun8/sunlab/Hongfu/complex_2d_images_full_undersampled_testdata/_home_Staff_uqhsun8_sunlab_Share_raw_kspace_128_test_dataset_QSMpatients_151_200_PREVENT_173_study_QSM_SPGR_GE/120.npy')[:,:,1] # load in an undersampled condition for sampling
zero_filled_condition = test_sample/np.max(np.abs(test_sample))
zero_filled_condition = np.stack((np.real(zero_filled_condition), np.imag(zero_filled_condition)), axis=0)
condition = torch.unsqueeze(torch.from_numpy(zero_filled_condition).float(), 0)

sampled_images = diffusion.sample(model, condition)
os.makedirs(os.path.join("sampling_results"), exist_ok=True)
save_images(sampled_images, os.path.join("sampling_results", f"sample_epoch{epoch}"))