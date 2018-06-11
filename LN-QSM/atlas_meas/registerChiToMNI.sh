#!/bin/bash

# previous analysis
# main_dir=/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/new
# dir=(11 12 13 14 15 16 17)
# #dir=(14)
# #recon=(pdf_full_force pdf_full resharp_ero5 resharp_ero5_force tfi_ero5 tfi_full resharp_ero5_0 resharp_ero5_5e-4)
# #eroFlag=(false false true true true false true true)

# #recon=(TIK_ero0_TV_0.0004_Tik_0.001_PRE_5000 TIK_ero1_TV_0.0004_Tik_0.001_PRE_5000 TIK_ero3_TV_0.0004_Tik_0.001_PRE_5000 iFreq_rawSS_QSM_000 TV_RESHARP_1e-6_ero3 MEDI_PDF_ero0 TFI_ero0 TFI_ero1)


# recon=(MEDI_RESHARP_1e-6_ero3)
# eroFlag=(ero3)

# ref_region=dwm
# #recon=(resharp_ero5_0 resharp_ero5_5e-4)
# #eroFlag=(true true)

main_dir=/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/revision
#dir=(11 12 13 14 15 16 17)
dir=(11 12 13 14 15 16 17 18 19)
#recon=(TFI_brain LN_brain iFreq_rawSS_QSM_new_000 MEDI_RESHARP_1e-6_ero2 MEDI_PDF_ero0)

#eroFlag=(brain brain SS ero2 ero0)

#recon=(LN_ero0 LN_ero2)
#eroFlag=(ero0 ero2)

ref_region=dwm
#recon=(resharp_ero5_0 resharp_ero5_5e-4)
#eroFlag=(true true)

recon=(chi_resharp_iLSQR_ero2)
eroFlag=(ero2)

for i in "${dir[@]}"
	do
	
	echo $main_dir/$i
	cd $main_dir/$i

	if [ -d "./nifti" ];
	then
	echo "nifti directory exists"

	else
	echo "nifti does not exist, creating nifti directory"
	mkdir nifti
	fi


	#register GRE to t1
	
	if [ ! -f "./nifti/t1.nii" ]; then

		mnc2nii_opt.pl t1.mnc nifti/t1.nii
	fi
	if [ ! -f "./nifti/mag1.nii" ]; then
		mnc2nii_opt.pl mag1.mnc nifti/mag1.nii
	fi
	
	if [ ! -d "./transformations" ];
	then
		mkdir transformations

	fi


	if [ ! -f "transformations/aff_struct2mni.mat" ]; then
		
	
	echo "registering GRE to MNI152..."
	echo "running flirt..."
	flirt -ref nifti/t1.nii -in nifti/mag1.nii -omat transformations/suscep2struct.mat -dof 6
	bet nifti/t1.nii nifti/betted_t1.nii
	flirt -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain.nii -in nifti/betted_t1.nii -omat transformations/aff_struct2mni.mat
	fi

	if [ ! -f "transformations/warp_struct2mni.nii.gz" ]; then
	echo "running fnirt..."
	fnirt --in=nifti/t1.nii --aff=transformations/aff_struct2mni.mat --cout=transformations/warp_struct2mni.nii \
          --config=T1_2_MNI152_2mm
    fi

	ind=0
	for j in "${recon[@]}"
	do	
	
		echo $j
		echo "ind is $ind" 


		echo "erosion flag is ${eroFlag[$ind]}"

		# normalized chi
		minccalc -clobber -expression 'A[0]*A[1]' minc/chi_${ref_region}_ref/${j}_abs.mnc minc/mask_${eroFlag[$ind]}_.mnc minc/chi_${ref_region}_ref/${j}_abs_masked.mnc
		
		
		mnc2nii_opt.pl minc/chi_${ref_region}_ref/${j}_abs_masked.mnc nifti/${j}_abs.nii	
		
		applywarp --ref=${FSLDIR}/data/standard/MNI152_T1_1mm --in=nifti/${j}_abs.nii \
			  --warp=transformations/warp_struct2mni.nii  --premat=transformations/suscep2struct.mat \
		 	  --out=nifti/${j}_abs_std.nii 

		# not normalized chi
		minccalc -clobber -expression 'A[0]*A[1]' minc/${j}.mnc minc/mask_${eroFlag[$ind]}_.mnc minc/${j}_masked.mnc
			
		mnc2nii_opt.pl minc/${j}_masked.mnc nifti/${j}.nii	
		
		applywarp --ref=${FSLDIR}/data/standard/MNI152_T1_1mm --in=nifti/${j}.nii \
			  --warp=transformations/warp_struct2mni.nii  --premat=transformations/suscep2struct.mat \
		 	  --out=nifti/${j}_std.nii 

	ind=$(( ind + 1 ))
	done
	
	
done
