function [] = do_unwrap_swi( mag_file, phase_file, swi_file, phase_un_file, mask_file, L, r, N, no_phase_rescale )
% Performs classic SWI reconstruction
% SWI reconstruction is achieved by 2D homodyne filtering for unwrapping
% the phase followed by phase mask multiplication
% mag_file: path where to find the magnitude image (mnc file)
% phase_file: path where to find the phase image (mnc file)
% swi_file: path where to save the swi reconstructed image (mnc file)
% phase_un_file: path where to save the intermediate phase unwrapped image
%                (optional)
% L: tukey window width used for homodyne filtering: default = 96
% r: tukey window taper ratio (default = 0.5)
% N: number of phase mask multiplication (default = 4)

if (~exist('L','var'))
    L = 0.25;
end

if (~exist('r','var'))
    r = 0.5;
end

if (~exist('N', 'var'))
    N = 4;
end

if (~exist('no_phase_rescale','var'))
   no_phase_rescale = 0; 
end


[hdr_mag,MAG]=niak_read_vol(mag_file);
[hdr_phase,PHASE]=niak_read_vol(phase_file);
[hdr_mask, MASK] = niak_read_vol(mask_file);

if (no_phase_rescale == 0)
    PHASE_FLOAT = rescalePhaseImage2(PHASE);
else
    PHASE_FLOAT = PHASE; 
end

%% Hongfu added
MASK = ones(size(PHASE));
%%%

%PHASE_SUN = laplacianUnwrap(PHASE_FLOAT, MASK);
%% Hongfu changed
PHASE_SUN = -laplacianUnwrap(PHASE_FLOAT, MASK);
%%%

B0_dir = [0;0;1];

matrix_size = size(PHASE_FLOAT);

voxel_size = hdr_mag.info.voxel_size;


%PHASE_UN = PDF(PHASE_SUN, MAG, MASK,matrix_size,voxel_size, B0_dir);
PHASE_UN = phaseUnwrapHomodyne2D(MAG, PHASE_SUN, L, r);

SWI = swi_haacke (MAG, PHASE_UN, N);

hdr_swi = hdr_mag;
hdr_swi.file_name = swi_file;
niak_write_vol(hdr_swi, SWI);

if (exist('phase_un_file', 'var'))
    hdr_phase_un = hdr_phase;
    hdr_phase_un.file_name = phase_un_file;
    niak_write_vol(hdr_phase_un, PHASE_UN);
end

end

