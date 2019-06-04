# delete all the wrong tracts from file wrong_tracts_size.csv
import pandas as pd
import os

df = pd.read_csv('wrong_tracts_size.csv', skipinitialspace=True, header=None, names=['Study Code', 'tract'])

for fileName in df['tract']:
    try:
        os.remove(fileName)
    except OSError:
        print("Error while deleting file " + fileName)