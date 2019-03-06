import os
import shutil
import glob
import re


qsm_path = "/media/data/project_preschool/recon"
# DTI path includes b0, MD, vec1
dti_path = "/media/pikelab/Hongfu/project_preschool/native_b0_vec1"
fa_path = "/media/data/project_preschool/DTI_Tract_Data/FA_Map"
md_path = "/media/data/project_preschool/DTI_Tract_Data/MD"
tracts_path = "/media/pikelab/Hongfu/project_preschool/tracts"

merge_folder = "/media/pikelab/Hongfu/project_preschool/merge"

# put mag1, QSM, b0, FA, MD, RD, vector, tracts together

# create a list of QSM subjects
qsm_list = ["PS13_004", "PS14_001", "PS14_003", "PS14_005", "PS14_006", "PS14_009", "PS14_014", "PS14_017", "PS14_018", "PS14_021", "PS14_028", "PS14_020", "PS14_022", "PS14_046", "PS14_041", "PS14_039", "PS14_019", "PS14_051", "PS14_047", "PS14_015", "PS14_045", "PS14_050", "PS14_043", "PS14_042", "PS14_026", "PS14_053", "PS14_060", "PS14_057", "PS14_036", "PS14_070", "PS14_056", "PS14_066", "PS14_068", "PS14_065", "PS14_058", "PS14_072", "PS14_086", "PS14_091", "PS14_090", "PS14_092", "PS14_104", "PS14_102", "PS14_083", "PS14_105", "PS14_118", "PS14_097", "PS14_132", "PS14_138", "PS14_101", "PS14_103", "PS14_074", "PS14_073", "PS14_122", "PS14_075", "PS14_111", "PS14_137", "PS14_131", "PS14_144", "PS14_115", "PS14_079", "PS14_081", "PS14_094", "PS14_080", "PS14_139", "PS14_123", "PS14_110", "PS14_145", "PS14_071", "PS14_143", "PS14_117", "PS14_099", "PS14_120", "PS14_135", "PS15_021", "PS14_140", "PS15_020", "PS15_003", "PS15_004", "PS15_014", "PS15_033", "PS15_017", "PS15_002", "PS14_113", "PS15_001", "PS15_011", "PS15_009", "PS15_022", "PS14_136", "PS15_012", "PS15_036", "PS15_029", "PS15_025", "PS15_023", "PS15_038", "PS14_106", "PS15_044", "PS15_046", "PS15_041", "PS15_039", "PS15_037", "PS15_052", "PS15_057", "PS15_053", "PS15_051", "PS15_032", "PS15_031", "PS15_071", "PS15_049", "CL_DEV_001", "PS15_045", "PS15_047", "PS15_048", "PS15_055", "PS15_016", "PS15_068", "PS15_085", "CL_DEV_002", "PS15_060", "PS15_056", "PS15_061", "PS15_062", "PS15_063", "PS15_078", "PS15_042", "PS15_040", "PS15_094", "PS15_084", "PS15_059", "PS15_081", "PS15_086", "PS15_103", "PS15_099", "PS15_102", "PS15_093", "PS15_090", "PS15_095", "PS15_082", "PS15_079", "PS15_077", "CL_DEV_004", "PS15_087", "PS15_092", "PS15_123", "PS15_089", "PS15_109", "PS15_096", "PS15_124", "PS15_098", "PS15_097", "PS15_119", "PS15_107", "PS15_104", "PS15_105", "PS15_108", "PS15_106", "PS15_121", "PS15_110", "PS15_131", "PS15_116", "PS15_120", "PS15_127", "PS15_114", "PS15_112", "PS15_128", "PS15_115", "PS15_138", "PS15_139", "PS15_140", "PS15_126", "CL_DEV_007", "PS15_118", "PS15_146", "PS15_129", "PS15_147", "PS15_136", "PS15_125", "PS15_113", "PS15_144", "PS16_001", "PS16_012", "PS16_009", "PS16_004", "PS16_006", "PS16_010", "PS16_011", "CL_DEV_008", "PS16_019", "PS16_005", "PS16_023", "PS16_013", "PS16_008", "PS16_024", "PS16_020", "PS16_014", "PS16_021", "PS16_003", "PS1064101", "PS16_022", "PS16_025", "PS16_018", "PS0969101", "PS1120101", "PS0935101", "PS16_041", "PS16_016", "PS16_039", "PS1168101", "PS16_038", "PS16_044", "CL_DEV_010", "CL_DEV_009", "PS16_040", "PS1119101", "PS16_026", "PS16_034", "PS16_037", "PS16_053", "PS16_032", "PS16_036", "PS16_059", "PS16_030", "PS16_028", "PS16_054", "PS16_057", "PS16_048", "PS16_060", "PS16_047", "PS16_043", "PS16_063", "PS16_031", "PS1183101", "PS16_045", "PS16_046", "PS16_058", "PS16_070", "PS16_050", "PS16_055", "PS16_051", "PS16_072", "PS16_069", "PS0536101", "PS16_067", "PS16_074", "PS0548101", "PS16_066", "PS1361101", "PS1184101", "PS0626101", "PS16_049", "PS16_078", "CL_DEV_012", "CL_DEV_011", "PS16_082", "PS16_085", "PS16_079", "PS1313101", "PS16_077", "PS1477101", "PS0322102", "PS16_086", "PS16_083", "PS16_084", "PS16_076", "PS16_087"]

