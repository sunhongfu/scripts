# merge 'preschool_clean_qsm' and all the measurements (e.g. CC_Body.txt)

import os
import pandas as pd
import numpy as np

df_sub = pd.read_excel('/home/hongfu/Dropbox/research/papers/preschool/2019/preschool_qsm_updated.xlsx',skipinitialspace=True)
df_cc_body = pd.read_csv('/home/hongfu/mnt/deepmri/preschool/project_preschool/CC_Body.txt',skipinitialspace=True,delimiter='\t')
df_sub.set_index('Study Code', inplace=True)
df_cc_body.set_index('subject', inplace=True)

df_merged = df_sub.merge(df_cc_body, how='outer', left_index=True, right_index=True)

df_merged.to_csv('/home/hongfu/Dropbox/research/papers/preschool/2019/sub_body.csv')
