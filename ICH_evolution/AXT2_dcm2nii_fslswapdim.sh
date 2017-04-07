dcm2nii "./TIAMISO_192/MRI_DICOM/2013.10.11-10.54.31/AXT2_Series0005"
dcm2nii "./ICHADAPT_II_013/MRI_DICOM/2013.08.20-10.20.49/AXT2_Series0005"
dcm2nii "./ICHADAPT_II_027/MRI_DICOM/2014.04.24-10.40.29/AXT2_5"
dcm2nii "./TIAMISO_208/MRI_DICOM/2014.09.23-13.44.43/AXT2_6"
dcm2nii "./ICHADAPT_II_048/MRI_DICOM/2015.03.23-13.02.40/AXT2"
dcm2nii "./ICHADAPT_II_048/MRI_DICOM/2015.02.19-11.18.57/AXT2"
dcm2nii "./TIAMISO_193/MRI_DICOM/2013.10.09-11.23.30/13_10_09_1105_Day30 - 1/AXT2_6"
dcm2nii "./ICHADAPT_II_038/MRI_DICOM/2015.02.27-13.15.33/AXT2_6"
dcm2nii "./TIAMISO_201/MRI_DICOM/2014.04.29-12.23.25/AXT2_6"
dcm2nii "./ICHADAPT_II_034/MRI_DICOM/2014.06.06-16.13.21/AXT2"
dcm2nii "./ICHADAPT_II_034/MRI_DICOM/2014.06.02-unknown-longTE/AXT2_4"
dcm2nii "./ICHADAPT_II_034/MRI_DICOM/2014.06.26-12.45.37/AXT2_6"
dcm2nii "./TIAMISO_198/MRI_DICOM/2013.11.18-15.57.02/AXT2_Series0006"
dcm2nii "./TIAMISO_198/MRI_DICOM/2013.11.26-12.16.07/AXT2_Series0004"
dcm2nii "./TIAMISO_212/MRI_DICOM/(no raw) 2015_03_31/AXT2"
dcm2nii "./TIAMISO_199/MRI_DICOM/2014.02.04-15.45.41/AXT2_6"
dcm2nii "./TIAMISO_199/MRI_DICOM/2014.02.10-11.14.05/AXT2_4"
dcm2nii "./TIAMISO_199/MRI_DICOM/2014.03.04-13.48.32/AXT2_6"
dcm2nii "./ICHADAPT_II_011/MRI_DICOM/2013.08.02-12.20.23/AXT2_Series0006"
dcm2nii "./SPOTLIGHT_018002/MRI_DICOM/2014.07.23-14.19.19/AXT2_3"
dcm2nii "./SPOTLIGHT_018002/MRI_DICOM/2013.06.19-11.38.13/AXT2_Series0006"
dcm2nii "./TRASH/Ken_Butcher_Stroke_March2008 - 95813234/AXT2_20"
dcm2nii "./TIAMISO_191/MRI_DICOM/2013.09.09-14.49.54/AXT2_Series0006"
dcm2nii "./ICHADAPT_II_046/MRI_DICOM/2015.01.07-14.37.29/AXT2_7"
dcm2nii "./ICHADAPT_II_046/MRI_DICOM/2015.01.30-11.35.54/AXT2_6"
dcm2nii "./ICHADAPT_II_046/MRI_DICOM/2015.01.02-unknown/AXT2_6"
dcm2nii "./TIAMISO_203/MRI_DICOM/2014.06.06-13.52.12/AXT2_6"
dcm2nii "./TIAMISO_203/MRI_DICOM/2014.05.30-12.59.11/AXT2_4"
dcm2nii "./TIAMISO_200/MRI_DICOM/2014.03.12-09.53.09/AXT2_5"
dcm2nii "./TIAMISO_189/MRI_DICOM/2013.09.09-15.25.35/AXT2_Series0005"
dcm2nii "./TIAMISO_186/MRI_DICOM/2013.07.09-09.50.37/AXT2_Series0005"
dcm2nii "./ICHADAPT_II_016/MRI_DICOM/2013.11.26-11.07.13/AXT2_4"
dcm2nii "./TIAMISO_190/MRI_DICOM/2013.08.20-14.49.01/AXT2_5"
dcm2nii "./TIAMISO_204/MRI_DICOM/2014.06.16-13.58.54/AXT2_7"
dcm2nii "./TIAMISO_204/MRI_DICOM/2014.09.16-12.21.49/AXT2_7"
dcm2nii "./ICHADAPT_II_043/MRI_DICOM/2014.12.05-14.32.37/AXT2_6"


