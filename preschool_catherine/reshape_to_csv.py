# read in meas_text file and reshape into PANDAS framework

import pandas as pd

All_subjects = ['PS13_004', 'PS14_001', 'PS14_003', 'PS14_005', 'PS14_006', 'PS14_009', 'PS14_014', 'PS14_017', 'PS14_018', 'PS14_021', 'PS14_028', 'PS14_020', 'PS14_022', 'PS14_046', 'PS14_041', 'PS14_039', 'PS14_019', 'PS14_051', 'PS14_047', 'PS14_015', 'PS14_045', 'PS14_050', 'PS14_043', 'PS14_042', 'PS14_026', 'PS14_053', 'PS14_060', 'PS14_057', 'PS14_036', 'PS14_070', 'PS14_056', 'PS14_066', 'PS14_068', 'PS14_065', 'PS14_058', 'PS14_072', 'PS14_086', 'PS14_091', 'PS14_090', 'PS14_092', 'PS14_104', 'PS14_102', 'PS14_083', 'PS14_105', 'PS14_118', 'PS14_097', 'PS14_132', 'PS14_138', 'PS14_101', 'PS14_103', 'PS14_074', 'PS14_073', 'PS14_122', 'PS14_075', 'PS14_111', 'PS14_137', 'PS14_131', 'PS14_144', 'PS14_115', 'PS14_079', 'PS14_081', 'PS14_094', 'PS14_080', 'PS14_139', 'PS14_123', 'PS14_110', 'PS14_145', 'PS14_071', 'PS14_143', 'PS14_117', 'PS14_099', 'PS14_120', 'PS14_135', 'PS15_021', 'PS14_140', 'PS15_020', 'PS15_003', 'PS15_004', 'PS15_014', 'PS15_033', 'PS15_017', 'PS15_002', 'PS14_113', 'PS15_001', 'PS15_011', 'PS15_009', 'PS15_022', 'PS14_136', 'PS15_012', 'PS15_036', 'PS15_029', 'PS15_025', 'PS15_023', 'PS15_038', 'PS14_106', 'PS15_044', 'PS15_046', 'PS15_041', 'PS15_039', 'PS15_037', 'PS15_052', 'PS15_057', 'PS15_053', 'PS15_051', 'PS15_032', 'PS15_031', 'PS15_071', 'PS15_049', 'CL_DEV_001', 'PS15_045', 'PS15_047', 'PS15_048', 'PS15_055', 'PS15_016', 'PS15_068', 'PS15_085', 'CL_DEV_002', 'PS15_060', 'PS15_056', 'PS15_061', 'PS15_062', 'PS15_063', 'PS15_078', 'PS15_042', 'PS15_040', 'PS15_094', 'PS15_084', 'PS15_059', 'PS15_081', 'PS15_086', 'PS15_103', 'PS15_099', 'PS15_102', 'PS15_093', 'PS15_090', 'PS15_095', 'PS15_082', 'PS15_079', 'PS15_077', 'CL_DEV_004', 'PS15_087', 'PS15_092', 'PS15_123', 'PS15_089', 'PS15_109', 'PS15_096', 'PS15_124', 'PS15_098', 'PS15_097', 'PS15_119', 'PS15_107', 'PS15_104', 'PS15_105', 'PS15_108', 'PS15_106', 'PS15_121', 'PS15_110', 'PS15_131', 'PS15_116', 'PS15_120', 'PS15_127', 'PS15_114', 'PS15_112', 'PS15_128', 'PS15_115', 'PS15_138', 'PS15_139', 'PS15_140', 'PS15_126', 'CL_DEV_007', 'PS15_118', 'PS15_146', 'PS15_129', 'PS15_147', 'PS15_136', 'PS15_125', 'PS15_113', 'PS15_144', 'PS16_001', 'PS16_012', 'PS16_009', 'PS16_004', 'PS16_006', 'PS16_010', 'PS16_011', 'CL_DEV_008', 'PS16_019', 'PS16_005', 'PS16_023', 'PS16_013', 'PS16_008', 'PS16_024', 'PS16_020', 'PS16_014', 'PS16_021', 'PS16_003', 'PS1064101', 'PS16_022', 'PS16_025', 'PS16_018', 'PS0969101', 'PS1120101', 'PS0935101', 'PS16_041', 'PS16_016', 'PS16_039', 'PS1168101', 'PS16_038', 'PS16_044', 'CL_DEV_010', 'CL_DEV_009', 'PS16_040', 'PS1119101', 'PS16_026', 'PS16_034', 'PS16_037', 'PS16_053', 'PS16_032', 'PS16_036', 'PS16_059', 'PS16_030', 'PS16_028', 'PS16_054', 'PS16_057', 'PS16_048', 'PS16_060', 'PS16_047', 'PS16_043', 'PS16_063', 'PS16_031', 'PS1183101', 'PS16_045', 'PS16_046', 'PS16_058', 'PS16_070', 'PS16_050', 'PS16_055', 'PS16_051', 'PS16_072', 'PS16_069', 'PS0536101', 'PS16_067', 'PS16_074', 'PS0548101', 'PS16_066', 'PS1361101', 'PS1184101', 'PS0626101', 'PS16_049', 'PS16_078', 'CL_DEV_012', 'CL_DEV_011', 'PS16_082', 'PS16_085', 'PS16_079', 'PS1313101', 'PS16_077', 'PS1477101', 'PS0322102', 'PS16_086', 'PS16_083', 'PS16_084', 'PS16_076', 'PS16_087']
df_all_subjects = pd.DataFrame({'Subject':All_subjects})

