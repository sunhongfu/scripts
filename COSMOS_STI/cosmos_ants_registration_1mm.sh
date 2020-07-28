% apply to MEDI and iLSQR
%%%%%%%%%%%%%%%%%
% lower the resolution
nii = load_nii('/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2.nii');
vox = [1 1 1];
oriVox = [0.6, 0.6, 0.6];
ratio = oriVox ./ vox; 
newSize = ceil(size(nii.img) .* ratio);
im2 = imresize3(double(nii.img), newSize);
nii = make_nii(im2,vox);
save_nii(nii,'/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_1mm.nii');
nii = load_nii('/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2.nii');
vox = [1 1 1];
oriVox = [0.6, 0.6, 0.6];
ratio = oriVox ./ vox; 
newSize = ceil(size(nii.img) .* ratio);
im2 = imresize3(double(nii.img), newSize);
nii = make_nii(im2,vox);
save_nii(nii,'/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_1mm.nii');
%%%%%%%%%%%%%%%%%
% lower the resolution
nii = load_nii('/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2.nii');
vox = [1 1 1];
oriVox = [0.6, 0.6, 0.6];
ratio = oriVox ./ vox; 
newSize = ceil(size(nii.img) .* ratio);
im2 = imresize3(double(nii.img), newSize);
nii = make_nii(im2,vox);
save_nii(nii,'/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_1mm.nii');
nii = load_nii('/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2.nii');
vox = [1 1 1];
oriVox = [0.6, 0.6, 0.6];
ratio = oriVox ./ vox; 
newSize = ceil(size(nii.img) .* ratio);
im2 = imresize3(double(nii.img), newSize);
nii = make_nii(im2,vox);
save_nii(nii,'/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_1mm.nii');
%%%%%%%%%%%%%%%%%
% lower the resolution
nii = load_nii('/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2.nii');
vox = [1 1 1];
oriVox = [0.6, 0.6, 0.6];
ratio = oriVox ./ vox; 
newSize = ceil(size(nii.img) .* ratio);
im2 = imresize3(double(nii.img), newSize);
nii = make_nii(im2,vox);
save_nii(nii,'/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_1mm.nii');
nii = load_nii('/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2.nii');
vox = [1 1 1];
oriVox = [0.6, 0.6, 0.6];
ratio = oriVox ./ vox; 
newSize = ceil(size(nii.img) .* ratio);
im2 = imresize3(double(nii.img), newSize);
nii = make_nii(im2,vox);
save_nii(nii,'/Volumes/LaCie/COSMOS_7T/03JK/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_1mm.nii');
%%%%%%%%%%%%%%%%%
% lower the resolution
nii = load_nii('/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2.nii');
vox = [1 1 1];
oriVox = [0.6, 0.6, 0.6];
ratio = oriVox ./ vox; 
newSize = ceil(size(nii.img) .* ratio);
im2 = imresize3(double(nii.img), newSize);
nii = make_nii(im2,vox);
save_nii(nii,'/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_1mm.nii');
nii = load_nii('/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2.nii');
vox = [1 1 1];
oriVox = [0.6, 0.6, 0.6];
ratio = oriVox ./ vox; 
newSize = ceil(size(nii.img) .* ratio);
im2 = imresize3(double(nii.img), newSize);
nii = make_nii(im2,vox);
save_nii(nii,'/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_1mm.nii');
%%%%%%%%%%%%%%%%%
% lower the resolution
nii = load_nii('/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2.nii');
vox = [1 1 1];
oriVox = [0.6, 0.6, 0.6];
ratio = oriVox ./ vox; 
newSize = ceil(size(nii.img) .* ratio);
im2 = imresize3(double(nii.img), newSize);
nii = make_nii(im2,vox);
save_nii(nii,'/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_1mm.nii');
nii = load_nii('/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2.nii');
vox = [1 1 1];
oriVox = [0.6, 0.6, 0.6];
ratio = oriVox ./ vox; 
newSize = ceil(size(nii.img) .* ratio);
im2 = imresize3(double(nii.img), newSize);
nii = make_nii(im2,vox);
save_nii(nii,'/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_1mm.nii');
%%%%%%%%%%%%%%%%%
% lower the resolution
nii = load_nii('/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2.nii');
vox = [1 1 1];
oriVox = [0.6, 0.6, 0.6];
ratio = oriVox ./ vox; 
newSize = ceil(size(nii.img) .* ratio);
im2 = imresize3(double(nii.img), newSize);
nii = make_nii(im2,vox);
save_nii(nii,'/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_1mm.nii');
nii = load_nii('/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2.nii');
vox = [1 1 1];
oriVox = [0.6, 0.6, 0.6];
ratio = oriVox ./ vox; 
newSize = ceil(size(nii.img) .* ratio);
im2 = imresize3(double(nii.img), newSize);
nii = make_nii(im2,vox);
save_nii(nii,'/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_1mm.nii');
%%%%%%%%%%%%%%%%%
% lower the resolution
nii = load_nii('/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2.nii');
vox = [1 1 1];
oriVox = [0.6, 0.6, 0.6];
ratio = oriVox ./ vox; 
newSize = ceil(size(nii.img) .* ratio);
im2 = imresize3(double(nii.img), newSize);
nii = make_nii(im2,vox);
save_nii(nii,'/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_1mm.nii');
nii = load_nii('/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2.nii');
vox = [1 1 1];
oriVox = [0.6, 0.6, 0.6];
ratio = oriVox ./ vox; 
newSize = ceil(size(nii.img) .* ratio);
im2 = imresize3(double(nii.img), newSize);
nii = make_nii(im2,vox);
save_nii(nii,'/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_1mm.nii');
%%%%%%%%%%%%%%%%%




