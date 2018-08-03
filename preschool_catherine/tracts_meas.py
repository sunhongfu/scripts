import os
import re
import sys
import glob

merge_folder = "/home/hongfu.sun/data/project_preschool/merge/"

output_file_CC_Body     = "/home/hongfu.sun/data/project_preschool/CC_Body.txt"
output_file_CC_Genu     = "/home/hongfu.sun/data/project_preschool/CC_Genu.txt"
output_file_CC_Splenium = "/home/hongfu.sun/data/project_preschool/CC_Splenium.txt"
output_file_Fornix      = "/home/hongfu.sun/data/project_preschool/Fornix.txt"
output_file_L_Cingulum  = "/home/hongfu.sun/data/project_preschool/L_Cingulum.txt"
output_file_R_Cingulum  = "/home/hongfu.sun/data/project_preschool/R_Cingulum.txt"
output_file_L_IFO       = "/home/hongfu.sun/data/project_preschool/L_IFO.txt"
output_file_R_IFO       = "/home/hongfu.sun/data/project_preschool/R_IFO.txt"
output_file_L_ILF       = "/home/hongfu.sun/data/project_preschool/L_ILF.txt"
output_file_R_ILF       = "/home/hongfu.sun/data/project_preschool/R_ILF.txt"
output_file_L_Pyramidal = "/home/hongfu.sun/data/project_preschool/L_Pyramidal.txt"
output_file_R_Pyramidal = "/home/hongfu.sun/data/project_preschool/R_Pyramidal.txt"
output_file_L_SLF       = "/home/hongfu.sun/data/project_preschool/L_SLF.txt"
output_file_R_SLF       = "/home/hongfu.sun/data/project_preschool/R_SLF.txt"
output_file_L_Uncinate  = "/home/hongfu.sun/data/project_preschool/L_Uncinate.txt"
output_file_R_Uncinate  = "/home/hongfu.sun/data/project_preschool/R_Uncinate.txt"


