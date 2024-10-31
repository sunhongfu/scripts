import h5py
import torch
from torch.utils.data import Dataset, DataLoader
import numpy as np
import random

max_len = 10

class DataSet1(Dataset):
    def __init__(self, h5_file_path):
        self.h5_file = h5_file_path
        self.data = []
        with h5py.File(self.h5_file, 'r') as f:
            self.num_voxels = len(f.keys())
            for i in range(self.num_voxels):
                group = f[f'voxel_{i}']
                padded_TEs = group.attrs['Padded_TEs']
                padded_mags = group.attrs['Padded_Norm_noisy_mags']
                R2s = np.array(group.attrs['R2s']).astype(np.float32)
                self.data.append((padded_mags, padded_TEs, R2s))

    def __len__(self):
        return self.num_voxels

    def __getitem__(self, idx):
        return self.data[idx]