# register all COSMOS to 03JK COSMOS
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=/Volumes/LaCie/COSMOS_7T/01EG/cosmos_5_12DOF_cgs_smvrad2_1mm.nii
ref=/Volumes/LaCie/COSMOS_7T/03JK/cosmos_5_12DOF_cgs_smvrad2_1mm.nii
mkdir /Volumes/LaCie/COSMOS_7T/01EG/ants_brain_1mm_to_03JK
transformPrefix=/Volumes/LaCie/COSMOS_7T/01EG/ants_brain_1mm_to_03JK/ants_to_03JK
warpedImage=/Volumes/LaCie/COSMOS_7T/01EG/ants_brain_1mm_to_03JK/ants_to_03JK.nii.gz

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# apply ANTS registration of all deep learning methods
deepqsm=/Volumes/LaCie/COSMOS_7T/downsample_1mm/DeepQSM_1mm_atlas/DeepQSM_TestInput1401_invivo.nii
deepqsm_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/DeepQSM_1mm_atlas/DeepQSM_TestInput1401_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/01EG/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $deepqsm -r $ref -o $deepqsm_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

qsmnet=/Volumes/LaCie/COSMOS_7T/downsample_1mm/QSMnet+_1mm_atlas_new/QSMnet+_Recon_01EG.nii
qsmnet_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/QSMnet+_1mm_atlas_new/QSMnet+_Recon_01EG_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/01EG/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $qsmnet -r $ref -o $qsmnet_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_1mm_atlas/xQSM_invivo_TestInput1401_invivo.nii
xqsm_invivo_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_1mm_atlas/xQSM_invivo_TestInput1401_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/01EG/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $xqsm_invivo -r $ref -o $xqsm_invivo_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_syn=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_syn_1mm_atlas/xQSM_syn_TestInput1401_invivo.nii
xqsm_syn_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_syn_1mm_atlas/xQSM_syn_TestInput1401_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/01EG/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $xqsm_syn -r $ref -o $xqsm_syn_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo_noisy=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_NoisyTrain_1mm_atlas/xQSM_invivo_NoisyTrain_TestInput1401_invivo.nii
xqsm_invivo_noisy_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_NoisyTrain_1mm_atlas/xQSM_invivo_NoisyTrain_TestInput1401_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/01EG/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $xqsm_invivo_noisy -r $ref -o $xqsm_invivo_noisy_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

iLSQR=/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_1mm.nii
iLSQR_to_03JK=/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_1mm_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/01EG/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $iLSQR -r $ref -o $iLSQR_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

MEDI=/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_1mm.nii
MEDI_to_03JK=/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_1mm_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/01EG/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $MEDI -r $ref -o $MEDI_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 









its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=/Volumes/LaCie/COSMOS_7T/02SCOTT/cosmos_5_12DOF_cgs_smvrad2_1mm.nii
ref=/Volumes/LaCie/COSMOS_7T/03JK/cosmos_5_12DOF_cgs_smvrad2_1mm.nii
mkdir /Volumes/LaCie/COSMOS_7T/02SCOTT/ants_brain_1mm_to_03JK
transformPrefix=/Volumes/LaCie/COSMOS_7T/02SCOTT/ants_brain_1mm_to_03JK/ants_to_03JK
warpedImage=/Volumes/LaCie/COSMOS_7T/02SCOTT/ants_brain_1mm_to_03JK/ants_to_03JK.nii.gz

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# apply ANTS registration of all deep learning methods
deepqsm=/Volumes/LaCie/COSMOS_7T/downsample_1mm/DeepQSM_1mm_atlas/DeepQSM_TestInput1402_invivo.nii
deepqsm_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/DeepQSM_1mm_atlas/DeepQSM_TestInput1402_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/02SCOTT/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $deepqsm -r $ref -o $deepqsm_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

