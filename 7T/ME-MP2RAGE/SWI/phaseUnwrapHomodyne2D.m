function [ PHASE_OUT ] = phaseUnwrapHomodyne2D( MAG_IN, PHASE_IN, WindowSizeRatio, r )
% MAG_IN: magnitude image
% PHASE_IN: phase image converted to the -PI:PI range
% L: window width (default = 96)
% r: taper ratio of tuckey window (default = 0.5)

if (~exist('WindowSizeRatio', 'var'))
   WindowSizeRatio = 0.25; 
end

if (~exist('r', 'var'))
    r=0.5;
end

% initialization
volSize = size(PHASE_IN);
DATA = MAG_IN .* exp(PHASE_IN .* i);
PHASE_OUT = zeros(volSize(1), volSize(2), volSize(3));

%produce 2d tukey window of size LxL
%H=tukeywin(L,r)*tukeywin(L,r)';
L1 = ceil(WindowSizeRatio*volSize(1));
L2 = ceil(WindowSizeRatio*volSize(2));
H=tukeywin(L1,r)*tukeywin(L2,r)';

% Creates a filter H2 using slice dimension. The LxL center of the H2 will
% contain the filter H. anything outside the LxL center is zero padded.
H2 = zeros(volSize(1), volSize(2));
firstX = ceil(volSize(1)/2) - ceil(L1/2);
firstY = ceil(volSize(2)/2) - ceil(L2/2);
H2(firstX:firstX+L1-1, firstY:firstY+L2-1) = H;

% Do the filtering slice by slice
for s = 1:volSize(3)
    % extract slice data (complex data)
    SLICE = DATA(:,:,s); 
    
    % 2D fft
    DATA_FT = fft2(SLICE);
    DATA_FT = fftshift(DATA_FT);      
    
    % filter multiplication
    DATA_FT = DATA_FT .* H2;
    
    % 2D ifft
    DATA_FT = ifftshift(DATA_FT);
    DATA_FILT = ifft2(DATA_FT);
    
    % complex division between original slice data and filtered data
    % (in image space)
    DATA_OUT = SLICE ./ DATA_FILT;   
    
    % extract homodyne filtered phase information
    PHASE_OUT(:,:,s) = angle(DATA_OUT);
end
