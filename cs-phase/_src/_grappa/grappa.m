%   grappa.m
%   mchiew@fmrib.ox.ac.uk
%
%   inputs: 
%           data    -   (nc, nx, ny, nz, m]) complex undersampled k-space data
%                       will also loop across extra dimension m
%           calib   -   (nc, cx, cy, cz) complex calibration k-space data
%           R       -   [Rx, Ry] or [Rx, Ry, Rz] acceleration factors
%           kernel  -   [kx, ky] or [kx, ky, kz] kernel size 
%           tol     -   singular value cutoff threshold for kernel weight
%                       training, relative to s(1), defaults to pinv default
%
%   output:
%           recon   -   (nc, nx, ny, nz) complex reconstructed k-space data

function data = grappa(data, calib, ARG)

 data  = permute(data ,[3,1,2,4]);
 calib = permute(calib,[3,1,2]);

 R       = ARG.iPAT.factor;
 kernel  = ARG.iPAT.kernel;
 tol     = ARG.iPAT.tol; 

%% Use default pinv tolerance if not supplied
if tol > 0
    pinv_reg = @(A)pinv(A, tol*norm(A,2));
else
    pinv_reg = @pinv;
end

%% Determine whether this is a 1D or 2D GRAPPA problem
if numel(R) == 2
    R(3)        =   1;
end
if numel(kernel) == 2
    kernel(3)   =   1;
end
for iMe = 1:size(data,4)
    %%  extract one measument
    tmp = squeeze(data(:,:,:,iMe));
    
    %%  Prepare masks and zero-pad data
    if iMe == 1
        pad    =   floor(R.*kernel/2);
        mask   =   padarray(tmp~=0, [0 pad]);
    end
    tmp    =   padarray(tmp,    [0 pad]);

    %%  Loop over all possible kernel types
    for type = 1:prod(R(2:end))-1
        if iMe == 1
            %   Collect source and target calibration points for weight estimation   
            [src, trg]  =   grappa_get_indices(kernel, true(size(calib)), pad, R, type);

            %   Perform weight estimation
            weights(:,:,type)     =   calib(trg)*pinv_reg(calib(src));
        end
    
        %   Collect source points in under-sampled data for weight application    
        [src, trg]  =   grappa_get_indices(kernel, mask, pad, R, type);

        %   Apply weights to reconstruct missing data    
        tmp(trg)   =   squeeze(weights(:,:,type))*tmp(src);         

    end

    %%  Un-pad reconstruction to get original image size back
    data(:,:,:,iMe)   =   tmp(:,pad(1)+1:size(tmp,2)-pad(1), pad(2)+1:size(tmp,3)-pad(2), pad(3)+1:size(tmp,4)-pad(3),:);
    clear tmp
end
%%  Permute for compatibility with other code
data = permute(data,[2,3,1,4]);
