# sub_all_meas_clean: remove rows of subjects without any tracts meas
# read in sub_all_meas.csv
import pandas as pd
import numpy as np

df = pd.read_csv(
    '/Users/hongfusun/Dropbox/research/papers/preschool/2019/sub_all_meas.csv')


# remove the NaN rows of 'all tracts' are empty
df_slice = df.loc[:,
                  'L_SLF_tract_name':'R_Pyramidal_TFI_lbv_v2d_lambda2000_peel_1_RAS_ants_to_B0']
# df_slice.to_csv(
#     '/Users/hongfusun/Dropbox/research/papers/preschool/2019/sub_all_meas_new.csv')

df[~df_slice.isnull().all(axis=1)].to_csv(
    '/Users/hongfusun/Dropbox/research/papers/preschool/2019/sub_all_meas_clean.csv')
