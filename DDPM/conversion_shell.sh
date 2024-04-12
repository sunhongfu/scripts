find . -name "echo_01_slice_001.npy" -exec dirname {} \; > folders.txt

while IFS= read -r folder; do python convert_to_hdf5.py "$folder" "$folder/../complex_slices.h5"; done < folders.txt

find . -type d -name "complex_slices" -exec rm -r {} +