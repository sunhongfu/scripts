function ret = create_brainmask(fname)

%--------------------------------------------------------------------------
% Function to produce a binary brain mask based on thresholding. Based on
% JJC's script, name changed from generate_brainmask to avoid matlab confusion
%
% Inputs: fname - name of the file to estimate the mask from
%
% Outputs: binary brain masks brain_mask.mnc 
%
% last modified : $Date: Oct. 2012$
% by            : $Author: Eva Alonso Ortiz (EAO)$
%--------------------------------------------------------------------------

this_fname = 'generate_brainmask';
this_info = sprintf('%-20s : ',this_fname);
fprintf([this_info, '$Revision: 1.1 $\n']);

% open images and get info
[data_desc,data_vol] = niak_read_minc(fname);


nframes = data_desc.info.dimensions(1,4);
nslices = data_desc.info.dimensions(1,3);
height = data_desc.info.dimensions(1,1);
width = data_desc.info.dimensions(1,2);
data_voxels = width*height;

data = squeeze(reshape(data_vol,data_voxels,nslices,nframes));


% ------------------------------BRAIN MASK--------------------------------%

% mask_thresh is the function to find the first 'dip' in the histogram of the nframe frames (noise level)
nframe = 1;
thresh = mask_thresh(fname,nframe);
if (thresh==0)
  fprintf([this_info 'WARNING: The threshold search returned 0, ie most likely FAILED.\n']);
else
  fprintf([this_info 'The brain masking threshold calculated is: %f \n'],thresh);
  fprintf([this_info 'Check whether this threshold is reasonable. \n']);
end

% let the user choose the brain masking threshold (copying above, if so desired)
thresh = input([this_info 'Enter the desired threshold to be used for masking (the above one if you wish): ']);

% initialize output mask
mask = zeros(width*height,nslices);

%% binary mask: all the values corresponding to voxels above thresh are set to 1
for slice=1:nslices 
    ind_inside = find(data(:,slice,nframe)>thresh);
    mask(ind_inside,slice)=1;
end

%--------------------------------------------------------------------------
% write out a brain mask
mname_out = 'brain_mask.mnc';
fprintf([this_info 'Writing %s\n'],mname_out);

if exist(mname_out)
  delete(mname_out);
  unix(['rm -f noise_mask.mnc']);
end;

mask = reshape(mask, height, width, nslices);

data_desc.file_name = mname_out;
niak_write_minc(data_desc,mask);

unix(['xdisp -grey ',mname_out,' &']);
     
ret=1;
