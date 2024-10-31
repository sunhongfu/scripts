import h5py
import numpy as np
import matplotlib.pyplot as plt
import os

def collect_all_r2s(filename):
    all_r2s = []

    with h5py.File(filename, 'r') as f:
        total_voxels = len(f.keys())
        print(f"Total number of voxels: {total_voxels}")

        for voxel_name in f.keys():
            voxel_group = f[voxel_name]
            if 'R2s' in voxel_group.attrs:
                r2s_value = voxel_group.attrs['R2s']
              
                all_r2s.append(r2s_value)  # Correctly append each R2s value to the list
  
    return all_r2s

def draw_r2s_distribution(all_r2s, filename='r2s_distribution.png'):
    plt.figure(figsize=(10, 6))
    plt.hist(all_r2s, bins=50, color='green', alpha=0.7)
    plt.xlabel('R2s Values')
    plt.ylabel('Frequency')
    plt.title('Distribution of R2* Values')
    plt.grid(True)
    plt.savefig(filename, bbox_inches='tight')
    plt.show()


def draw_graph_plot(voxel_group, filename, noise):
    TEs = voxel_group.get('TEs', [])
    magnitudes = voxel_group.get('magnitudes', [])
    noisy_mags = voxel_group.get('noisy_magnitudes', [])
    st_dev = noise
    if len(TEs) == 0 or len(magnitudes) == 0 or len(noisy_mags) == 0:
        print("Missing data for plotting.")
        return

    fig, axs = plt.subplots(2, 1, figsize=(10, 8))

    # First subplot for normalized magnitudes
    axs[0].plot(TEs, magnitudes, label='Normalized Mags', color='blue')
    axs[0].set_xlabel('TEs')
    axs[0].set_ylabel('Normalized Magnitudes')
    axs[0].legend()

    for x, y in zip(TEs, magnitudes):
        axs[0].text(x, y, f'{y:.2f}', fontsize=9, ha='right')

    # Second subplot for noisy magnitudes
    noisy_label = f'Rician Noisy Mags (st_dev={st_dev:.2f})'
    axs[1].plot(TEs, noisy_mags, label=noisy_label, color='red')
    axs[1].set_xlabel('TEs')
    axs[1].set_ylabel('Rician Noisy Magnitudes')
    axs[1].legend()

    for x, y in zip(TEs, noisy_mags):
        axs[1].text(x, y, f'{y:.2f}', fontsize=9, ha='right')

    fig.suptitle(f'Standard Deviation: {st_dev}', fontsize=12, ha='center')
    plt.tight_layout()
    plt.savefig(filename, bbox_inches='tight')
    plt.show()

def inspect_hdf5_file(filename, voxel_id=500):
    attributes_dict = {}
    with h5py.File(filename, 'r') as f:
        total_voxels = len(f.keys())
        print(f"Total number of voxels: {total_voxels}")

        voxel_name = f'voxel_{voxel_id}'
        if voxel_name in f:
            voxel_group = f[voxel_name]
            relevant_attributes = ['magnitudes', 'noisy_magnitudes', 'R2s', 'TEs', 'st_dev']
            for key in relevant_attributes:
                if key in voxel_group.attrs:
                    value = voxel_group.attrs[key]
                    attributes_dict[key] = value
                    print(f"{key}: {value}")
                else:
                    attributes_dict[key] = None
        else:
            print(f"Voxel {voxel_id} not found in the file.")

    return attributes_dict

# Usage
voxel_group = inspect_hdf5_file('/home/samiha/PycharmProjects/new_data_gen/rician_data_gen/voxel_data.h5', voxel_id=799)
draw_graph_plot(voxel_group, filename='output_plot.png', noise=voxel_group['st_dev'])

all_r2s = collect_all_r2s('/home/samiha/PycharmProjects/new_data_gen/rician_data_gen/voxel_data.h5')
draw_r2s_distribution(all_r2s, filename='r2s_distribution.png')