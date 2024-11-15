from data_prep import *

if __name__ == "__main__":
   nifti_dir = "/Volumes/LaCie_Bottom/collaborators/Zhaolin_Chen/Data_For_Hongfu/split_data/HIGH_b900"
   save_dir = "/Volumes/LaCie_Bottom/collaborators/Zhaolin_Chen/Data_For_Hongfu/split_data/HIGH_b900_slices"
   os.makedirs(save_dir, exist_ok=True)
   save_nifti_slices_as_npy(nifti_dir, save_dir)

   # convert_npy_to_nii("/Volumes/LaCie_Bottom/collaborators/Zhaolin_Chen/Data_For_Hongfu/split_data/HIGH_b0_slices/POCEMR105_DIF_1_slice016.npy")
