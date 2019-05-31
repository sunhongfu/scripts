
import os
import pandas as pd
import numpy as np
import glob

# clean up the tracts meas from the raw txt files and export to csv
# remove
txt_list = glob.glob("/QRISdata/Q1041/preschool/project_preschool/*.txt")
for txt_file in txt_list:
    df = pd.read_csv(txt_file, skipinitialspace=True, delimiter='\t')
    df.set_index('subject', inplace=True)
    df.index.rename('Study Code', inplace=True)
    df.dropna(axis=0, how='all', inplace=True)  # drop all rows with all NAN

    print(txt_file)
    # check the duplicate indexes
    print(df[df.index.duplicated()].size)

    # check indexes with 'Mask and image'
    print(df[df['FA'].str.match('Mask and image')].size)

    # print(df[df['FA'].str.match('Mask and image')]['tract name'])
    df[df['FA'].str.match('Mask and image')]['tract name'].to_csv(
        'wrong_tracts_size.csv', mode='a', header=False)
    # remove indexes with 'Mask and image'
    df = df.loc[~df['FA'].str.match('Mask and image')]

    filename, file_extension = os.path.splitext(txt_file)

    df.to_csv(filename + '.csv')