qsmnet=/Volumes/LaCie/COSMOS_7T/downsample_1mm/QSMnet+_1mm_atlas_new/QSMnet+_Recon_02SCOTT.nii
qsmnet_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/QSMnet+_1mm_atlas_new/QSMnet+_Recon_02SCOTT_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/02SCOTT/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $qsmnet -r $ref -o $qsmnet_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_1mm_atlas/xQSM_invivo_TestInput1402_invivo.nii
xqsm_invivo_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_1mm_atlas/xQSM_invivo_TestInput1402_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/02SCOTT/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $xqsm_invivo -r $ref -o $xqsm_invivo_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_syn=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_syn_1mm_atlas/xQSM_syn_TestInput1402_invivo.nii
xqsm_syn_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_syn_1mm_atlas/xQSM_syn_TestInput1402_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/02SCOTT/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $xqsm_syn -r $ref -o $xqsm_syn_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo_noisy=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_NoisyTrain_1mm_atlas/xQSM_invivo_NoisyTrain_TestInput1402_invivo.nii
xqsm_invivo_noisy_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_NoisyTrain_1mm_atlas/xQSM_invivo_NoisyTrain_TestInput1402_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/02SCOTT/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $xqsm_invivo_noisy -r $ref -o $xqsm_invivo_noisy_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

iLSQR=/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_1mm.nii
iLSQR_to_03JK=/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_1mm_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/02SCOTT/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $iLSQR -r $ref -o $iLSQR_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

MEDI=/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_1mm.nii
MEDI_to_03JK=/Volumes/LaCie/COSMOS_7T/02SCOTT/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_1mm_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/02SCOTT/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $MEDI -r $ref -o $MEDI_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 












its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=/Volumes/LaCie/COSMOS_7T/04JG/cosmos_5_12DOF_cgs_smvrad2_1mm.nii
ref=/Volumes/LaCie/COSMOS_7T/03JK/cosmos_5_12DOF_cgs_smvrad2_1mm.nii
mkdir /Volumes/LaCie/COSMOS_7T/04JG/ants_brain_1mm_to_03JK
transformPrefix=/Volumes/LaCie/COSMOS_7T/04JG/ants_brain_1mm_to_03JK/ants_to_03JK
warpedImage=/Volumes/LaCie/COSMOS_7T/04JG/ants_brain_1mm_to_03JK/ants_to_03JK.nii.gz

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# apply ANTS registration of all deep learning methods
deepqsm=/Volumes/LaCie/COSMOS_7T/downsample_1mm/DeepQSM_1mm_atlas/DeepQSM_TestInput1404_invivo.nii
deepqsm_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/DeepQSM_1mm_atlas/DeepQSM_TestInput1404_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/04JG/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $deepqsm -r $ref -o $deepqsm_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

qsmnet=/Volumes/LaCie/COSMOS_7T/downsample_1mm/QSMnet+_1mm_atlas_new/QSMnet+_Recon_04JG.nii
qsmnet_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/QSMnet+_1mm_atlas_new/QSMnet+_Recon_04JG_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/04JG/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $qsmnet -r $ref -o $qsmnet_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_1mm_atlas/xQSM_invivo_TestInput1404_invivo.nii
xqsm_invivo_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_1mm_atlas/xQSM_invivo_TestInput1404_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/04JG/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $xqsm_invivo -r $ref -o $xqsm_invivo_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_syn=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_syn_1mm_atlas/xQSM_syn_TestInput1404_invivo.nii
xqsm_syn_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_syn_1mm_atlas/xQSM_syn_TestInput1404_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/04JG/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $xqsm_syn -r $ref -o $xqsm_syn_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo_noisy=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_NoisyTrain_1mm_atlas/xQSM_invivo_NoisyTrain_TestInput1404_invivo.nii
xqsm_invivo_noisy_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_NoisyTrain_1mm_atlas/xQSM_invivo_NoisyTrain_TestInput1404_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/04JG/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $xqsm_invivo_noisy -r $ref -o $xqsm_invivo_noisy_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

