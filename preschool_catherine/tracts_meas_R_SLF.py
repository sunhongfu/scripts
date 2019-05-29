import os
import re
import sys
import glob

merge_folder = "/home/hongfu/mnt/deepmri/preschool/project_preschool/merge"

output_file_R_SLF = "/home/hongfu/mnt/deepmri/preschool/project_preschool/R_SLF.txt"

title_row = 'subject' + '\t' + 'tract name' + '\t' + 'FA' + '\t' + 'MD' + '\t' + 'RD' + '\t' + 'chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS_ants_to_B0' + \
    '\t' + 'chi_iLSQR_peel1_RAS_ants_to_B0' + '\t' + 'MEDI2000_LBV_peel1_RAS_ants_to_B0' + \
    '\t' + 'TFI_lbv_v2d_lambda2000_peel_1_RAS_ants_to_B0'
with open(output_file_R_SLF, 'a') as f:
    print(title_row, file=f)

# measure different tracts if exists
for root, dirs, files in os.walk(merge_folder):
    for name in files:
        if re.match(r".*r.?slf.*\.nii", name, re.IGNORECASE):
            tract = os.path.abspath(os.path.join(root, name))
            qsm_folder = os.path.abspath(os.path.join(root, ".."))
            subject = os.path.basename(qsm_folder)
            with open(output_file_R_SLF, 'a') as f:
                print(subject, file=f, end='\t')
                print(tract, file=f, end='\t')
            cmd = ("fslstats " + qsm_folder + "/*FA.nii -k " +
                   tract + " -M >> " + output_file_R_SLF + " 2>&1")
            os.system(cmd)
            with open(output_file_R_SLF, 'a') as f:
                f.truncate(f.tell()-2)  # to remove the newline and space
                f.write('\t')
            cmd = ("fslstats " + qsm_folder + "/*MD.nii -k " +
                   tract + " -M >> " + output_file_R_SLF + " 2>&1")
            os.system(cmd)
            with open(output_file_R_SLF, 'a') as f:
                f.truncate(f.tell()-2)
                f.write('\t')
            cmd = ("fslstats " + qsm_folder + "/*RD.nii -k " +
                   tract + " -M >> " + output_file_R_SLF + " 2>&1")
            os.system(cmd)
            with open(output_file_R_SLF, 'a') as f:
                f.truncate(f.tell()-2)
                f.write('\t')
            cmd = ("fslstats " + qsm_folder + "/chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS_ants_to_B0.nii -k " +
                   tract + " -M >> " + output_file_R_SLF + " 2>&1")
            os.system(cmd)
            with open(output_file_R_SLF, 'a') as f:
                f.truncate(f.tell()-2)
                f.write('\t')
            cmd = ("fslstats " + qsm_folder + "/chi_iLSQR_peel1_RAS_ants_to_B0.nii -k " +
                   tract + " -M >> " + output_file_R_SLF + " 2>&1")
            os.system(cmd)
            with open(output_file_R_SLF, 'a') as f:
                f.truncate(f.tell()-2)
                f.write('\t')
            cmd = ("fslstats " + qsm_folder + "/MEDI2000_LBV_peel1_RAS_ants_to_B0.nii -k " +
                   tract + " -M >> " + output_file_R_SLF + " 2>&1")
            os.system(cmd)
            with open(output_file_R_SLF, 'a') as f:
                f.truncate(f.tell()-2)
                f.write('\t')
            cmd = ("fslstats " + qsm_folder + "/TFI_lbv_v2d_lambda2000_peel_1_RAS_ants_to_B0.nii -k " +
                   tract + " -M >> " + output_file_R_SLF + " 2>&1")
            os.system(cmd)