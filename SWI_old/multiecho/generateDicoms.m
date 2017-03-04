function generateDicoms(img,par)


%   Interpolate images for DICOM export
disp('Writing DICOMs...');

img = flipdim(img,2);
img = flipdim(img,3);


ROres = par.lro/(par.np/2);
PEres = par.lpe/(par.nv);
res   = 0.5*min(ROres,PEres);
ROnp  = round(par.lro/res);
PEnv  = round(par.lpe/res);
par.nv = PEnv;
par.np = 2*ROnp;

%   Define common dicom headers
par.StudyInstanceUID = ['1.3.6.1.4.1.9590.100.1.1.817913647490004488.' par.studyid_(3:end)];
par.StudyInstanceUID(strfind(par.StudyInstanceUID,'_')) = '';
par.SeriesNumber = 0;
par.PatientID = '';
par.StudyDescription = '';


%   Create directory for phase images
fname = [pwd '/img_SC'];
if strcmp(fname(1),'_') || strcmp(fname(1),'.');
    fname = fname(2:end);
end
if ~exist(fname,'dir')
    mkdir(fname);
end

%   Define headers
par2 = par;
par2.comment = [par.comment ' LocalFieldShift_SC'];

%   Write dicoms
img(img> 125) = 125;
img(img < -125) = -125;
dicomw(img*100,[fname '/img_SC'],par2,[0 1],2);
disp('...Done Local Field Shift');
disp('Recon Complete');
