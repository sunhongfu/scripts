# brain masking the ULF b0
# 1. extract T1 brain 
/Users/uqhsun8/fsl/bin/bet2 /Users/uqhsun8/Downloads/POCEMR103/POCEMR103_T1.nii.gz /Users/uqhsun8/Downloads/POCEMR103/POCEMR103_T1_brain  -f 0.2 -g 0 -m -w 2
# 2. register T1 brain to ULF_b0
/Users/uqhsun8/fsl/bin/flirt -in /Users/uqhsun8/Downloads/POCEMR103/POCEMR103_T1.nii.gz -ref /Users/uqhsun8/Downloads/POCEMR103/POCEMR103_DIF_b_0.nii.gz -out /Users/uqhsun8/Downloads/POCEMR103/POCEMR103_T1_to_b0.nii.gz -omat /Users/uqhsun8/Downloads/POCEMR103/POCEMR103_T1_to_b0.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
# 3. apply transformation
/Users/uqhsun8/fsl/bin/flirt -in /Users/uqhsun8/Downloads/POCEMR103/POCEMR103_T1_brain_mask.nii.gz -applyxfm -init /Users/uqhsun8/Downloads/POCEMR103/POCEMR103_T1_to_b0.mat -out /Users/uqhsun8/Downloads/POCEMR103/POCEMR103_DIF_b_0_brain_mask.nii.gz -paddingsize 0.0 -interp trilinear -ref /Users/uqhsun8/Downloads/POCEMR103/POCEMR103_DIF_b_0.nii.gz



#!/bin/bash

# Directory containing the files
directory="64mT"

# Loop through all files in the directory that contain 'b_0'
for file in "$directory"/*b_900*; do
    # Extract filename from the path
    filename=$(basename "$file")
    
    # Extract the part of the filename before the first underscore
    base_name=$(echo "$filename" | cut -d'_' -f1)

    # Print the extracted part
    echo $base_name

    # perform image registration of ULF B0 to 3T T1w
    /Users/uqhsun8/fsl/bin/flirt -in 64mT/${base_name}_DIF_b_900.nii.gz -ref 3T_T1_Ref_And_Mask/T1_Reg/${base_name}_T1.nii.gz -out 64mT_to_T1/${base_name}_DIF_b_900_to_T1.nii.gz -omat 64mT_to_T1/${base_name}_DIF_b_900_to_T1.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear

done


#!/bin/bash

# Directory containing the files
directory="3T"

# Loop through all files in the directory that contain 'b_0'
for file in "$directory"/*DIF_1*; do
    # Extract filename from the path
    filename=$(basename "$file")
    
    # Extract the part of the filename before the first underscore
    base_name=$(echo "$filename" | cut -d'_' -f1)

    # Print the extracted part
    echo $base_name

    # perform image registration of ULF B0 to 3T T1w
    /Users/uqhsun8/fsl/bin/flirt -in 3T_T1_Ref_And_Mask/T1_Reg/${base_name}_T1.nii.gz -ref 3T/${base_name}_DIF_1.nii.gz -out T1_to_3TDWI/${base_name}_T1_to_3TDWI.nii.gz -omat T1_to_3TDWI/${base_name}_T1_to_3TDWI.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear

done


#!/bin/bash

# Directory containing the files
directory="64mT"

# Loop through all files in the directory that contain 'b_0'
for file in "$directory"/*b_0*; do
    # Extract filename from the path
    filename=$(basename "$file")
    
    # Extract the part of the filename before the first underscore
    base_name=$(echo "$filename" | cut -d'_' -f1)

    # Print the extracted part
    echo $base_name

    # perform image registration of ULF B0 to 3T T1w
    /Users/uqhsun8/fsl/bin/flirt -in 64mT/${base_name}_DIF_b_0.nii.gz -ref 3T/${base_name}_DIF_1.nii.gz -out 64mT_to_3TDWI/${base_name}_DIF_b_0_to_3TDWI.nii.gz -omat 64mT_to_T1/${base_name}_DIF_b_0_to_3TDWI.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear

done




# ULF to T1 then to 3T DWI
# Directory containing the files
directory="64mT_to_T1"
# Loop through all files in the directory that contain 'b_0'
for file in "$directory"/*b_0_to_T1.nii.gz*; do
    # Extract filename from the path
    filename=$(basename "$file")
    
    # Extract the part of the filename before the first underscore
    base_name=$(echo "$filename" | cut -d'_' -f1)

    # Print the extracted part
    echo $base_name


    /Users/uqhsun8/fsl/bin/flirt -in 64mT_to_T1/${base_name}_DIF_b_0_to_T1.nii.gz -applyxfm -init T1_to_3TDWI/${base_name}_T1_to_3TDWI.mat -out 64mT_to_T1_to_3TDWI/${base_name}_to_T1_to_3TDWI.nii.gz -paddingsize 0.0 -interp trilinear -ref 3T/${base_name}_DIF_1.nii.gz

done