cd "./TIAMISO_192/MRI_DICOM/2013.10.11-10.54.31/AXT2_Series0005"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./ICHADAPT_II_013/MRI_DICOM/2013.08.20-10.20.49/AXT2_Series0005"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./ICHADAPT_II_027/MRI_DICOM/2014.04.24-10.40.29/AXT2_5"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./TIAMISO_208/MRI_DICOM/2014.09.23-13.44.43/AXT2_6"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./ICHADAPT_II_048/MRI_DICOM/2015.03.23-13.02.40/AXT2"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./ICHADAPT_II_048/MRI_DICOM/2015.02.19-11.18.57/AXT2"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./TIAMISO_193/MRI_DICOM/2013.10.09-11.23.30/13_10_09_1105_Day30 - 1/AXT2_6"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./ICHADAPT_II_038/MRI_DICOM/2015.02.27-13.15.33/AXT2_6"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./TIAMISO_201/MRI_DICOM/2014.04.29-12.23.25/AXT2_6"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./ICHADAPT_II_034/MRI_DICOM/2014.06.06-16.13.21/AXT2"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./ICHADAPT_II_034/MRI_DICOM/2014.06.02-unknown-longTE/AXT2_4"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./ICHADAPT_II_034/MRI_DICOM/2014.06.26-12.45.37/AXT2_6"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./TIAMISO_198/MRI_DICOM/2013.11.18-15.57.02/AXT2_Series0006"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./TIAMISO_198/MRI_DICOM/2013.11.26-12.16.07/AXT2_Series0004"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./TIAMISO_212/MRI_DICOM/(no raw) 2015_03_31/AXT2"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./TIAMISO_199/MRI_DICOM/2014.02.04-15.45.41/AXT2_6"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./TIAMISO_199/MRI_DICOM/2014.02.10-11.14.05/AXT2_4"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./TIAMISO_199/MRI_DICOM/2014.03.04-13.48.32/AXT2_6"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./ICHADAPT_II_011/MRI_DICOM/2013.08.02-12.20.23/AXT2_Series0006"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./SPOTLIGHT_018002/MRI_DICOM/2014.07.23-14.19.19/AXT2_3"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./SPOTLIGHT_018002/MRI_DICOM/2013.06.19-11.38.13/AXT2_Series0006"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./TRASH/Ken_Butcher_Stroke_March2008 - 95813234/AXT2_20"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./TIAMISO_191/MRI_DICOM/2013.09.09-14.49.54/AXT2_Series0006"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./ICHADAPT_II_046/MRI_DICOM/2015.01.07-14.37.29/AXT2_7"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./ICHADAPT_II_046/MRI_DICOM/2015.01.30-11.35.54/AXT2_6"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./ICHADAPT_II_046/MRI_DICOM/2015.01.02-unknown/AXT2_6"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./TIAMISO_203/MRI_DICOM/2014.06.06-13.52.12/AXT2_6"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./TIAMISO_203/MRI_DICOM/2014.05.30-12.59.11/AXT2_4"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./TIAMISO_200/MRI_DICOM/2014.03.12-09.53.09/AXT2_5"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./TIAMISO_189/MRI_DICOM/2013.09.09-15.25.35/AXT2_Series0005"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./TIAMISO_186/MRI_DICOM/2013.07.09-09.50.37/AXT2_Series0005"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./ICHADAPT_II_016/MRI_DICOM/2013.11.26-11.07.13/AXT2_4"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./TIAMISO_190/MRI_DICOM/2013.08.20-14.49.01/AXT2_5"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./TIAMISO_204/MRI_DICOM/2014.06.16-13.58.54/AXT2_7"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./TIAMISO_204/MRI_DICOM/2014.09.16-12.21.49/AXT2_7"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
cd "./ICHADAPT_II_043/MRI_DICOM/2014.12.05-14.32.37/AXT2_6"; fslswapdim *AXT2*.nii.gz x -y z AXT2_flipped.nii; cd -;