tracts_list = ['CC_Body', 'CC_Genu', 'CC_Splenium', 'Fornix', 'L_Cingulum', 'R_Cingulum', 'L_IFO', 'R_IFO', 'L_ILF', 'R_ILF', 'L_Pyramidal', 'R_Pyramidal', 'L_SLF', 'R_SLF', 'L_Uncinate', 'R_Uncinate']

for tract in tracts_list:
	with open(tract + '.txt') as f:
		meas = f.readlines()
	counter = 0
	subject = []
	FA = []
	MD = []
	RD = []
	for line_text in meas:
	    counter = counter + 1
	    if counter%4 == 1:
	        subject.append(line_text.rstrip())
	    if counter%4 == 2:
	        FA.append(line_text.rstrip())
	    if counter%4 == 3:
	        MD.append(line_text.rstrip())
	    if counter%4 == 0:
	        RD.append(line_text.rstrip())
	df_meas = pd.DataFrame({'Subject':subject, 'FA':FA, 'MD':MD, 'RD':RD})
	df_meas_results = pd.merge(df_all_subjects, df_meas, 'left', on = ['Subject'])
	df_meas_results.to_csv(tract + '.csv', index=False)




# with open("CC_Body.txt") as f:
#     CC_Body = f.readlines()
# with open("CC_Genu.txt") as f:
#     CC_Genu = f.readlines()
# with open("CC_Splenium.txt") as f:
#     CC_Splenium = f.readlines()
# with open("Fornix.txt") as f:
#     Fornix = f.readlines()
# with open("L_Cingulum.txt") as f:
#     L_Cingulum = f.readlines()
# with open("R_Cingulum.txt") as f:
#     R_Cingulum = f.readlines()
# with open("L_IFO.txt") as f:
#     L_IFO = f.readlines()
# with open("R_IFO.txt") as f:
#     R_IFO = f.readlines()
# with open("L_ILF.txt") as f:
#     L_ILF = f.readlines()
# with open("R_ILF.txt") as f:
#     R_ILF = f.readlines()
# with open("L_Pyramidal.txt") as f:
#     L_Pyramidal = f.readlines()
# with open("R_Pyramidal.txt") as f:
#     R_Pyramidal = f.readlines()
# with open("L_SLF.txt") as f:
#     L_SLF = f.readlines()
# with open("R_SLF.txt") as f:
#     R_SLF = f.readlines()
# with open("L_Uncinate.txt") as f:
#     L_Uncinate = f.readlines()
# with open("R_Uncinate.txt") as f:
#     R_Uncinate = f.readlines()


