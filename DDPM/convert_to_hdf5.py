import h5py
import numpy as np
import os
import sys

def convert_to_hdf5(folder_path, output_file):
    data_list = []
    for root, _, files in os.walk(folder_path):
        for file in files:
            if file.endswith('.npy'):
                file_path = os.path.join(root, file)
                data = np.load(file_path)
                data_list.append(data)

    with h5py.File(output_file, 'w') as f:
        f.create_dataset('data', data=data_list, dtype='complex128')

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python convert_to_hdf5.py input_folder output_file")
        sys.exit(1)

    input_folder = sys.argv[1]
    output_file = sys.argv[2]

    convert_to_hdf5(input_folder, output_file)

