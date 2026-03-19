function find_optimal_cutoff(T2_fname, T2_roi_fname, T2star_fname, T2star_roi_fname, varargin)

% *************************************************************************
% 
% DESCRIPTION: Function finds the optimal T2* cutoff (for defining the MWF)
% by minimizing delta-delta*, where delta =
% (gmT2-MW_upperT2limit)/MW_upperT2limit and delta* =
% (gmT2*-MW_upperT2*limit)/MW_upperT2*limit
%
% INPUTS: 
%   T2_fname - single slice, SE data
%   T2_roi_fname
%   T2star_fname - (must also be) single slice, GRE data
%   T2star_roi_fname
%
% AUTHOR: Eva Alonso Ortiz
% DATE: Jan. 2014
%
%*************************************************************************

% =========================== Header ==================================== %
this_fname = '';
this_info = sprintf('%-20s : ',this_fname);
fprintf([this_info,'$Revision: 1.0 $\n']);
fprintf([this_info, 'Current date and time: %s\n'], datestr(now));
% =========================================================================

diary('logfile_find_optimal_cutoff')

tic;

%--------------------------------------------------------------------------
% open data files
%--------------------------------------------------------------------------

[T2_desc,T2_vol] = niak_read_minc(T2_fname);

T2_dim = T2_desc.info.dimensions;
T2_slices = T2_dim(1,3);
T2_height = T2_dim(1,1);
T2_width = T2_dim(1,2);
T2_voxels = T2_height*T2_width;
T2_num_echoes = T2_dim(1,4);

[T2star_desc,T2star_vol] = niak_read_minc(T2star_fname);

T2star_dim = T2star_desc.info.dimensions;
T2star_slices = T2star_dim(1,3);
T2star_height = T2star_dim(1,1);
T2star_width = T2star_dim(1,2);
T2star_voxels = T2star_height*T2star_width;
T2star_num_echoes = T2star_dim(1,4);

% Open mask file
[T2_roi_desc, T2_roi_vol] = niak_read_minc(T2_roi_fname);

T2_roi_dim = T2_roi_desc.info.dimensions;
T2_roi_voxels = T2_roi_dim(1,1)*T2_roi_dim(1,2);

% check that mask and data_vol are the same dimensions
if T2_roi_voxels ~= T2_voxels
error('\nError in multi_comp_fit: T2 mask file dimensions do not match T2 data image file.\n'); 
end

% Open mask file
[T2star_roi_desc, T2star_roi_vol] = niak_read_minc(T2star_roi_fname);

T2star_roi_dim = T2star_roi_desc.info.dimensions;
T2star_roi_voxels = T2star_roi_dim(1,1)*T2star_roi_dim(1,2);

% check that mask and data_vol are the same dimensions
if T2star_roi_voxels ~= T2star_voxels
error('\nError in multi_comp_fit: T2* mask file dimensions do not match T2* data image file.\n'); 
end

% Does the user want to use a tissue classification mask?
% 1->CSF, 2->GM, 3->WM
tissue_flag = 0;

if nargin > 4
    tissue_flag = varargin{1};
    if (tissue_flag > 3 || tissue_flag < 1)
        error('Invalid tissue flag entered.');
    end
end

% If so, modify tissue classification mask, so that the tissue to be
% analyzed corresponds to 1, and everything else is 0.
if tissue_flag ~= 0
    T2_roi_vol(find(T2_roi_vol ~= tissue_flag)) = 0;
    T2_roi_vol(find(T2_roi_vol == tissue_flag)) = 1;
    T2star_roi_vol(find(T2star_roi_vol ~= tissue_flag)) = 0;
    T2star_roi_vol(find(T2star_roi_vol == tissue_flag)) = 1;
end
    

%--------------------------------------------------------------------------
% calculate echo times
%--------------------------------------------------------------------------

disp(fprintf('\nCalculating echo times for %s',T2_fname));
T2_echo_times = calc_echo_times(T2_num_echoes);

disp(fprintf('\nCalculating echo times for %s',T2star_fname));
T2star_echo_times = calc_echo_times(T2star_num_echoes);

%--------------------------------------------------------------------------
% Set default settings according to relaxation time
%--------------------------------------------------------------------------

T2_range = [1.5*T2_echo_times(1), 2*1e3]; % Kolind et al. doi: 10.1002/mrm.21966
        
% set cutoff times for myelin water (MW) and intra/extracellular
% water (IEW) components (in ms) 
T2_cutoff_upper_MW = [25:1:40]; % Kolind et al. doi: 10.1002/mrm.21966
T2_cutoff_upper_IEW = 200; % Kolind et al. doi: 10.1002/mrm.21966

T2star_range = [1.5*T2star_echo_times(1), 0.3*1e3]; % Lenz et al. doi: 10.1002/mrm.23241
        
% set cutoff times for myelin water (MW) and intra/extracellular
% water (IEW) components (in ms)  
T2star_cutoff_upper_MW = 25;
T2star_cutoff_upper_IEW = 200; 

%--------------------------------------------------------------------------
% default values for NNLS fitting
%--------------------------------------------------------------------------

num_T2_vals = 120;
num_T2star_vals = num_T2_vals;
  
% set default values for reg-NNLS (taken from C. Chia)
set(0,'RecursionLimit',5000)
mu = 0.25;
chi2range = [2 2.5];
chi2_min = chi2range(1);
chi2_max = chi2range(2);

%--------------------------------------------------------------------------
% Calculate background noise 
%--------------------------------------------------------------------------

T2_sigma = calc_bkgrnd_noise(T2_vol, T2_dim);
T2star_sigma = calc_bkgrnd_noise(T2star_vol, T2star_dim);

%--------------------------------------------------------------------------
% apply ROI mask to data volumes
%--------------------------------------------------------------------------

