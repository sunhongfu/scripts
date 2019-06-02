# merge 'preschool_clean_qsm' and all the measurements (e.g. CC_Body.csv)

import os
import glob
import pandas as pd
import numpy as np

df_sub = pd.read_csv(
    '/Users/hongfusun/Dropbox/research/papers/preschool/2019/sub.csv', skipinitialspace=True)
df_sub.set_index('Study Code', inplace=True)
df_sub.dropna(axis=0, how='all', inplace=True)

# read in all the measurement csv files
meas_list = glob.glob(
    '/Users/hongfusun/Dropbox/research/papers/preschool/2019/CSV_new/*.csv')
for meas_file in meas_list:
    print(meas_file)
    df_meas = pd.read_csv(meas_file, skipinitialspace=True)
    df_meas.set_index('Study Code', inplace=True)
    df_meas.dropna(axis=0, how='all', inplace=True)
    # change column names by adding tract name
    filename = os.path.splitext(os.path.basename(meas_file))[0]
    df_meas.columns = [filename + '_tract_name',
                       filename + '_FA',
                       filename + '_MD',
                       filename + '_RD',
                       filename + '_chi_ero0_tik_1e-3_tv_1e-4_2000_peel_1_RAS_ants_to_B0',
                       filename + '_chi_iLSQR_peel1_RAS_ants_to_B0',
                       filename + '_MEDI2000_LBV_peel1_RAS_ants_to_B0',
                       filename + '_TFI_lbv_v2d_lambda2000_peel_1_RAS_ants_to_B0']
    print(df_sub.index.is_unique)
    print(df_meas.index.is_unique)
    print(df_sub[df_sub.index.duplicated()])
    print(df_meas[df_meas.index.duplicated()])

    df_sub = df_sub.merge(df_meas, how='outer',
                          left_index=True, right_index=True, validate="1:1")

df_sub.to_csv(
    '/Users/hongfusun/Dropbox/research/papers/preschool/2019/sub_all_meas.csv')