for qsm_subject in qsm_list:
	# for root, dirs, files in os.walk(qsm_path):
	# 	for name in dirs:
	# 		if name == qsm_subject:
	# 			qsm_subject_path = os.path.abspath(os.path.join(root, name))
	# 			# copy QSM files to a folder
	# 			if not os.path.exists(merge_folder + "/" + qsm_subject):
	# 				os.makedirs(merge_folder + "/" + qsm_subject)
	# 			# get the QSM folder name pi/halfPi etc.
	# 			qsm_folder_name = glob.glob(qsm_subject_path + "/QSM_SPGR_GE*")
	# 			# print qsm_folder_name
	# 			shutil.copy(qsm_folder_name[0] + "/mag1_RAS_masked_n4.nii", merge_folder + "/" + qsm_subject)
	# 			shutil.copy(qsm_folder_name[0] + "/LBV/chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS.nii", merge_folder + "/" + qsm_subject)
	# 			shutil.copy(qsm_folder_name[0] + "/LBV/chi_iLSQR_peel1_RAS.nii", merge_folder + "/" + qsm_subject)
	# 			shutil.copy(qsm_folder_name[0] + "/LBV/MEDI2000_LBV_peel1_RAS.nii", merge_folder + "/" + qsm_subject)
	# 			shutil.copy(qsm_folder_name[0] + "/LBV/TFI_lbv_v2d_lambda2000_peel_1_RAS.nii", merge_folder + "/" + qsm_subject)
	# ########################################
	# match_flag = False
	# for root, dirs, files in os.walk(dti_path):
	# 	for name in files:
	# 		if re.match(qsm_subject + "_(\S+)\.nii", name):
	# 			dti_file = os.path.abspath(os.path.join(root, name))
	# 			shutil.copy(dti_file, merge_folder + "/" + qsm_subject)
	# 			match_flag = True
	# if match_flag == False:
	# 	print "NO_b0_" + qsm_subject

	# ########################################
	# match_flag = False
	# for root, dirs, files in os.walk(fa_path):
	# 	for name in files:
	# 		if re.match(qsm_subject + "_(\S+)\.nii", name):
	# 			fa_file = os.path.abspath(os.path.join(root, name))
	# 			shutil.copy(fa_file, merge_folder + "/" + qsm_subject)
	# 			match_flag = True
	# if match_flag == False:
	# 	print "NO_FA_" + qsm_subject
			
	# ########################################
	# match_flag = False
	# for root, dirs, files in os.walk(md_path):
	# 	for name in files:
	# 		if re.match(qsm_subject + "_(\S+)\.nii", name):
	# 			md_file = os.path.abspath(os.path.join(root, name))
	# 			shutil.copy(md_file, merge_folder + "/" + qsm_subject)
	# 			match_flag = True
	# if match_flag == False:
	# 	print "NO_MD_" + qsm_subject

	########################################
	match_flag = False
	for root, dirs, files in os.walk(tracts_path):
		for name in files:
			if re.match(qsm_subject + "_(\S+)\.nii", name):
				md_file = os.path.abspath(os.path.join(root, name))
				if not os.path.exists(merge_folder + "/" + qsm_subject + "/tracts"):
					os.makedirs(merge_folder + "/" + qsm_subject + "/tracts")
				shutil.copy(md_file, merge_folder + "/" + qsm_subject + "/tracts/")
				match_flag = True
	if match_flag == False:
		print "NO_tracts_" + qsm_subject


