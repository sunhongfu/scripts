import h5py
import numpy as np


# Example data
num_voxels = 8000000

mean_start = 5
std_dev_start = 2

mean_space = 5
std_dev_space = 3

max_len = 10

R2s = np.random.uniform(0, 201, num_voxels)  # np.random.uniform(low, high, sample_size)

noise = np.random.uniform(0.01, 0.055, num_voxels)

gen_TEs_uniform = np.random.randint(2, 11, num_voxels)

spc_gen_ = np.random.normal(mean_space, std_dev_space, num_voxels)


def padding_mask(max_len, m, te_array): # padding_mask(max_len, noisy_mags, te_array)
    zero_padded_mags = np.zeros(max_len)
    zero_padded_tes = np.zeros(max_len)
    if (len(m) < max_len):
        rng = len(m)
        zero_padded_mags[:rng] = m
        zero_padded_tes[:rng] = te_array
        ################################
        zero_padded_mags[rng: ] = -999
        zero_padded_tes[rng: ] = -999
    if (len(m) == max_len):
        zero_padded_mags[:] = m[:]
        zero_padded_tes[:] = te_array[:]
    #print(f"zero_padded_mags: {zero_padded_mags}\nzero_padded_tes: {zero_padded_tes}")
    return zero_padded_mags, zero_padded_tes


def add_rician(mag, st_dev):
    real_img = np.real(mag)
    imaginary_part = np.imag(mag)

    shape_real = real_img.shape

    real_noisy_image = real_img + 1 * st_dev * np.random.normal(size=shape_real)
    shape_imag = imaginary_part.shape
    imaginary_noisy_image = imaginary_part + 1 * st_dev * np.random.normal(size=shape_imag)

    noisy_signal = ((real_noisy_image) ** 2 + imaginary_noisy_image ** 2) ** 0.5
    return noisy_signal


# Create an HDF5 file
def writefile(filename='voxel_data.h5'):
    # os.makedirs(os.path.dirname(filename), exist_ok=True)
    with h5py.File(filename, 'w') as f:
        for i in range(num_voxels):
            group = f.create_group(f'voxel_{i}')
            r2s = R2s[i]
            random_start = np.random.normal(mean_start, std_dev_start)
            start_trunc = min(max(random_start, 3), 7)  # for val in random_start]
            # gen echo space
            spc_gen = spc_gen_[i]

            echo_space = min(max(spc_gen, 2), 8)  # for val in spc_gen]
            gen_TEs_uniform_ = gen_TEs_uniform[i]
            number_of_echos = gen_TEs_uniform_  # number_of_echos = np.random.randint(2, 11) # upto 10

            te_array = start_trunc + np.arange(0, number_of_echos, 1) * echo_space
            m = 1 * (np.exp(- (te_array / 1000) * r2s))
            group.attrs['id'] = i

            group.attrs['magnitudes'] = m
            group.attrs['echo_space'] = echo_space
            group.attrs['R2s'] = r2s
            group.attrs['TEs'] = te_array
            group.attrs['st_dev'] = noise[i]

            max_mag = np.max(m)
            normalize_mags = np.divide(m, max_mag)

            noisy_mags = add_rician(normalize_mags, noise[i])
            group.attrs['noisy_magnitudes'] = noisy_mags

            padded_norm_noisy_mags, padded_TEs = padding_mask(max_len, noisy_mags, te_array)
            group.attrs['Padded_TEs'] = padded_TEs
            group.attrs['Padded_Norm_noisy_mags'] = padded_norm_noisy_mags


if __name__ == '__main__':
    writefile(filename='train_voxel_data_8M.h5')
    # writefile(filename='val_voxel_data.h5') # generate some validation data too
