import numpy as np
import torch
import nibabel as nib
from pathlib import Path
import torch.nn as nn
import os



class Dataset_Load(nn.Module):

    def __init__(self, sim_root_path, reference_invivo_path, echo_no):
        #  Dataset_Load(sim_root_path= subject_path_sim ,reference_invivo_path = subject_path1_invivo, echo_no= i)

        super(Dataset_Load, self).__init__()

        r2s = 'R2s_SPGR_GE/R2s.nii'
        m0 = 'R2s_SPGR_GE/amp.nii'
        mask = 'QSM_SPGR_GE/BET_mask.nii'
        mags = 'QSM_SPGR_GE/src'
        mag1 = 'QSM_SPGR_GE/src/mag1.nii'

        self.entries = []
        self.echo_no = echo_no
        self.TEs =  [3.192, 6.544, 9.896, 13.248, 16.6, 19.952, 23.304, 26.656]
        self.max_len = 10
        # os.path.join(subject_path, r2s)
        mag1 = nib.load(str( sim_root_path / str('mag1' + '.nii'))).get_fdata()
        mag2 = nib.load(str( sim_root_path / str('mag2' + '.nii'))).get_fdata()
        mag3 = nib.load(str( sim_root_path / str('mag3' + '.nii'))).get_fdata()
        mag4 = nib.load(str( sim_root_path / str('mag4' + '.nii'))).get_fdata()
        mag5 = nib.load(str( sim_root_path / str('mag5' + '.nii'))).get_fdata()
        mag6 = nib.load(str( sim_root_path / str('mag6' + '.nii'))).get_fdata()
        mag7 = nib.load(str( sim_root_path / str('mag7' + '.nii'))).get_fdata()
        mag8 = nib.load(str( sim_root_path / str('mag8' + '.nii'))).get_fdata()
        
        mask = nib.load(os.path.join(reference_invivo_path, mask)).get_fdata()
        r2s = nib.load(os.path.join(reference_invivo_path, r2s)).get_fdata()
        amp = nib.load(os.path.join(reference_invivo_path, m0)).get_fdata()

        masked_amp = mask * amp
        masked_r2s = mask * r2s
        x, y, z = mag1.shape
        vox = 0
        i, j, k = 0, 0, 0 # 242, 280, 192
        for i in range (256):
            for j in range(256):
                for k in range(128):
                    if( masked_r2s[i, j, k] > 0 and masked_amp[i, j, k] > 0):
                        self.entries.append({
                                    'mag1': mag1[i, j, k]* 100,
                                    'mag2': mag2[i, j, k] * 100,
                                    'mag3': mag3[i, j, k] * 100,
                                    'mag4': mag4[i, j, k] * 100,
                                    'mag5': mag5[i, j, k] * 100,
                                    'mag6': mag6[i, j, k] * 100,
                                    'mag7': mag7[i, j, k] * 100,
                                    'mag8': mag8[i, j, k] * 100,

                                })


    def __getitem__(self, index):
        pair = self.entries[index]  # entries are created before already so here we just iterate through
        mags = torch.tensor([pair[f'mag{i}'] for i in range(1, self.echo_no + 1)])
        return mags, torch.tensor(self.TEs[1:self.echo_no + 1])


    def __len__(self):
        return len(self.entries)