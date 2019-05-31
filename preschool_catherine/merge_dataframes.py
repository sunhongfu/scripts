# merge 'preschool_clean_qsm' and all the measurements (e.g. CC_Body.txt)

import os
import pandas as pd
import numpy as np

df_sub = pd.read_csv('/home/hongfu/Dropbox/research/papers/preschool/2019/sub.csv',skipinitialspace=True)
df_cc_body = pd.read_csv('/home/hongfu/mnt/deepmri/preschool/project_preschool/CC_Body.csv',skipinitialspace=True)
df_sub.set_index('Study Code', inplace=True)
df_cc_body.set_index('Study Code', inplace=True)
df_sub.dropna(axis=0, how='all', inplace=True) # drop all rows with all NAN
df_cc_body.dropna(axis=0, how='all', inplace=True) # drop all rows with all NAN

print(df_sub.index.is_unique)
print(df_cc_body.index.is_unique)
print(df_sub[df_sub.index.duplicated()])
print(df_cc_body[df_cc_body.index.duplicated()])


df_merged = df_sub.merge(df_cc_body, how='outer', left_index=True, right_index=True, validate="1:1")

df_merged.to_csv('/home/hongfu/Dropbox/research/papers/preschool/2019/sub_body.csv')
