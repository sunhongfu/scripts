#!/bin/bash

# main_dir=/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/new

# #recon=(pdf_full_force pdf_full resharp_ero5 resharp_ero5_force tfi_ero5 tfi_full resharp_ero5_0 resharp_ero5_5e-4)
# #eroFlag=(false false true true true false true true)
# #recon=(resharp_ero5_0 resharp_ero5_5e-4)
# #eroFlag=(true true)
# # recon=(TIK_ero0_TV_0.0004_Tik_0.001_PRE_5000 TIK_ero3_TV_0.0004_Tik_0.001_PRE_5000 iFreq_rawSS_QSM_000 TV_RESHARP_1e-6_ero3 MEDI_PDF_ero0 TFI_ero0)
# # eroFlag=(ero0 ero3 SS ero3 ero0 ero0)
# #recon=(TIK_ero1_TV_0.0004_Tik_0.001_PRE_5000 TFI_ero1)
# #eroFlag=(ero1 ero1)
# #recon=(MEDI_PDF_ero1)
# recon=(MEDI_RESHARP_1e-6_ero3)
# eroFlag=(ero3)
# dir=(11 12 13 14 15 16 17)

# paper revision 2
main_dir=/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/revision

#recon=(TFI_brain LN_brain iFreq_rawSS_QSM_new_000 MEDI_RESHARP_1e-6_ero2 MEDI_PDF_ero0)

#eroFlag=(brain brain SS ero2 ero0)
dir=(11 12 13 14 15 16 17 18 19)

#recon=(LN_ero0 LN_ero2)
#eroFlag=(ero0 ero2)

recon=(chi_resharp_iLSQR_ero2)
eroFlag=(ero2)

nsubject=${#dir[@]}

ind=0

for i in "${recon[@]}"
do	
echo "Averaging $nsubject subjects for $i recon method..."

	if [ -d "${main_dir}/group_avg/nifti" ];
	then
	echo "nifti directory exists"

	else
	echo "nifti does not exist, creating nifti directory"
	mkdir ${main_dir}/group_avg/nifti
	fi

cmd=""
cmd_mask=""
cmd_mask_mul=""
echo "initial command is $cmd"
	for ((j=0; j<$nsubject; j++))
	do
		if [ ${j} == 0 ]; then

			# normalized version:
			cmd+=" ${main_dir}/${dir[$j]}/nifti/${i}_abs_std.nii.gz"
			# non-normalzied version
			#cmd+=" ${main_dir}/${dir[$j]}/nifti/${i}_std.nii.gz"

		else
			# normalized version
			cmd+=" -add ${main_dir}/${dir[$j]}/nifti/${i}_abs_std.nii.gz"
			# non-normalized version
			#cmd+=" -add ${main_dir}/${dir[$j]}/nifti/${i}_std.nii.gz"

		fi



		if [ ! -f "${main_dir}/${dir[$j]}/nifti/mask_${eroFlag[$ind]}_std_tmp.nii.gz" ]; then
			echo "erosion flag is ${eroFlag[$ind]}"
			applywarp --ref=${FSLDIR}/data/standard/MNI152_T1_1mm --in=${main_dir}/${dir[$j]}/nifti/mask_${eroFlag[$ind]}.nii \
			--warp=${main_dir}/${dir[$j]}/transformations/warp_struct2mni.nii  --premat=${main_dir}/${dir[$j]}/transformations/suscep2struct.mat \
			--out=${main_dir}/${dir[$j]}/nifti/mask_${eroFlag[$ind]}_std_tmp.nii 

			fslmaths ${main_dir}/${dir[$j]}/nifti/mask_${eroFlag[$ind]}_std_tmp.nii -bin ${main_dir}/${dir[$j]}/nifti/mask_${eroFlag[$ind]}_std.nii
		fi

		#gunzip 	${main_dir}/${dir[$j]}/nifti/mask_${eroFlag[$ind]}_std*


		if [ ${j} == 0 ]; then
			cmd_mask+=" ${main_dir}/${dir[$j]}/nifti/mask_${eroFlag[$ind]}_std.nii"
			cmd_mask_mul+=" ${main_dir}/${dir[$j]}/nifti/mask_${eroFlag[$ind]}_std.nii"
		else
			cmd_mask+=" -add ${main_dir}/${dir[$j]}/nifti/mask_${eroFlag[$ind]}_std.nii"
			cmd_mask_mul+=" -mul ${main_dir}/${dir[$j]}/nifti/mask_${eroFlag[$ind]}_std.nii"
		fi


	done

	cmd_sml=" ${main_dir}/group_avg/nifti/${i}_avg.nii.gz"
	cmd_div_by_sum_mask=$cmd;

	cmd_mask+=" ${main_dir}/group_avg/nifti/mask_${eroFlag[$ind]}_sum_std.nii"
	cmd_mask_mul+=" ${main_dir}/group_avg/nifti/mask_${eroFlag[$ind]}_mul_std.nii"
	cmd_div_by_sum_mask+=" -div ${main_dir}/group_avg/nifti/mask_${eroFlag[$ind]}_sum_std.nii"
	cmd_sml+=" -mul ${main_dir}/group_avg/nifti/mask_${eroFlag[$ind]}_mul_std.nii"

	echo $cmd_mask
	echo $cmd_mask_mul

	fslmaths $cmd_mask
	fslmaths $cmd_mask_mul

	# normalized version begin:
	cmd+=" -div ${nsubject} ${main_dir}/group_avg/nifti/${i}_abs_avg.nii"
	cmd_div_by_sum_mask+=" ${main_dir}/group_avg/nifti/${i}_abs_avg_masked.nii"
	cmd_sml+=" ${main_dir}/group_avg/nifti/${i}_abs_avg_masked_small.nii"
	# normalized version end

	# non-normalized version begin:
	# cmd+=" -div ${nsubject} ${main_dir}/group_avg/nifti/${i}_avg.nii"
	# cmd_div_by_sum_mask+=" ${main_dir}/group_avg/nifti/${i}_avg_masked.nii"
	# cmd_sml+=" ${main_dir}/group_avg/nifti/${i}_avg_masked_small.nii"
	# non-normalized version end


	echo $cmd
	echo $cmd_div_by_sum_mask
	echo $cmd_sml

	fslmaths $cmd
	fslmaths $cmd_div_by_sum_mask
	fslmaths $cmd_sml

	ind=$(( ind + 1 ))
done