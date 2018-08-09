function [SWI MASK] = swi_haacke(MAG, PHASE, N)
% MAG: magnitude image
% PHASE: phase image, HP filtered
% N: number of phase mask multiplication (default: 4)

if (~exist('N', 'var'))
    N=4;
end

% step1: compute phase mask

%negative phase mask
MASK = ((PHASE <= 0) .* (1 + PHASE ./ pi)) + (PHASE > 0);

%positive phase mask (left for reference only)
% MASK = ((PHASE >= 0) .* (1 - PHASE ./ pi)) + (PHASE < 0);

% multiply mask by itself (4 times)
MASK = MASK .^N;

%  multiply phase mask and magnitude image
SWI = MAG .* MASK;
