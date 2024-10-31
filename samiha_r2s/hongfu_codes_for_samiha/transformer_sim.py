


from echo_wise_dataloader import *
from transformer import Transformer
import torch
import torch.nn as nn
import os
import nibabel as nib
import numpy as np
from pathlib import Path


hdr = nib.Nifti1Header()
hdr.set_data_dtype(np.float32)
resolution = (1, 1, 1)

device =  torch.device("cuda:0" if torch.cuda.is_available() else "cpu")

checkpoint = torch.load("checkpoints/checkpoint_epoch_20.pth", map_location=torch.device("cuda:0" if torch.cuda.is_available() else "cpu"))
# checkpoint = torch.load("checkpoints/checkpoint_epoch_45.pth", map_location=torch.device("cuda:0" if torch.cuda.is_available() else "cpu"))

model = nn.DataParallel(Transformer(d_model= 256, num_heads= 4, dropout=0.1, bias=True, batch_first=True, num_layers=2))
# model = Transformer(d_model= 256, num_heads= 4, dropout=0.1, bias=True, batch_first=True, num_layers=2)

# If the model was saved without DataParallel but is being loaded with DataParallel
new_state_dict = {'module.' + k: v for k, v in checkpoint['model_state_dict'].items()}
model.load_state_dict(new_state_dict)

# model.load_state_dict(checkpoint['model_state_dict'], strict=True)  # False check?


BATCH_SIZE = 2000




def estimate_r2s(subject_path1_invivo, subject_path_sim): #(subject_path):


    gt = nib.load(str(subject_path1_invivo / str('R2s_SPGR_GE') / str('R2s.nii'))).get_fdata()
    mask = nib.load(str(subject_path1_invivo / str('QSM_SPGR_GE') / str('BET_mask.nii'))).get_fdata()
    amp = nib.load(str(subject_path1_invivo / str('R2s_SPGR_GE') / str('amp.nii'))).get_fdata()

    amp_masked = mask * amp
    r2s_masked = mask * gt


    echoNos = [ 2, 3, 4, 5, 6, 7,  8]
    # echoNos = [4]
    values = {}

    ##################
    for i in echoNos:
        results_r2s = []
        dataset = Dataset_Load(sim_root_path= subject_path_sim ,reference_invivo_path = subject_path1_invivo, echo_no= i)  #  def __init__(self, sim_root_path, reference_invivo_path, echo_no):
       # import pdb; pdb.set_trace()
        from torch.utils import data
        dataloader = data.DataLoader(dataset, shuffle=False, batch_size=BATCH_SIZE)
        with torch.no_grad():
            model.to(device)
            model.eval()
            for batch_no, data in enumerate(dataloader):
                zero_padded_mags, zero_padded_tes = data
                zero_padded_mags = torch.unsqueeze(zero_padded_mags, -1).to(device)

                # normalize the magnitude inputs
                max_values, _ = torch.max(zero_padded_mags, dim=1, keepdim=True)
                normalized_mags = zero_padded_mags / max_values

                zero_padded_tes = torch.unsqueeze(zero_padded_tes, -1).to(device)
                # value_r2s = (model(zero_padded_tes, zero_padded_mags))
                value_r2s = (model(zero_padded_tes, normalized_mags))
                [results_r2s.append([values]) for values in value_r2s]

        id = 0
        values_r2s = torch.zeros(256, 256, 128)
        results_r2s = torch.tensor(results_r2s).squeeze(-1)
        results_r2s_ = torch.tensor(results_r2s)
        # import pdb; pdb.set_trace()
        mask = np.logical_and(amp_masked > 0, r2s_masked > 0)
        values_r2s[mask] = results_r2s_
        values[i] = values_r2s
    #import pdb; pdb.set_trace()
    return values

def save_r2s(r2s_echos2to10_8, path, st_dev):
    file_type = '.nii'
   # import pdb; pdb.set_trace()
    echos = sorted(list(r2s_echos2to10_8.keys()))
    for i in echos:
     #   import pdb; pdb.set_trace()
        filename = f"transformer_{st_dev}{'_'}{i}{file_type}"
        echo_path = path / filename
        nib.save(nib.Nifti1Image(r2s_echos2to10_8[i], np.diag((*resolution, 1)), hdr), echo_path)







if __name__ == '__main__':

    hdr = nib.Nifti1Header()
    hdr.set_data_dtype(np.float32)
    resolution = (1, 1, 1)

    r2s = 'R2s_SPGR_GE/R2s.nii'
    m0 = 'R2s_SPGR_GE/amp.nii'
    mask = 'QSM_SPGR_GE/BET_mask.nii'
    mags = 'QSM_SPGR_GE/src'
    mag1 = 'QSM_SPGR_GE/src/mag1.nii'



    ################################################# CHANGE HERE ################################################################
    # in_vivo_subject_directory = Path('/home/samiha/PycharmProjects/results/dl_test_subjects/')
    # noisy_sim_data_directory = Path('/home/samiha/PycharmProjects/sendHongfu/simulated_noisy')

    # trans_sim_directory = Path('/home/samiha/PycharmProjects/results/transformer/simulation_trans/092_normalization_100/2017-06-06 RR-092/')

    # trans_sim_directory  = Path('/home/samiha/PycharmProjects/results/transformer/simulation_trans/092_normalization_100/')
    # list_in_vivo_subs = ['2017-06-06 RR-092']
    
    # saved_path = trans_sim_directory
    # st_dev_list = [ '0.01', '0.02', '0.03', '0.04', '0.05']

    # for i in list_in_vivo_subs:
    #     noisy_sub_path = noisy_sim_data_directory / i
    #     trans_save_path = trans_sim_directory / i
    #     in_vivo_path = in_vivo_subject_directory / i
    #     #os.chdir(noisy_sim_data_directory / i) # directory / subject
    #     for j in st_dev_list:
    #         st_dev_sub_path = noisy_sub_path / j # subject / st_dev
    #         r2s_echos2to10_8 = estimate_r2s(in_vivo_path, st_dev_sub_path)

    #         st_dev_path_save= os.path.join(trans_save_path , j)
    #         os.makedirs(st_dev_path_save, exist_ok=True)
    #         save_r2s(r2s_echos2to10_8, Path( st_dev_path_save), st_dev = j)

    subject_path1_invivo = Path('2017-06-06 RR-092')
    subject_path_sim = Path('/home/uqhsun8/Samiha/New_data_revised_model/simulated_noisy/2017-06-06 RR-092/0.02')
    r2s_echo8_8 = estimate_r2s(subject_path1_invivo, subject_path_sim)
    save_r2s(r2s_echo8_8, subject_path_sim, st_dev = 0.02)

    # invivo_mags = Path('/home/uqhsun8/Samiha/New_data_revised_model/2017-06-06 RR-092/QSM_SPGR_GE/src')
    # r2s_echo8_invivo = estimate_r2s(subject_path1_invivo, invivo_mags)
    # save_r2s(r2s_echo8_invivo, subject_path1_invivo, st_dev = 0)