# # CC_Body
# counter = 0
# subject = []
# FA = []
# MD = []
# RD = []
# for text in CC_Body:
#     counter = counter + 1
#     if counter%4 == 1:
#         subject.append(text.rstrip())
#     if counter%4 == 2:
#         FA.append(text.rstrip())
#     if counter%4 == 3:
#         MD.append(text.rstrip())
#     if counter%4 == 0:
#         RD.append(text.rstrip())

# df_CC_Body = pd.DataFrame({'Subject':subject, 'FA':FA, 'MD':MD, 'RD':RD})
# df_all_subjects = pd.DataFrame({'Subject':All_subjects})
# df_CC_Body_results = pd.merge(df_all_subjects, df_CC_Body, 'left', on = ['Subject'])


# # CC_Genu
# counter = 0
# subject = []
# FA = []
# MD = []
# RD = []
# for text in CC_Genu:
#     counter = counter + 1
#     if counter%4 == 1:
#         subject.append(text.rstrip())
#     if counter%4 == 2:
#         FA.append(text.rstrip())
#     if counter%4 == 3:
#         MD.append(text.rstrip())
#     if counter%4 == 0:
#         RD.append(text.rstrip())

# df_CC_Genu = pd.DataFrame({'Subject':subject, 'FA':FA, 'MD':MD, 'RD':RD})
# df_all_subjects = pd.DataFrame({'Subject':All_subjects})
# df_CC_Genu_results = pd.merge(df_all_subjects, df_CC_Genu, 'left', on = ['Subject'])


# # CC_Splenium
# counter = 0
# subject = []
# FA = []
# MD = []
# RD = []
# for text in CC_Splenium:
#     counter = counter + 1
#     if counter%4 == 1:
#         subject.append(text.rstrip())
#     if counter%4 == 2:
#         FA.append(text.rstrip())
#     if counter%4 == 3:
#         MD.append(text.rstrip())
#     if counter%4 == 0:
#         RD.append(text.rstrip())

# df_CC_Splenium = pd.DataFrame({'Subject':subject, 'FA':FA, 'MD':MD, 'RD':RD})
# df_all_subjects = pd.DataFrame({'Subject':All_subjects})
# df_CC_Splenium_results = pd.merge(df_all_subjects, df_CC_Splenium, 'left', on = ['Subject'])


# # Fornix
# counter = 0
# subject = []
# FA = []
# MD = []
# RD = []
# for text in Fornix:
#     counter = counter + 1
#     if counter%4 == 1:
#         subject.append(text.rstrip())
#     if counter%4 == 2:
#         FA.append(text.rstrip())
#     if counter%4 == 3:
#         MD.append(text.rstrip())
#     if counter%4 == 0:
#         RD.append(text.rstrip())

# df_Fornix = pd.DataFrame({'Subject':subject, 'FA':FA, 'MD':MD, 'RD':RD})
# df_all_subjects = pd.DataFrame({'Subject':All_subjects})
# df_Fornix_results = pd.merge(df_all_subjects, df_Fornix, 'left', on = ['Subject'])


# # L_Cingulum
# counter = 0
# subject = []
# FA = []
# MD = []
# RD = []
# for text in L_Cingulum:
#     counter = counter + 1
#     if counter%4 == 1:
#         subject.append(text.rstrip())
#     if counter%4 == 2:
#         FA.append(text.rstrip())
#     if counter%4 == 3:
#         MD.append(text.rstrip())
#     if counter%4 == 0:
#         RD.append(text.rstrip())

# df_L_Cingulum = pd.DataFrame({'Subject':subject, 'FA':FA, 'MD':MD, 'RD':RD})
# df_all_subjects = pd.DataFrame({'Subject':All_subjects})
# df_L_Cingulum_results = pd.merge(df_all_subjects, df_L_Cingulum, 'left', on = ['Subject'])


# # R_Cingulum
# counter = 0
# subject = []
# FA = []
# MD = []
# RD = []
# for text in R_Cingulum:
#     counter = counter + 1
#     if counter%4 == 1:
#         subject.append(text.rstrip())
#     if counter%4 == 2:
#         FA.append(text.rstrip())
#     if counter%4 == 3:
#         MD.append(text.rstrip())
#     if counter%4 == 0:
#         RD.append(text.rstrip())

