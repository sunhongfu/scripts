function mask_thresh = mask_thresh(fname,nframe)

% -------------------------------------------------------------------------
% Function to find the first 'dip' in the histogram of the nframe frame of
% the input file fname by searching up to the largest local max 
% or 0 if unsuccessful. Based on JJC's script 'find_mask_thresh', renamed
% to avoid matlab confusion.
%
% last modified : $Date: Oct. 2012$
% by            : $Author: Eva Alonso Ortiz (EAO)$
% -------------------------------------------------------------------------


nbin=100;
dbin=10;

[data_desc,data_vol] = niak_read_minc(fname);

nframes = data_desc.info.dimensions(1,4);
nslices = data_desc.info.dimensions(1,3);
height = data_desc.info.dimensions(1,1);
width = data_desc.info.dimensions(1,2);
data_voxels = width*height*nslices;

data_vol = reshape(data_vol, data_voxels, nframes);
dm = data_vol(:,nframe);

[freq, mask]=hist(dm(:),nbin);
%plot (hist(dm(:),mask));
fm=freq(1:nbin-2*dbin);
f0=freq(1+dbin:nbin-dbin);
fp=freq(1+2*dbin:nbin);


h=(abs(f0-fm)+abs(f0-fp)).*(f0>fp).*(f0>fm);

if any(h)
     mh=min(find(h==max(h))+dbin);
     mask_thresh=max(mask(find(freq==min(freq(1:mh)))));
else
    mask_thresh=0;
end

