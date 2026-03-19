function [denoised,S2,P] = MPPCAdenoise(image,window,mask)
%
%
% INPUT: image - contains MRI image data. The first dimensions must
% discriminate between pixels, while the last dimension should correspond
% to echo time. Thus image data could for instance be
% structured as [X,Y,Z,N] or [X,Y,N].
%
% window - specifies the dimensions of the sliding window. 
%
% mask - logical array specifying which pixels to include -- if image is
% [X,Y,Z,N] then mask is [X,Y,Z]. Can optionally be left unspecified in
% which case every pixel is included.
%
%
% OUTPUT: denoisedImage - contains denoised image with same structure as
% input.
%
% S2 - contains estimate of variance in each pixel.
%
% P - specifies the found number of principal components.
%
% Please cite Veraart et al. (2016) 142, p
% 394-406 https://doi.org/10.1016/j.neuroimage.2016.08.016 and Does et al.,
% MRM (2018) (Evaluation of Principal Component Analysis Image Denoising on
% Multi-Exponential MRI Relaxometry)

%% adjust image dimensions and assert
if nargin<3
    mask = [];
end
dimsOld = size(image);
[image,mask] = imageAssert(image,mask);

dims = size(image);
assert(length(window)>1 && length(window)<4,...
  'window must have 2 or 3 dimensions')
assert(all(window>0),'window values must be strictly positive')
assert(all(window<=dims(1:length(window))),...
  'window values exceed image dimensions')
if length(window)==2
    window(3) = 1;
end


%% denoise image
M = dims(4);
N = prod(window);
denoised = zeros(dims);
P = zeros(dims(1:3));
S2 = zeros(dims(1:3));
counter = zeros(dims(1:3));
m = dims(1)-window(1)+1;
n = dims(2)-window(2)+1;
o = dims(3)-window(3)+1;
for index = 1:m*n*o
    k = floor((index-1)/m/n)+1;
    j = floor((index-1-(k-1)*m*n)/m)+1;
    i = index-(k-1)*m*n-(j-1)*m;
    rows = i:i-1+window(1);
    cols = j:j-1+window(2);
    slis = k:k-1+window(3);
    % Check mask
    maskCheck = reshape(mask(rows,cols,slis),[N 1])';
    if all(~maskCheck), continue, end
    
    % Create X data matrix
    X = reshape(image(rows,cols,slis,:),[N M])';
    
    % Remove voxels not contained in mask
    X(:,~maskCheck) = [];
    if size(X,2)==1, continue, end % skip if only one voxel of window in mask
       % Perform denoising
    newX=zeros(M,N); sigma2=zeros(1,N); p=zeros(1,N);
    [newX(:,maskCheck),sigma2(maskCheck),p(maskCheck)] = denoiseMatrix(X);
    
    % Assign newX to correct indices in denoisedImage
    denoised(rows,cols,slis,:) = denoised(rows,cols,slis,:) ...
      + reshape(newX',[window M]);
    P(rows,cols,slis) = P(rows,cols,slis) + reshape(p,window);
    S2(rows,cols,slis) = S2(rows,cols,slis) + reshape(sigma2,window);
    counter(rows,cols,slis) = counter(rows,cols,slis)+1;
end
skipCheck = mask & counter==0;
counter(counter==0) = 1;
denoised = bsxfun(@rdivide,denoised,counter);
P = bsxfun(@rdivide,P,counter);
S2 = bsxfun(@rdivide,S2,counter);


%% adjust output to match input dimensions
% Assign original data to denoisedImage outside of mask and at skipped voxels
original = bsxfun(@times,image,~mask);
denoised = denoised + original;
original = bsxfun(@times,image,skipCheck);
denoised = denoised + original;

% Shape denoisedImage as orginal image
if length(dimsOld)==3
    denoised = reshape(denoised,dimsOld);
    S2 = reshape(S2,dimsOld(1:end-1));
    P = reshape(P,dimsOld(1:end-1));
end


end


function [newX,sigma2,p] = denoiseMatrix(X)
% helper function to denoise.m
% Takes as input matrix X with dimension MxN with N corresponding to the
% number of pixels and M to the number of data points. The output consists
% of "newX" containing a denoised version of X, "sigma2" an approximation
% to the data variation, "p" the number of signal carrying components.

[M,N] = size(X);
minMN = min([M N]);
Xm = mean(X,2); % MDD added Jan 2018; mean added back to signal below;
X = X-Xm;
% [U,S,V] = svdecon(X); MDD replaced with MATLAB svd vvv 3Nov2017
[U,S,V] = svd(X,'econ');

lambda = diag(S).^2/N;

p = 0;
pTest = false;
scaling = (M-(0:minMN))/N;
scaling(scaling<1) = 1;
while ~pTest
    sigma2 = (lambda(p+1)-lambda(minMN))/(4*sqrt((M-p)/N));
    pTest = sum(lambda(p+1:minMN))/scaling(p+1) >= (minMN-p)*sigma2;
    if ~pTest, p = p+1; end
end
sigma2 = sum(lambda(p+1:minMN))/(minMN-p)/scaling(p+1);

newX = U(:,1:p)*S(1:p,1:p)*V(:,1:p)'+Xm;


end


function [image,mask] = imageAssert(image,mask)
% Want first image indices to discriminate between pixels and last
% dimension to hold data for each pixel. This function puts the image data
% on the form rxcxsxn.

dims = size(image);
assert(length(dims)<=4,'image data array must not have more than 4 dimensions')

% construct mask if not given
if numel(mask)==0
    if sum(dims~=1)==1
        mask = true;
    else
        mask = true([dims(1:end-1) 1]);
    end
end
maskDims = size(mask);

% voxel count must match
assert(numel(mask)==prod(dims(1:end-1)),...
	   sprintf('mask dimensions does not match image dimensions - 1 (m: %d,i: %d))',numel(mask),prod(dims(1:end-1))));

% if image only contains data from single pixel
if (all(dims(1:end-1)==1) && length(dims)<4) || (dims(1)>1 && dims(2)==1 && length(dims)<3) % (1xn || 1x1xn) || (nx1)
    assert(numel(mask)==1,'mask dimensions does not match image dimensions - 2')
    dummy(1,1,1,:) = image;
    image = dummy;
end

% if image is on form rxcxn
if length(dims)==3
    assert(all(maskDims==dims(1:end-1)),'mask dimensions does not match image dimensions - 3')
    dummy(:,:,1,:) = image;
    image = dummy;
end

% if image is on form rxn
if length(dims)==2 && dims(2)~=1;
    assert(all(maskDims(1)==dims(1)),'mask dimensions does not match image dimensions - 4')
    dummy(:,1,1,:) = image;
    image = dummy;
end
end