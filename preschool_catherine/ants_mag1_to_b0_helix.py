import os
import re
import sys
import glob

merge_folder = sys.argv[1]
output_file = sys.argv[2]

# do if there is b0 map
for name in glob.glob(merge_folder + "/*.nii"):
	#print name
	with open(output_file, 'a') as f:
    		print >> f, name
	if re.match(".*_(\S+)_B0_n4_DC_corr\.nii", name):

		b0_file_n4            = os.path.abspath(os.path.join(merge_folder, name))
		mag_sos_n4            = os.path.abspath(os.path.join(merge_folder, "mag_sos_RAS_masked_n4.nii"))
		ants_trans_T2s_to_B0  = os.path.abspath(os.path.join(merge_folder, "ANTs_trans_T2s_to_B0"))
		ants_T2s_to_B0        = os.path.abspath(os.path.join(merge_folder, "ANTs_T2s_to_B0.nii.gz"))
		flirt_trans_T2s_to_B0 = os.path.abspath(os.path.join(merge_folder, "flirt_trans_T2s_to_B0.mat"))
		flirt_T2s_to_B0       = os.path.abspath(os.path.join(merge_folder, "flirt_T2s_to_B0.nii.gz"))
		qsmImage1             = os.path.abspath(os.path.join(merge_folder, "chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS.nii"))	
		qsmImage2             = os.path.abspath(os.path.join(merge_folder, "chi_iLSQR_peel1_RAS.nii"))
		qsmImage3             = os.path.abspath(os.path.join(merge_folder, "MEDI2000_LBV_peel1_RAS.nii"))
		qsmImage4             = os.path.abspath(os.path.join(merge_folder, "TFI_lbv_v2d_lambda2000_peel_1_RAS.nii"))
		qsmANTsOutImage1      = os.path.abspath(os.path.join(merge_folder, "chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS_ants_to_B0.nii"))
		qsmANTsOutImage2      = os.path.abspath(os.path.join(merge_folder, "chi_iLSQR_peel1_RAS_ants_to_B0.nii.nii"))
		qsmANTsOutImage3      = os.path.abspath(os.path.join(merge_folder, "MEDI2000_LBV_peel1_RAS_ants_to_B0.nii.nii"))
		qsmANTsOutImage4      = os.path.abspath(os.path.join(merge_folder, "TFI_lbv_v2d_lambda2000_peel_1_RAS_ants_to_B0.nii.nii"))
		qsmFlirtOutImage1     = os.path.abspath(os.path.join(merge_folder, "chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS_flirt_to_B0.nii"))
		qsmFlirtOutImage2     = os.path.abspath(os.path.join(merge_folder, "chi_iLSQR_peel1_RAS_flirt_to_B0.nii.nii"))
		qsmFlirtOutImage3     = os.path.abspath(os.path.join(merge_folder, "MEDI2000_LBV_peel1_RAS_flirt_to_B0.nii.nii"))
		qsmFlirtOutImage4     = os.path.abspath(os.path.join(merge_folder, "TFI_lbv_v2d_lambda2000_peel_1_RAS_flirt_to_B0.nii.nii"))


		# do FLIRT 12DOF, 90degree, multualinfo
		cmd1 = ("flirt -in " + mag_sos_n4 + " -ref " + b0_file_n4 + " -out " + flirt_T2s_to_B0 + " -omat " + flirt_trans_T2s_to_B0 + " -bins 256 -cost mutualinfo -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear \n"
				"flirt -in " + qsmImage1 + " -applyxfm -init " + flirt_trans_T2s_to_B0 + " -out " + qsmFlirtOutImage1 + " -paddingsize 0.0 -interp trilinear -ref " + flirt_T2s_to_B0 + "\n"
				"flirt -in " + qsmImage2 + " -applyxfm -init " + flirt_trans_T2s_to_B0 + " -out " + qsmFlirtOutImage2 + " -paddingsize 0.0 -interp trilinear -ref " + flirt_T2s_to_B0 + "\n"
				"flirt -in " + qsmImage3 + " -applyxfm -init " + flirt_trans_T2s_to_B0 + " -out " + qsmFlirtOutImage3 + " -paddingsize 0.0 -interp trilinear -ref " + flirt_T2s_to_B0 + "\n"
				"flirt -in " + qsmImage4 + " -applyxfm -init " + flirt_trans_T2s_to_B0 + " -out " + qsmFlirtOutImage4 + " -paddingsize 0.0 -interp trilinear -ref " + flirt_T2s_to_B0 + "\n")
		
		with open(output_file, 'a') as f:
                	print >> f, cmd1
		os.system(cmd1)


		# do ANTs
		cmd2 = ( "its=10000x1111x5\n"
		"ref=" + b0_file_n4 + "\n"
		"src=" + mag_sos_n4 + "\n"
		"transformPrefix=" + ants_trans_T2s_to_B0 + "\n"
		"warpedImage=" + ants_T2s_to_B0 + "\n"
		"qsmImage1=" + qsmImage1 + "\n"
		"qsmImage2=" + qsmImage2 + "\n"
		"qsmImage3=" + qsmImage3 + "\n"
		"qsmImage4=" + qsmImage4 + "\n"
                        "qsmANTsOutImage1=" + qsmANTsOutImage1 + "\n"
                        "qsmANTsOutImage2=" + qsmANTsOutImage2 + "\n"
                        "qsmANTsOutImage3=" + qsmANTsOutImage3 + "\n"
                        "qsmANTsOutImage4=" + qsmANTsOutImage4 + "\n"
		"antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]" + "\n"
		"antsApplyTransforms -d 3 -i $qsmImage1 -r $ref -o $qsmANTsOutImage1 -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat" + "\n"
		"antsApplyTransforms -d 3 -i $qsmImage2 -r $ref -o $qsmANTsOutImage2 -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat" + "\n"
		"antsApplyTransforms -d 3 -i $qsmImage3 -r $ref -o $qsmANTsOutImage3 -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat" + "\n"
		"antsApplyTransforms -d 3 -i $qsmImage4 -r $ref -o $qsmANTsOutImage4 -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat" + "\n" )

		with open(output_file, 'a') as f:
                	print >> f, cmd2
		os.system(cmd2)
