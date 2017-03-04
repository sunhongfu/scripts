function HS_swi(pathin,pathout)

if nargin < 1
	pathin = pwd;
end
if nargin < 2
	pathout = [pathin '/'];
end

%   Read in parameters and data (dc correction and single)
par = readprocpar(pathin);
if strcmp(par.seqfil, 'swi2d')
	[par,img] = swi2drec(pathin);
elseif strcmp(par.seqfil, 'swi3d')
	[par,img] = swi3drec(pathin);
else 
	error('either 2d or 3d swi can be processed');
end

%   Apply phase sensitive recon
if par.nrcvrs > 1
    imgW = arrayrec(coilnorm(img),0.4);
else
    imgW = coilrec(img,0.4);
end
imgW(imgW<0) = 0;

%   Compute SWI image and local field shift
disp('Computing Susceptibility Phase Images');
% if chk_toolbox('Parallel Computing Toolbox') && ~matlabpool('size') > 0
%     matlabpool('open');
% end

[SWI, LFS] = HS_swi_proc(imgW, img, par, 'hamming', 0.125, 75);


%   Save unfiltered data
% fprintf('Saving');
% fname = [pathout '/SWI2D'];
% save(fname,'par','imgW','SWI','LFS');
% clear img
% fprintf('...Done\n');


%   Interpolate images for DICOM export
disp('Writing DICOMs...');
imgW = flipdim(imgW,2);
imgW = flipdim(imgW,3);
LFS = flipdim(LFS,2);
LFS = flipdim(LFS,3);
SWI = flipdim(SWI,2);
SWI = flipdim(SWI,3);
par.ns = size(imgW,3);
ROres = par.lro/(par.np/2);
PEres = par.lpe/(par.nv);
res   = 0.5*min(ROres,PEres);
ROnp  = round(par.lro/res);
PEnv  = round(par.lpe/res);
img  = zeros([ROnp PEnv par.ns]);
img2 = zeros([ROnp PEnv par.ns]);
img3 = zeros([ROnp PEnv par.ns]);
for ind=1:par.ns
    img(:,:,ind)  = imresize(imgW(:,:,ind),[ROnp,PEnv]);
    img2(:,:,ind) = imresize(SWI(:,:,ind),[ROnp,PEnv]);
    img3(:,:,ind) = imresize(LFS(:,:,ind),[ROnp,PEnv]);
end
clear imgW SWI LFS
par.nv = PEnv;
par.np = 2*ROnp;

%   Define common dicom headers
par.StudyInstanceUID = ['1.3.6.1.4.1.9590.100.1.1.817913647490004488.' par.studyid_(3:end)];
par.StudyInstanceUID(strfind(par.StudyInstanceUID,'_')) = '';
par.SeriesNumber = 0;
par.PatientID = '';
par.StudyDescription = '';

%   Write Composite T2* DICOM
fname = [pathout '/SWI_Magnitude'];
if strcmp(fname(1),'_') || strcmp(fname(1),'.');
    fname = fname(2:end);
end
if ~exist(fname,'dir')
    mkdir(fname);
end
par2 = par;
par2.comment = [par.comment ' SWI_Magnitude'];
dicomw(img,[fname '/SWI2D_Magnitude'],par2,[0 0.9],0);
disp('...Done SWI Magnitude');

%   Create directory for SWI
fname = [pathout '/SWI_Masked'];
if strcmp(fname(1),'_') || strcmp(fname(1),'.');
    fname = fname(2:end);
end
if ~exist(fname,'dir')
    mkdir(fname);
end
par2 = par;
par2.comment = [par.comment ' SWI_Masked'];
dicomw(img2,[fname '/SWI_Masked'],par2,[0 0.9],0);
disp('...Done SWI Masked');


%   Create directory for phase images
fname = [pathout '/SWI_Local_Field_Shift'];
if strcmp(fname(1),'_') || strcmp(fname(1),'.');
    fname = fname(2:end);
end
if ~exist(fname,'dir')
    mkdir(fname);
end

%   Define headers
par2 = par;
par2.comment = [par.comment ' SWI_Local_Field_Shift'];

%   Write dicoms
img3(img3 > 125) = 125;
img3(img3 < -125) = -125;
dicomw(img3*100,[fname '/SWI_Local_Field_Shift'],par2,[0 1],2);
disp('...Done Local Field Shift');
disp('Recon Complete');

return