iLSQR=/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_1mm.nii
iLSQR_to_03JK=/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_1mm_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/04JG/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $iLSQR -r $ref -o $iLSQR_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

MEDI=/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_1mm.nii
MEDI_to_03JK=/Volumes/LaCie/COSMOS_7T/04JG/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_1mm_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/04JG/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $MEDI -r $ref -o $MEDI_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 














its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=/Volumes/LaCie/COSMOS_7T/05SG/cosmos_5_12DOF_cgs_smvrad2_1mm.nii
ref=/Volumes/LaCie/COSMOS_7T/03JK/cosmos_5_12DOF_cgs_smvrad2_1mm.nii
mkdir /Volumes/LaCie/COSMOS_7T/05SG/ants_brain_1mm_to_03JK
transformPrefix=/Volumes/LaCie/COSMOS_7T/05SG/ants_brain_1mm_to_03JK/ants_to_03JK
warpedImage=/Volumes/LaCie/COSMOS_7T/05SG/ants_brain_1mm_to_03JK/ants_to_03JK.nii.gz

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# apply ANTS registration of all deep learning methods
deepqsm=/Volumes/LaCie/COSMOS_7T/downsample_1mm/DeepQSM_1mm_atlas/DeepQSM_TestInput1405_invivo.nii
deepqsm_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/DeepQSM_1mm_atlas/DeepQSM_TestInput1405_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/05SG/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $deepqsm -r $ref -o $deepqsm_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

qsmnet=/Volumes/LaCie/COSMOS_7T/downsample_1mm/QSMnet+_1mm_atlas_new/QSMnet+_Recon_05SG.nii
qsmnet_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/QSMnet+_1mm_atlas_new/QSMnet+_Recon_05SG_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/05SG/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $qsmnet -r $ref -o $qsmnet_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_1mm_atlas/xQSM_invivo_TestInput1405_invivo.nii
xqsm_invivo_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_1mm_atlas/xQSM_invivo_TestInput1405_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/05SG/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $xqsm_invivo -r $ref -o $xqsm_invivo_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_syn=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_syn_1mm_atlas/xQSM_syn_TestInput1405_invivo.nii
xqsm_syn_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_syn_1mm_atlas/xQSM_syn_TestInput1405_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/05SG/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $xqsm_syn -r $ref -o $xqsm_syn_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo_noisy=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_NoisyTrain_1mm_atlas/xQSM_invivo_NoisyTrain_TestInput1405_invivo.nii
xqsm_invivo_noisy_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_NoisyTrain_1mm_atlas/xQSM_invivo_NoisyTrain_TestInput1405_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/05SG/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $xqsm_invivo_noisy -r $ref -o $xqsm_invivo_noisy_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

iLSQR=/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_1mm.nii
iLSQR_to_03JK=/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_1mm_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/05SG/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $iLSQR -r $ref -o $iLSQR_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

MEDI=/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_1mm.nii
MEDI_to_03JK=/Volumes/LaCie/COSMOS_7T/05SG/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_1mm_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/05SG/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $MEDI -r $ref -o $MEDI_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 















its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=/Volumes/LaCie/COSMOS_7T/06PS/cosmos_5_12DOF_cgs_smvrad2_1mm.nii
ref=/Volumes/LaCie/COSMOS_7T/03JK/cosmos_5_12DOF_cgs_smvrad2_1mm.nii
mkdir /Volumes/LaCie/COSMOS_7T/06PS/ants_brain_1mm_to_03JK
transformPrefix=/Volumes/LaCie/COSMOS_7T/06PS/ants_brain_1mm_to_03JK/ants_to_03JK
warpedImage=/Volumes/LaCie/COSMOS_7T/06PS/ants_brain_1mm_to_03JK/ants_to_03JK.nii.gz

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# apply ANTS registration of all deep learning methods
deepqsm=/Volumes/LaCie/COSMOS_7T/downsample_1mm/DeepQSM_1mm_atlas/DeepQSM_TestInput1406_invivo.nii
deepqsm_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/DeepQSM_1mm_atlas/DeepQSM_TestInput1406_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/06PS/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $deepqsm -r $ref -o $deepqsm_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

