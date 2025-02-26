cd /Volumes/LaCie_Bottom/collaborators/Zhaolin_Chen/Data_For_Hongfu

folder_T1_3T="3T_T1_Ref_And_Mask/T1_Reg"
folder_DWI_ULF="64mT"
folder_DWI_3T="3T"
folder_64mT_to_3T="64mT_to_3T"
folder_T1_to_b900_3T="T1_to_b900_3T"
folder_T1_to_b0_3T="T1_to_b0_3T"
folder_T1_bet="T1_brain_extraction"
folder_mask_to_b0_3T="mask_to_b0_3T"
folder_mask_to_b900_3T="mask_to_b900_3T"




####################################################################################
# 
# register ULF_b0 to 3T_b0
#
#
mkdir $folder_64mT_to_3T
# Loop through all files in the directory that contain 'b_0'
for file_b0_64mT in "$folder_DWI_ULF"/*b_0.nii.gz; do
    # Get base name from the path
    base_name=$(basename "$file_b0_64mT")
    # Extract the part of the subject name before the first underscore
    subject_name=$(echo "$base_name" | cut -d'_' -f1)
    # Print the subject name
    echo $subject_name

    file_b0_3T=$folder_DWI_3T/${subject_name}_DIF_1.nii.gz

    # perform image registration of ULF_B0 to 3T_B0
    /Users/uqhsun8/fsl/bin/flirt -in $file_b0_64mT -ref $file_b0_3T -out $folder_64mT_to_3T/${subject_name}_DIF_b_0_64mT_to_3T.nii.gz -omat $folder_64mT_to_3T/${subject_name}_DIF_b_0_64mT_to_3T.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear

done




####################################################################################
# 
# register ULF_b900 to 3T_b900
#
#
mkdir $folder_64mT_to_3T
# Loop through all files in the directory that contain 'b_900'
for b900_64mT in "$folder_DWI_ULF"/*b_900.nii.gz; do
    # Get base name from the path
    base_name=$(basename "$b900_64mT")
    # Extract the part of the subject name before the first underscore
    subject_name=$(echo "$base_name" | cut -d'_' -f1)
    # Print the subject name
    echo $subject_name

    b900_3T=$folder_DWI_3T/${subject_name}_DIF_2.nii.gz

    # perform image registration of ULF_B900 to 3T_B900
    /Users/uqhsun8/fsl/bin/flirt -in $b900_64mT -ref $b900_3T -out $folder_64mT_to_3T/${subject_name}_DIF_b_900_64mT_to_3T.nii.gz -omat $folder_64mT_to_3T/${subject_name}_DIF_b_900_64mT_to_3T.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear

done




####################################################################################
# 
# register 3T T1w to 3T_b0
#
#
mkdir $folder_T1_to_b0_3T
# Loop through all files in the directory that contain 'b_900'
for file_T1_3T in "$folder_T1_3T"/*T1.nii.gz; do
    # Get base name from the path
    base_name=$(basename "$file_T1_3T")
    # Extract the part of the subject name before the first underscore
    subject_name=$(echo "$base_name" | cut -d'_' -f1)
    # Print the subject name
    echo $subject_name

    file_b0_3T=$folder_DWI_3T/${subject_name}_DIF_1.nii.gz

    # perform image registration of ULF_B0 to 3T_B0
    /Users/uqhsun8/fsl/bin/flirt -in $file_T1_3T -ref $file_b0_3T -out $folder_T1_to_b0_3T/${subject_name}_T1_to_b0_3T.nii.gz -omat $folder_T1_to_b0_3T/${subject_name}_T1_to_b0_3T.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear

done




####################################################################################
# 
# register 3T T1w to 3T_b900
#
#
mkdir $folder_T1_to_b900_3T
# Loop through all files in the directory that contain 'b_900'
for file_T1_3T in "$folder_T1_3T"/*T1.nii.gz; do
    # Get base name from the path
    base_name=$(basename "$file_T1_3T")
    # Extract the part of the subject name before the first underscore
    subject_name=$(echo "$base_name" | cut -d'_' -f1)
    # Print the subject name
    echo $subject_name

    file_b900_3T=$folder_DWI_3T/${subject_name}_DIF_2.nii.gz

    # perform image registration of ULF_B900 to 3T_B900
    /Users/uqhsun8/fsl/bin/flirt -in $file_T1_3T -ref $file_b900_3T -out $folder_T1_to_b900_3T/${subject_name}_T1_to_b900_3T.nii.gz -omat $folder_T1_to_b900_3T/${subject_name}_T1_to_b900_3T.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear

done




####################################################################################
#
# Brain extraction on original T1 images
mkdir $folder_T1_bet
for file_T1 in $folder_T1_3T/*T1.nii.gz; do
    # Get base name from the path
    base_name=$(basename "$file_T1")
    file_name=$(echo "$base_name" | cut -d'.' -f1)
    /Users/uqhsun8/fsl/bin/bet2 $file_T1 $folder_T1_bet/${file_name}_brain  -f 0.4 -g 0 -m -w 1 
done




####################################################################################
#
# register T1 masks to 3T DWI space using existing FLIRT matrix
mkdir $folder_mask_to_b0_3T
for brain_mask in $folder_T1_bet/*_mask.nii.gz; do
    # Get base name from the path
    base_name=$(basename "$brain_mask")
    # Extract the part of the subject name before the first underscore
    subject_name=$(echo "$base_name" | cut -d'_' -f1)

    /Users/uqhsun8/fsl/bin/flirt -in $brain_mask -applyxfm -init $folder_T1_to_b0_3T/${subject_name}_T1_to_b0_3T.mat -out $folder_mask_to_b0_3T/${subject_name}_T1_mask_to_b0_3T.nii.gz -paddingsize 0.0 -interp trilinear -ref $folder_DWI_3T/${subject_name}_DIF_1.nii.gz
done
#############################
mkdir $folder_mask_to_b900_3T
for brain_mask in $folder_T1_bet/*_mask.nii.gz; do
    # Get base name from the path
    base_name=$(basename "$brain_mask")
    # Extract the part of the subject name before the first underscore
    subject_name=$(echo "$base_name" | cut -d'_' -f1)

    /Users/uqhsun8/fsl/bin/flirt -in $brain_mask -applyxfm -init $folder_T1_to_b900_3T/${subject_name}_T1_to_b900_3T.mat -out $folder_mask_to_b900_3T/${subject_name}_T1_mask_to_b900_3T.nii.gz -paddingsize 0.0 -interp trilinear -ref $folder_DWI_3T/${subject_name}_DIF_2.nii.gz
done