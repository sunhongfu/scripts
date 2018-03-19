
# coding: utf-8

# In[98]:


import os
import pandas as pd
import numpy as np
import pydicom as dcm
from datetime import datetime


# In[99]:


# load in the csv file as a pandas dataframe
df = pd.read_csv('/home/hongfu/Dropbox/research/papers/preschool/preschool_new.csv',skipinitialspace=True)
df1 = pd.read_csv('/home/hongfu/Dropbox/research/papers/preschool/Preschool data inventory2.csv',skipinitialspace=True)

# drop columns with all NaN
df1.dropna(axis=0, how='all', inplace=True)
df1.dropna(axis=1, how='all', inplace=True)
df.dropna(axis=0, how='all', inplace=True)
df.dropna(axis=1, how='all', inplace=True)


# In[100]:


# read in the dicom and output 'StudyDate' and 'StudyTime'
def extractTime(dicom_file):
    dicom_strct = dcm.read_file(dicom_file)
    return dicom_strct.StudyDate, dicom_strct.StudyTime

StudyDateList = []
StudyTimeList = []

for subjects in df['subjects']:
    path = os.path.join('/media/data/project_preschool/PreschoolData_clean/', subjects)
    path = os.path.join(path, os.listdir(path)[0])
    dicom_file = os.path.join(path, os.listdir(path)[0])
    StudyDateList.append(extractTime(dicom_file)[0])
    StudyTimeList.append(extractTime(dicom_file)[1])

df['Study Date'] = StudyDateList
df['Study Time'] = StudyTimeList

# convert to Date and Time format
def formatTime(studyTime):
    return studyTime[0:2] + ':' + studyTime[2:4] + ':' + studyTime[4:6]

df['Study Date'] = pd.to_datetime(df['Study Date'])
df['Study Time'] = map(formatTime,df['Study Time'])

df.set_index('subjects', inplace=True)
df.index.rename('Study Code', inplace=True)

df.to_csv('/home/hongfu/Dropbox/research/papers/preschool/added_time.csv')


# In[101]:


# merge df with df1
df1.set_index('Study Code', inplace=True)
df2 = df1.merge(df, how='outer', left_index=True, right_index=True)

# read DTI dir to a dataFrame
df5 = pd.DataFrame({'Study Code':os.listdir('/media/data/project_preschool/HONG_FU_DATA_DTI')})
df5['DTI'] = 'yes'
df5.set_index('Study Code', inplace=True)
# merge DTI to all
df2 = df2.merge(df5, how='outer', left_index=True, right_index=True)

# change the column orders of df2
df2 = df2[['Subject Number', 'Study Date', 'Study Time', 'QSM', 'DTI', 'T2* Quality?', 'status', 'note', 'Comments']]
df2.rename(columns={'status':'correction'}, inplace=True)

# sorted by subject number and study date
df2 = df2.sort_values(by=['Subject Number', 'Study Date'])

df2.to_csv('/home/hongfu/Dropbox/research/papers/preschool/preschool_all.csv')


# In[102]:


df3 = df2.loc[(df2['QSM'].str.lower()=='yes') & (df2['Study Date'].isnull()) & (df2['DTI'].str.lower()=='yes')]
df3.to_csv('/home/hongfu/Dropbox/research/papers/preschool/preschool_missing_dti.csv')

df6 = df2.loc[(df2['QSM'].str.lower()=='yes') & (df2['Study Date'].isnull())]
df6.to_csv('/home/hongfu/Dropbox/research/papers/preschool/preschool_missing_qsm.csv')


# In[104]:


df4 = df2.loc[(df2['Study Date'].notnull()) & df2['note'].isnull() & (df2['correction'].str.lower()!='motion') & (df2['DTI'].str.lower()=='yes')]
df4.to_csv('/home/hongfu/Dropbox/research/papers/preschool/preschool_clean_dti.csv')

df7 = df2.loc[(df2['Study Date'].notnull()) & df2['note'].isnull() & (df2['correction'].str.lower()!='motion')]
df7.to_csv('/home/hongfu/Dropbox/research/papers/preschool/preschool_clean_qsm.csv')


# In[105]:


# save to pickles
df2.to_pickle('/home/hongfu/Dropbox/research/papers/preschool/preschool_all.pkl')


# In[106]:


# group and describe
df7.groupby(['Subject Number']).count()['Study Date'].value_counts()

