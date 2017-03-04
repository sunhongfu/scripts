function HS_SWI(dir_in, dir_out)
% for 2d and 3dswi, only reconstruction is different, others are the same

if ~exist('dir_in','var')
	dir_in = pwd;
end
if ~exist('dir_out','var')
	dir_out = pwd;
end

par = readprocpar(dir_in);
k = readfid(dir_in, par);

if strcmp(par.seqfil, 'swi2d')
    img = HS_SWI2dRec(k, par);
elseif strcmp(par.seqfil, 'swi3d')
    img = HS_SWI3dRec(k, par);
    par.pss = -par.lpe2/2-par.lpe2/par.nv2/2:par.lpe2/par.nv2:par.lpe2/2;
    par.pss = par.pss + par.ppe2;
else
    error('can only handle swi2d and swi3d seqences');
end

clear k;
[mag, phase, swi, phase_unwrap] = HS_SWIProc(img, par);

%% save the original variables
save('all_variables', 'img', 'mag', 'phase', 'swi', 'phase_unwrap', 'par');

%% to resize the images
disp('Resizing images');
NPres = par.lro/(par.np/2);
NVres = par.lpe/par.nv;
NP = par.lro/min(NPres,NVres);
NV = par.lpe/min(NPres,NVres);
mag = imresize(mag, [NP NV], 'nearest');
phase = imresize(phase, [NP NV], 'nearest');
swi = imresize(swi, [NP NV], 'nearest');
phase_unwrap = imresize(phase_unwrap, [NP NV], 'nearest');


% output nifiti images
nii = make_nii(mag);
save_nii(nii,[dir_out '/mag_' par.seqfil(4:5)]);
nii = make_nii(phase);
save_nii(nii,[dir_out '/phaseHighpass_' par.seqfil(4:5)]);
nii = make_nii(swi);
save_nii(nii,[dir_out '/swi_' par.seqfil(4:5)]);
nii = make_nii(phase_unwrap);
save_nii(nii,[dir_out '/phase_unwrap_' par.seqfil(4:5)]);

% %% generate DICOMs
% display('Generating DICOMs');
% foldername = [dir_out '/mag_' par.seqfil];
% mkdir(foldername);
% HS_writeDicom(mag, foldername, par);
% 
% foldername = [dir_out '/phase_' par.seqfil];
% mkdir(foldername);
% HS_writeDicom(phase*10000, foldername, par, [0 1], 2);
% 
% foldername = [dir_out '/swi_' par.seqfil];
% mkdir(foldername);
% HS_writeDicom(swi, foldername, par);