# df_R_Cingulum = pd.DataFrame({'Subject':subject, 'FA':FA, 'MD':MD, 'RD':RD})
# df_all_subjects = pd.DataFrame({'Subject':All_subjects})
# df_R_Cingulum_results = pd.merge(df_all_subjects, df_R_Cingulum, 'left', on = ['Subject'])


# # L_IFO
# counter = 0
# subject = []
# FA = []
# MD = []
# RD = []
# for text in L_IFO:
#     counter = counter + 1
#     if counter%4 == 1:
#         subject.append(text.rstrip())
#     if counter%4 == 2:
#         FA.append(text.rstrip())
#     if counter%4 == 3:
#         MD.append(text.rstrip())
#     if counter%4 == 0:
#         RD.append(text.rstrip())

# df_L_IFO = pd.DataFrame({'Subject':subject, 'FA':FA, 'MD':MD, 'RD':RD})
# df_all_subjects = pd.DataFrame({'Subject':All_subjects})
# df_L_IFO_results = pd.merge(df_all_subjects, df_L_IFO, 'left', on = ['Subject'])


# # R_IFO
# counter = 0
# subject = []
# FA = []
# MD = []
# RD = []
# for text in R_IFO:
#     counter = counter + 1
#     if counter%4 == 1:
#         subject.append(text.rstrip())
#     if counter%4 == 2:
#         FA.append(text.rstrip())
#     if counter%4 == 3:
#         MD.append(text.rstrip())
#     if counter%4 == 0:
#         RD.append(text.rstrip())

# df_R_IFO = pd.DataFrame({'Subject':subject, 'FA':FA, 'MD':MD, 'RD':RD})
# df_all_subjects = pd.DataFrame({'Subject':All_subjects})
# df_R_IFO_results = pd.merge(df_all_subjects, df_R_IFO, 'left', on = ['Subject'])


# # L_ILF
# counter = 0
# subject = []
# FA = []
# MD = []
# RD = []
# for text in L_ILF:
#     counter = counter + 1
#     if counter%4 == 1:
#         subject.append(text.rstrip())
#     if counter%4 == 2:
#         FA.append(text.rstrip())
#     if counter%4 == 3:
#         MD.append(text.rstrip())
#     if counter%4 == 0:
#         RD.append(text.rstrip())

# df_L_ILF = pd.DataFrame({'Subject':subject, 'FA':FA, 'MD':MD, 'RD':RD})
# df_all_subjects = pd.DataFrame({'Subject':All_subjects})
# df_L_ILF_results = pd.merge(df_all_subjects, df_L_ILF, 'left', on = ['Subject'])


# # R_ILF
# counter = 0
# subject = []
# FA = []
# MD = []
# RD = []
# for text in R_ILF:
#     counter = counter + 1
#     if counter%4 == 1:
#         subject.append(text.rstrip())
#     if counter%4 == 2:
#         FA.append(text.rstrip())
#     if counter%4 == 3:
#         MD.append(text.rstrip())
#     if counter%4 == 0:
#         RD.append(text.rstrip())

# df_R_ILF = pd.DataFrame({'Subject':subject, 'FA':FA, 'MD':MD, 'RD':RD})
# df_all_subjects = pd.DataFrame({'Subject':All_subjects})
# df_R_ILF_results = pd.merge(df_all_subjects, df_R_ILF, 'left', on = ['Subject'])


# # L_Pyramidal
# counter = 0
# subject = []
# FA = []
# MD = []
# RD = []
# for text in L_Pyramidal:
#     counter = counter + 1
#     if counter%4 == 1:
#         subject.append(text.rstrip())
#     if counter%4 == 2:
#         FA.append(text.rstrip())
#     if counter%4 == 3:
#         MD.append(text.rstrip())
#     if counter%4 == 0:
#         RD.append(text.rstrip())