# measure different tracts in exists
for root, dirs, files in os.walk(merge_folder):
	for name in files:
		if re.match(".*CC_*Body.*\.nii", name):
			tract = os.path.abspath(os.path.join(root, name))
			qsm_folder = os.path.abspath(os.path.join(root, ".."))
			subject = os.path.basename(qsm_folder)
			with open(output_file_CC_Body, 'a') as f:
				print >> f, subject
				# print >> f, tract
        		# print >> f, qsm_folder
			cmd = ("fslstats " + qsm_folder + "/*FA.nii -k " + tract + " -M >> " + output_file_CC_Body + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*MD.nii -k " + tract + " -M >> " + output_file_CC_Body + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*RD.nii -k " + tract + " -M >> " + output_file_CC_Body + " 2>&1")
			os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_CC_Body + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_iLSQR_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_CC_Body + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/MEDI2000_LBV_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_CC_Body + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/TFI_lbv_v2d_lambda2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_CC_Body + " 2>&1")
			# os.system(cmd)


		if re.match(".*CC_*Genu.*\.nii", name):
			tract = os.path.abspath(os.path.join(root, name))
			qsm_folder = os.path.abspath(os.path.join(root, ".."))
			subject = os.path.basename(qsm_folder)
			with open(output_file_CC_Genu, 'a') as f:
				print >> f, subject
				# print >> f, tract
        		# print >> f, qsm_folder
			cmd = ("fslstats " + qsm_folder + "/*FA.nii -k " + tract + " -M >> " + output_file_CC_Genu + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*MD.nii -k " + tract + " -M >> " + output_file_CC_Genu + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*RD.nii -k " + tract + " -M >> " + output_file_CC_Genu + " 2>&1")
			os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_CC_Genu + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_iLSQR_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_CC_Genu + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/MEDI2000_LBV_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_CC_Genu + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/TFI_lbv_v2d_lambda2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_CC_Genu + " 2>&1")
			# os.system(cmd)


		if re.match(".*CC_*Splenium.*\.nii", name):
			tract = os.path.abspath(os.path.join(root, name))
			qsm_folder = os.path.abspath(os.path.join(root, ".."))
			subject = os.path.basename(qsm_folder)
			with open(output_file_CC_Splenium, 'a') as f:
				print >> f, subject
				# print >> f, tract
        		# print >> f, qsm_folder
			cmd = ("fslstats " + qsm_folder + "/*FA.nii -k " + tract + " -M >> " + output_file_CC_Splenium + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*MD.nii -k " + tract + " -M >> " + output_file_CC_Splenium + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*RD.nii -k " + tract + " -M >> " + output_file_CC_Splenium + " 2>&1")
			os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_CC_Splenium + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_iLSQR_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_CC_Splenium + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/MEDI2000_LBV_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_CC_Splenium + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/TFI_lbv_v2d_lambda2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_CC_Splenium + " 2>&1")
			# os.system(cmd)


		if re.match(".*Fornix.*\.nii", name):
			tract = os.path.abspath(os.path.join(root, name))
			qsm_folder = os.path.abspath(os.path.join(root, ".."))
			subject = os.path.basename(qsm_folder)
			with open(output_file_Fornix, 'a') as f:
				print >> f, subject
				# print >> f, tract
        		# print >> f, qsm_folder
			cmd = ("fslstats " + qsm_folder + "/*FA.nii -k " + tract + " -M >> " + output_file_Fornix + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*MD.nii -k " + tract + " -M >> " + output_file_Fornix + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*RD.nii -k " + tract + " -M >> " + output_file_Fornix + " 2>&1")
			os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_Fornix + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_iLSQR_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_Fornix + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/MEDI2000_LBV_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_Fornix + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/TFI_lbv_v2d_lambda2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_Fornix + " 2>&1")
			# os.system(cmd)


		if re.match(".*L_*Cingulum.*\.nii", name):
			tract = os.path.abspath(os.path.join(root, name))
			qsm_folder = os.path.abspath(os.path.join(root, ".."))
			subject = os.path.basename(qsm_folder)
			with open(output_file_L_Cingulum, 'a') as f:
				print >> f, subject
				# print >> f, tract
        		# print >> f, qsm_folder
			cmd = ("fslstats " + qsm_folder + "/*FA.nii -k " + tract + " -M >> " + output_file_L_Cingulum + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*MD.nii -k " + tract + " -M >> " + output_file_L_Cingulum + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*RD.nii -k " + tract + " -M >> " + output_file_L_Cingulum + " 2>&1")
			os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_Cingulum + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_iLSQR_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_Cingulum + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/MEDI2000_LBV_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_Cingulum + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/TFI_lbv_v2d_lambda2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_Cingulum + " 2>&1")
			# os.system(cmd)


		if re.match(".*R_*Cingulum.*\.nii", name):
			tract = os.path.abspath(os.path.join(root, name))
			qsm_folder = os.path.abspath(os.path.join(root, ".."))
			subject = os.path.basename(qsm_folder)
			with open(output_file_R_Cingulum, 'a') as f:
				print >> f, subject
				# print >> f, tract
        		# print >> f, qsm_folder
			cmd = ("fslstats " + qsm_folder + "/*FA.nii -k " + tract + " -M >> " + output_file_R_Cingulum + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*MD.nii -k " + tract + " -M >> " + output_file_R_Cingulum + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*RD.nii -k " + tract + " -M >> " + output_file_R_Cingulum + " 2>&1")
			os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_Cingulum + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_iLSQR_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_Cingulum + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/MEDI2000_LBV_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_Cingulum + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/TFI_lbv_v2d_lambda2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_Cingulum + " 2>&1")
			# os.system(cmd)


		if re.match(".*L_*IFO.*\.nii", name):
			tract = os.path.abspath(os.path.join(root, name))
			qsm_folder = os.path.abspath(os.path.join(root, ".."))
			subject = os.path.basename(qsm_folder)
			with open(output_file_L_IFO, 'a') as f:
				print >> f, subject
				# print >> f, tract
        		# print >> f, qsm_folder
			cmd = ("fslstats " + qsm_folder + "/*FA.nii -k " + tract + " -M >> " + output_file_L_IFO + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*MD.nii -k " + tract + " -M >> " + output_file_L_IFO + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*RD.nii -k " + tract + " -M >> " + output_file_L_IFO + " 2>&1")
			os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_IFO + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_iLSQR_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_IFO + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/MEDI2000_LBV_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_IFO + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/TFI_lbv_v2d_lambda2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_IFO + " 2>&1")
			# os.system(cmd)


		if re.match(".*R_*IFO.*\.nii", name):
			tract = os.path.abspath(os.path.join(root, name))
			qsm_folder = os.path.abspath(os.path.join(root, ".."))
			subject = os.path.basename(qsm_folder)
			with open(output_file_R_IFO, 'a') as f:
				print >> f, subject
				# print >> f, tract
        		# print >> f, qsm_folder
			cmd = ("fslstats " + qsm_folder + "/*FA.nii -k " + tract + " -M >> " + output_file_R_IFO + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*MD.nii -k " + tract + " -M >> " + output_file_R_IFO + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*RD.nii -k " + tract + " -M >> " + output_file_R_IFO + " 2>&1")
			os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_IFO + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_iLSQR_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_IFO + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/MEDI2000_LBV_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_IFO + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/TFI_lbv_v2d_lambda2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_IFO + " 2>&1")
			# os.system(cmd)


		if re.match(".*L_*ILF.*\.nii", name):
			tract = os.path.abspath(os.path.join(root, name))
			qsm_folder = os.path.abspath(os.path.join(root, ".."))
			subject = os.path.basename(qsm_folder)
			with open(output_file_L_ILF, 'a') as f:
				print >> f, subject
				# print >> f, tract
        		# print >> f, qsm_folder
			cmd = ("fslstats " + qsm_folder + "/*FA.nii -k " + tract + " -M >> " + output_file_L_ILF + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*MD.nii -k " + tract + " -M >> " + output_file_L_ILF + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*RD.nii -k " + tract + " -M >> " + output_file_L_ILF + " 2>&1")
			os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_ILF + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_iLSQR_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_ILF + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/MEDI2000_LBV_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_ILF + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/TFI_lbv_v2d_lambda2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_ILF + " 2>&1")
			# os.system(cmd)


		if re.match(".*R_*ILF.*\.nii", name):
			tract = os.path.abspath(os.path.join(root, name))
			qsm_folder = os.path.abspath(os.path.join(root, ".."))
			subject = os.path.basename(qsm_folder)
			with open(output_file_R_ILF, 'a') as f:
				print >> f, subject
				# print >> f, tract
        		# print >> f, qsm_folder
			cmd = ("fslstats " + qsm_folder + "/*FA.nii -k " + tract + " -M >> " + output_file_R_ILF + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*MD.nii -k " + tract + " -M >> " + output_file_R_ILF + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*RD.nii -k " + tract + " -M >> " + output_file_R_ILF + " 2>&1")
			os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_ILF + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_iLSQR_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_ILF + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/MEDI2000_LBV_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_ILF + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/TFI_lbv_v2d_lambda2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_ILF + " 2>&1")
			# os.system(cmd)


		if re.match(".*L_*Pyramidal.*\.nii", name):
			tract = os.path.abspath(os.path.join(root, name))
			qsm_folder = os.path.abspath(os.path.join(root, ".."))
			subject = os.path.basename(qsm_folder)
			with open(output_file_L_Pyramidal, 'a') as f:
				print >> f, subject
				# print >> f, tract
        		# print >> f, qsm_folder
			cmd = ("fslstats " + qsm_folder + "/*FA.nii -k " + tract + " -M >> " + output_file_L_Pyramidal + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*MD.nii -k " + tract + " -M >> " + output_file_L_Pyramidal + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*RD.nii -k " + tract + " -M >> " + output_file_L_Pyramidal + " 2>&1")
			os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_Pyramidal + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_iLSQR_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_Pyramidal + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/MEDI2000_LBV_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_Pyramidal + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/TFI_lbv_v2d_lambda2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_Pyramidal + " 2>&1")
			# os.system(cmd)


		if re.match(".*R_*Pyramidal.*\.nii", name):
			tract = os.path.abspath(os.path.join(root, name))
			qsm_folder = os.path.abspath(os.path.join(root, ".."))
			subject = os.path.basename(qsm_folder)
			with open(output_file_R_Pyramidal, 'a') as f:
				print >> f, subject
				# print >> f, tract
        		# print >> f, qsm_folder
			cmd = ("fslstats " + qsm_folder + "/*FA.nii -k " + tract + " -M >> " + output_file_R_Pyramidal + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*MD.nii -k " + tract + " -M >> " + output_file_R_Pyramidal + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*RD.nii -k " + tract + " -M >> " + output_file_R_Pyramidal + " 2>&1")
			os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_Pyramidal + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_iLSQR_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_Pyramidal + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/MEDI2000_LBV_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_Pyramidal + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/TFI_lbv_v2d_lambda2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_Pyramidal + " 2>&1")
			# os.system(cmd)


		if re.match(".*L_*SLF.*\.nii", name):
			tract = os.path.abspath(os.path.join(root, name))
			qsm_folder = os.path.abspath(os.path.join(root, ".."))
			subject = os.path.basename(qsm_folder)
			with open(output_file_L_SLF, 'a') as f:
				print >> f, subject
				# print >> f, tract
        		# print >> f, qsm_folder
			cmd = ("fslstats " + qsm_folder + "/*FA.nii -k " + tract + " -M >> " + output_file_L_SLF + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*MD.nii -k " + tract + " -M >> " + output_file_L_SLF + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*RD.nii -k " + tract + " -M >> " + output_file_L_SLF + " 2>&1")
			os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_SLF + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_iLSQR_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_SLF + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/MEDI2000_LBV_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_SLF + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/TFI_lbv_v2d_lambda2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_SLF + " 2>&1")
			# os.system(cmd)


		if re.match(".*R_*SLF.*\.nii", name):
			tract = os.path.abspath(os.path.join(root, name))
			qsm_folder = os.path.abspath(os.path.join(root, ".."))
			subject = os.path.basename(qsm_folder)
			with open(output_file_R_SLF, 'a') as f:
				print >> f, subject
				# print >> f, tract
        		# print >> f, qsm_folder
			cmd = ("fslstats " + qsm_folder + "/*FA.nii -k " + tract + " -M >> " + output_file_R_SLF + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*MD.nii -k " + tract + " -M >> " + output_file_R_SLF + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*RD.nii -k " + tract + " -M >> " + output_file_R_SLF + " 2>&1")
			os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_SLF + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_iLSQR_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_SLF + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/MEDI2000_LBV_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_SLF + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/TFI_lbv_v2d_lambda2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_SLF + " 2>&1")
			# os.system(cmd)


		if re.match(".*L_*Uncinate.*\.nii", name):
			tract = os.path.abspath(os.path.join(root, name))
			qsm_folder = os.path.abspath(os.path.join(root, ".."))
			subject = os.path.basename(qsm_folder)
			with open(output_file_L_Uncinate, 'a') as f:
				print >> f, subject
				# print >> f, tract
        		# print >> f, qsm_folder
			cmd = ("fslstats " + qsm_folder + "/*FA.nii -k " + tract + " -M >> " + output_file_L_Uncinate + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*MD.nii -k " + tract + " -M >> " + output_file_L_Uncinate + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*RD.nii -k " + tract + " -M >> " + output_file_L_Uncinate + " 2>&1")
			os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_Uncinate + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_iLSQR_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_Uncinate + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/MEDI2000_LBV_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_Uncinate + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/TFI_lbv_v2d_lambda2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_L_Uncinate + " 2>&1")
			# os.system(cmd)


		if re.match(".*R_*Uncinate.*\.nii", name):
			tract = os.path.abspath(os.path.join(root, name))
			qsm_folder = os.path.abspath(os.path.join(root, ".."))
			subject = os.path.basename(qsm_folder)
			with open(output_file_R_Uncinate, 'a') as f:
				print >> f, subject
				# print >> f, tract
        		# print >> f, qsm_folder
			cmd = ("fslstats " + qsm_folder + "/*FA.nii -k " + tract + " -M >> " + output_file_R_Uncinate + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*MD.nii -k " + tract + " -M >> " + output_file_R_Uncinate + " 2>&1")
			os.system(cmd)
			cmd = ("fslstats " + qsm_folder + "/*RD.nii -k " + tract + " -M >> " + output_file_R_Uncinate + " 2>&1")
			os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_Uncinate + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/chi_iLSQR_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_Uncinate + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/MEDI2000_LBV_peel1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_Uncinate + " 2>&1")
			# os.system(cmd)
			# cmd = ("fslstats " + qsm_folder + "/TFI_lbv_v2d_lambda2000_peel_1_RAS_ants_to_B0.nii -k " + tract + " -M >> " + output_file_R_Uncinate + " 2>&1")
			# os.system(cmd)