avgT2_roi_data = get_avgROI_data(T2_roi_vol, T2_vol, T2_dim)
avgT2star_roi_data = get_avgROI_data(T2star_roi_vol, T2star_vol, T2star_dim)

%--------------------------------------------------------------------------
% NNLS fitting routine presets
%--------------------------------------------------------------------------

[T2_decay_matrix, T2_vals] = prepare_NNLS(T2_echo_times, T2_range, num_T2_vals);
[T2star_decay_matrix, T2star_vals] = prepare_NNLS(T2star_echo_times, T2star_range, num_T2star_vals);

% find cutoff indices
T2star_cutoff_upper_MW_index = find_cutoff_index(T2star_cutoff_upper_MW, T2star_vals);
T2star_cutoff_upper_IEW_index = find_cutoff_index(T2star_cutoff_upper_IEW, T2star_vals);

for i = 1:size(T2_cutoff_upper_MW,2)
    T2_cutoff_upper_MW_index(i) = find_cutoff_index(T2_cutoff_upper_MW(i), T2_vals);
end
T2_cutoff_upper_IEW_index = find_cutoff_index(T2_cutoff_upper_IEW, T2_vals);

%--------------------------------------------------------------------------
% T2* data fitting and analysis
%--------------------------------------------------------------------------

% Do non-regularized NNLS
[T2star_spectrum_NNLS, T2star_chi2_NNLS] = ...
do_NNLS(T2star_decay_matrix, double(squeeze(avgT2star_roi_data)), T2star_sigma);

% Do regulaized NNLS 
[T2star_spectrum_regNNLS, T2star_chi2_regNNLS] = ...
iterate_NNLS(mu,chi2_min,chi2_max,num_T2star_vals,double(squeeze(avgT2star_roi_data)),...
T2star_decay_matrix,T2star_chi2_NNLS,T2star_sigma);

T2star_s0_regNNLS = sum(T2star_spectrum_regNNLS);
T2star_mwf_regNNLS = sum(T2star_spectrum_regNNLS(1:T2star_cutoff_upper_MW_index))/T2star_s0_regNNLS;

% Calculate the geometric mean of the IE water peak 
gmIEW_T2star_regNNLS = ...
exp(sum(squeeze(T2star_spectrum_regNNLS(T2star_cutoff_upper_MW_index:T2star_cutoff_upper_IEW_index)).*log(T2star_vals(T2star_cutoff_upper_MW_index:T2star_cutoff_upper_IEW_index)))/sum(T2star_spectrum_regNNLS(T2star_cutoff_upper_MW_index:T2star_cutoff_upper_IEW_index)));    

gmIEW_R2star_regNNLS = 1/gmIEW_T2star_regNNLS;

%--------------------------------------------------------------------------
% T2 data fitting and analysis
%--------------------------------------------------------------------------

% Do non-regularized NNLS
[T2_spectrum_NNLS, T2_chi2_NNLS] = ...
do_NNLS(T2_decay_matrix, double(squeeze(avgT2_roi_data)), T2_sigma);

% Do regulaized NNLS 
[T2_spectrum_regNNLS, T2_chi2_regNNLS] = ...
iterate_NNLS(mu,chi2_min,chi2_max,num_T2_vals,double(squeeze(avgT2_roi_data)), ...
T2_decay_matrix,T2_chi2_NNLS,T2_sigma);

T2_s0_regNNLS = sum(T2_spectrum_regNNLS);

for i = 1:size(T2_cutoff_upper_MW,2)

    T2_mwf_regNNLS(i) = sum(T2_spectrum_regNNLS(1:T2_cutoff_upper_MW_index(i)))/T2_s0_regNNLS;

    % Calculate the geometric mean of the IE water peak 
    gmIEW_T2_regNNLS(i) = ...
    exp(sum(squeeze(T2_spectrum_regNNLS(T2_cutoff_upper_MW_index(i):T2_cutoff_upper_IEW_index)).*log(T2_vals(T2_cutoff_upper_MW_index(i):T2_cutoff_upper_IEW_index)))/sum(T2_spectrum_regNNLS(T2_cutoff_upper_MW_index(i):T2_cutoff_upper_IEW_index)));    

    gmIEW_R2_regNNLS(i) = 1/gmIEW_T2_regNNLS(i);
end

%--------------------------------------------------------------------------
% Find the distance between the gmR2/R2* and the MW upper bound, normalized
% by the MW upper bound (=delta/delta*)
%--------------------------------------------------------------------------
R2star_cutoff_upper_MW = 1/T2star_cutoff_upper_MW;

delta_star = (gmIEW_R2star_regNNLS-R2star_cutoff_upper_MW)/R2star_cutoff_upper_MW;
%disp(fprintf('\n  %d => delta: %3.2f',  delta));

R2_cutoff_upper_MW = 1./T2_cutoff_upper_MW;

for i = 1:size(R2_cutoff_upper_MW,2)
    delta(i) = (gmIEW_R2_regNNLS(i)-R2_cutoff_upper_MW(i))/R2_cutoff_upper_MW(i);
    %disp(fprintf('\n  %d, upper MW cutoff = %d => delta*: %3.2f',  T2star_cutoff_upper_MW(i), delta_star(i)));
end

%--------------------------------------------------------------------------
% Find the T2 cutoff resulting in the min (delta-delta*)
%--------------------------------------------------------------------------

[min_ddiff, min_ddiff_index] = min(abs(delta-delta_star));

disp(fprintf('\n  T2 cutoff resulting in the minimum (delta-delta*) = %3.2f', T2_cutoff_upper_MW(min_ddiff_index)));

%--------------------------------------------------------------------------

time_spent = toc;

disp(fprintf('Time Spent: %3.2f min\n', time_spent/60));

diary off  