# df_L_Pyramidal = pd.DataFrame({'Subject':subject, 'FA':FA, 'MD':MD, 'RD':RD})
# df_all_subjects = pd.DataFrame({'Subject':All_subjects})
# df_L_Pyramidal_results = pd.merge(df_all_subjects, df_L_Pyramidal, 'left', on = ['Subject'])


# # R_Pyramidal
# counter = 0
# subject = []
# FA = []
# MD = []
# RD = []
# for text in R_Pyramidal:
#     counter = counter + 1
#     if counter%4 == 1:
#         subject.append(text.rstrip())
#     if counter%4 == 2:
#         FA.append(text.rstrip())
#     if counter%4 == 3:
#         MD.append(text.rstrip())
#     if counter%4 == 0:
#         RD.append(text.rstrip())

# df_R_Pyramidal = pd.DataFrame({'Subject':subject, 'FA':FA, 'MD':MD, 'RD':RD})
# df_all_subjects = pd.DataFrame({'Subject':All_subjects})
# df_R_Pyramidal_results = pd.merge(df_all_subjects, df_R_Pyramidal, 'left', on = ['Subject'])


# # L_SLF
# counter = 0
# subject = []
# FA = []
# MD = []
# RD = []
# for text in L_SLF:
#     counter = counter + 1
#     if counter%4 == 1:
#         subject.append(text.rstrip())
#     if counter%4 == 2:
#         FA.append(text.rstrip())
#     if counter%4 == 3:
#         MD.append(text.rstrip())
#     if counter%4 == 0:
#         RD.append(text.rstrip())

# df_L_SLF = pd.DataFrame({'Subject':subject, 'FA':FA, 'MD':MD, 'RD':RD})
# df_all_subjects = pd.DataFrame({'Subject':All_subjects})
# df_L_SLF_results = pd.merge(df_all_subjects, df_L_SLF, 'left', on = ['Subject'])


# # R_SLF
# counter = 0
# subject = []
# FA = []
# MD = []
# RD = []
# for text in R_SLF:
#     counter = counter + 1
#     if counter%4 == 1:
#         subject.append(text.rstrip())
#     if counter%4 == 2:
#         FA.append(text.rstrip())
#     if counter%4 == 3:
#         MD.append(text.rstrip())
#     if counter%4 == 0:
#         RD.append(text.rstrip())

# df_R_SLF = pd.DataFrame({'Subject':subject, 'FA':FA, 'MD':MD, 'RD':RD})
# df_all_subjects = pd.DataFrame({'Subject':All_subjects})
# df_R_SLF_results = pd.merge(df_all_subjects, df_R_SLF, 'left', on = ['Subject'])


# # L_Uncinate
# counter = 0
# subject = []
# FA = []
# MD = []
# RD = []
# for text in L_Uncinate:
#     counter = counter + 1
#     if counter%4 == 1:
#         subject.append(text.rstrip())
#     if counter%4 == 2:
#         FA.append(text.rstrip())
#     if counter%4 == 3:
#         MD.append(text.rstrip())
#     if counter%4 == 0:
#         RD.append(text.rstrip())

# df_L_Uncinate = pd.DataFrame({'Subject':subject, 'FA':FA, 'MD':MD, 'RD':RD})
# df_all_subjects = pd.DataFrame({'Subject':All_subjects})
# df_L_Uncinate_results = pd.merge(df_all_subjects, df_L_Uncinate, 'left', on = ['Subject'])


# # R_Uncinate
# counter = 0
# subject = []
# FA = []
# MD = []
# RD = []
# for text in R_Uncinate:
#     counter = counter + 1
#     if counter%4 == 1:
#         subject.append(text.rstrip())
#     if counter%4 == 2:
#         FA.append(text.rstrip())
#     if counter%4 == 3:
#         MD.append(text.rstrip())
#     if counter%4 == 0:
#         RD.append(text.rstrip())

# df_R_Uncinate = pd.DataFrame({'Subject':subject, 'FA':FA, 'MD':MD, 'RD':RD})
# df_all_subjects = pd.DataFrame({'Subject':All_subjects})
# df_R_Uncinate_results = pd.merge(df_all_subjects, df_R_Uncinate, 'left', on = ['Subject'])

