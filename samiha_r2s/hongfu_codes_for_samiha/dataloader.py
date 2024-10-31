import h5py
import torch
from torch.utils.data import Dataset, DataLoader
import numpy as np
import random

max_len = 10

# DataSet1 is the fastest way so far
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



# this is very slow!
class DataSet2(Dataset):
    def __init__(self, h5_file_path):
        self.h5_file_path = h5_file_path
        with h5py.File(self.h5_file_path, 'r') as file:
            self.num_voxels = len(file.keys())
            self.keys = [f'voxel_{i}' for i in range(self.num_voxels)]

    def __len__(self):
        return self.num_voxels

    def __getitem__(self, idx):
        with h5py.File(self.h5_file_path, 'r') as file:
            group = file[self.keys[idx]]
            padded_TEs = group.attrs['Padded_TEs']
            padded_mags = group.attrs['Padded_Norm_noisy_mags']
            R2s = np.array(group.attrs['R2s']).astype(np.float32)
        return (padded_mags, padded_TEs, R2s)
    


class DataSet3(Dataset):
    def __init__(self, h5_file_path):
        self.h5_file_path = h5_file_path
        self.file = h5py.File(self.h5_file_path, 'r')  # Open the file once
        self.num_voxels = len(self.file.keys())
        self.keys = [f'voxel_{i}' for i in range(self.num_voxels)]

    def __len__(self):
        return self.num_voxels

    def __getitem__(self, idx):
        group = self.file[self.keys[idx]]
        padded_TEs = group.attrs['Padded_TEs']
        padded_mags = group.attrs['Padded_Norm_noisy_mags']
        R2s = np.array(group.attrs['R2s']).astype(np.float32)
        return (padded_mags, padded_TEs, R2s)

    def __del__(self):
        self.file.close()  # Close the file when the object is deleted


# multiple H5 files dataset
class DataSet4(Dataset):
    def __init__(self, h5_file_paths):
        self.h5_file_paths = h5_file_paths
        self.data = []
        self.num_voxels = 0
        # Load data from each file
        for h5_file in self.h5_file_paths:
            with h5py.File(h5_file, 'r') as f:
                keys = list(f.keys())
                for key in keys:
                    group = f[key]
                    padded_TEs = group.attrs['Padded_TEs']
                    padded_mags = group.attrs['Padded_Norm_noisy_mags']
                    R2s = np.array(group.attrs['R2s']).astype(np.float32)
                    self.data.append((padded_mags, padded_TEs, R2s))
        self.num_voxels = len(self.data)  # Update total number of voxels

    def __len__(self):
        return self.num_voxels

    def __getitem__(self, idx):
        return self.data[idx]