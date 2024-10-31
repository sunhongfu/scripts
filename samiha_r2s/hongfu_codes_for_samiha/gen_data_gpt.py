import h5py
import numpy as np

# Example data setup
num_voxels = 8000000
num_files = 8
voxels_per_file = num_voxels // num_files

mean_start = 5
std_dev_start = 2

mean_space = 5
std_dev_space = 3

max_len = 10

R2s = np.random.uniform(0, 201, num_voxels)  # R2 relaxation rates
noise = np.random.uniform(0.01, 0.055, num_voxels)  # Noise level for each voxel
gen_TEs_uniform = np.random.randint(2, 11, num_voxels)  # Number of echoes per voxel
spc_gen_ = np.random.normal(mean_space, std_dev_space, num_voxels)  # Echo spacing generation

def padding_mask(max_len, m, te_array):
    zero_padded_mags = np.zeros(max_len)
    zero_padded_tes = np.zeros(max_len)
    len_m = len(m)
    zero_padded_mags[:len_m] = m
    zero_padded_tes[:len_m] = te_array
    zero_padded_mags[len_m:] = -999
    zero_padded_tes[len_m:] = -999
    return zero_padded_mags, zero_padded_tes

def add_rician(mag, st_dev):
    noise = np.random.normal(0, st_dev, size=mag.shape)
    noisy_signal = np.sqrt(mag**2 + noise**2)
    return noisy_signal

def writefile(filename, start_idx, end_idx):
    with h5py.File(filename, 'w') as f:
        for i in range(start_idx, end_idx):
            group = f.create_group(f'voxel_{i}')
            r2s = R2s[i]
            random_start = np.random.normal(mean_start, std_dev_start)
            start_trunc = min(max(random_start, 3), 7)
            spc_gen = spc_gen_[i]
            echo_space = min(max(spc_gen, 2), 8)
            number_of_echos = gen_TEs_uniform[i]

            te_array = start_trunc + np.arange(0, number_of_echos, 1) * echo_space
            m = np.exp(- (te_array / 1000) * r2s)
            group.attrs['id'] = i
            group.attrs['magnitudes'] = m
            group.attrs['echo_space'] = echo_space
            group.attrs['R2s'] = r2s
            group.attrs['TEs'] = te_array
            group.attrs['st_dev'] = noise[i]

            max_mag = np.max(m)
            normalize_mags = np.divide(m, max_mag)
            noisy_mags = add_rician(normalize_mags, noise[i])
            padded_norm_noisy_mags, padded_TEs = padding_mask(max_len, noisy_mags, te_array)
            group.attrs['Padded_TEs'] = padded_TEs
            group.attrs['Padded_Norm_noisy_mags'] = padded_norm_noisy_mags

if __name__ == '__main__':
    for file_index in range(num_files):
        start = file_index * voxels_per_file
        end = start + voxels_per_file
        filename = f'train_voxel_data_{file_index + 1}_of_{num_files}.h5'
        writefile(filename, start, end)