qsmnet=/Volumes/LaCie/COSMOS_7T/downsample_1mm/QSMnet+_1mm_atlas_new/QSMnet+_Recon_06PS.nii
qsmnet_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/QSMnet+_1mm_atlas_new/QSMnet+_Recon_06PS_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/06PS/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $qsmnet -r $ref -o $qsmnet_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_1mm_atlas/xQSM_invivo_TestInput1406_invivo.nii
xqsm_invivo_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_1mm_atlas/xQSM_invivo_TestInput1406_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/06PS/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $xqsm_invivo -r $ref -o $xqsm_invivo_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_syn=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_syn_1mm_atlas/xQSM_syn_TestInput1406_invivo.nii
xqsm_syn_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_syn_1mm_atlas/xQSM_syn_TestInput1406_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/06PS/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $xqsm_syn -r $ref -o $xqsm_syn_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo_noisy=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_NoisyTrain_1mm_atlas/xQSM_invivo_NoisyTrain_TestInput1406_invivo.nii
xqsm_invivo_noisy_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_NoisyTrain_1mm_atlas/xQSM_invivo_NoisyTrain_TestInput1406_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/06PS/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $xqsm_invivo_noisy -r $ref -o $xqsm_invivo_noisy_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

iLSQR=/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_1mm.nii
iLSQR_to_03JK=/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_1mm_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/06PS/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $iLSQR -r $ref -o $iLSQR_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

MEDI=/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_1mm.nii
MEDI_to_03JK=/Volumes/LaCie/COSMOS_7T/06PS/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_1mm_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/06PS/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $MEDI -r $ref -o $MEDI_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 













its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=/Volumes/LaCie/COSMOS_7T/07JON/cosmos_5_12DOF_cgs_smvrad2_1mm.nii
ref=/Volumes/LaCie/COSMOS_7T/03JK/cosmos_5_12DOF_cgs_smvrad2_1mm.nii
mkdir /Volumes/LaCie/COSMOS_7T/07JON/ants_brain_1mm_to_03JK
transformPrefix=/Volumes/LaCie/COSMOS_7T/07JON/ants_brain_1mm_to_03JK/ants_to_03JK
warpedImage=/Volumes/LaCie/COSMOS_7T/07JON/ants_brain_1mm_to_03JK/ants_to_03JK.nii.gz

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# apply ANTS registration of all deep learning methods
deepqsm=/Volumes/LaCie/COSMOS_7T/downsample_1mm/DeepQSM_1mm_atlas/DeepQSM_TestInput1407_invivo.nii
deepqsm_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/DeepQSM_1mm_atlas/DeepQSM_TestInput1407_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/07JON/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $deepqsm -r $ref -o $deepqsm_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

qsmnet=/Volumes/LaCie/COSMOS_7T/downsample_1mm/QSMnet+_1mm_atlas_new/QSMnet+_Recon_07JON.nii
qsmnet_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/QSMnet+_1mm_atlas_new/QSMnet+_Recon_07JON_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/07JON/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $qsmnet -r $ref -o $qsmnet_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_1mm_atlas/xQSM_invivo_TestInput1407_invivo.nii
xqsm_invivo_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_1mm_atlas/xQSM_invivo_TestInput1407_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/07JON/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $xqsm_invivo -r $ref -o $xqsm_invivo_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_syn=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_syn_1mm_atlas/xQSM_syn_TestInput1407_invivo.nii
xqsm_syn_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_syn_1mm_atlas/xQSM_syn_TestInput1407_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/07JON/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $xqsm_syn -r $ref -o $xqsm_syn_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

xqsm_invivo_noisy=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_NoisyTrain_1mm_atlas/xQSM_invivo_NoisyTrain_TestInput1407_invivo.nii
xqsm_invivo_noisy_to_03JK=/Volumes/LaCie/COSMOS_7T/downsample_1mm/xQSM_invivo_NoisyTrain_1mm_atlas/xQSM_invivo_NoisyTrain_TestInput1407_invivo_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/07JON/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $xqsm_invivo_noisy -r $ref -o $xqsm_invivo_noisy_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

iLSQR=/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_1mm.nii
iLSQR_to_03JK=/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_1mm_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/07JON/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $iLSQR -r $ref -o $iLSQR_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

MEDI=/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_1mm.nii
MEDI_to_03JK=/Volumes/LaCie/COSMOS_7T/07JON/neutral/QSM_MEGE_7T/RESHARP/MEDI1000_RESHARP_smvrad2_1mm_to_03JK.nii.gz
transformPrefix=/Volumes/LaCie/COSMOS_7T/07JON/ants_brain_1mm_to_03JK/ants_to_03JK
antsApplyTransforms -d 3 -i $MEDI -r $ref -o $MEDI_to_03JK -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 





