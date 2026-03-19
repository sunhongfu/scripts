# T2-w-MP-PCA
    This repo has a MATLAB script to process 4D T2*-weighted MRI data, 
    including denoising and generating R2* and T2* maps.
    
    When using please cite: Veraart et al., 
    NeuroImage (2016) https://doi.org/10.1016/j.neuroimage.2016.08.016 and 
    Does et al.,MRM (2018) https://doi.org/10.1002/mrm.27658
---

## **Requirements**
    NIfTI Toolbox for MATLAB
    R2s_T2s_fit.m for map calculation

## **Usage**
  What the Script Does:

    - Loads 4D NIfTI magnitude and phase data.
    - Denoises the data using MPPCA.
    - Calculates R2* and T2* maps for original and denoised data.
    - Displays figures comparing original and denoised results.

How to Run:

    Make sure the required NIfTI files are in the Data folder:
        Magnitude NIfTI file (e.g., MagnitudeTimeseries.nii)
        Phase NIfTI file (e.g., PhaseTimeseries.nii)

    Open main.m in MATLAB and adjust the input parameters if needed (see Input Parameters below).
 
 ## **Input Parameters**
  Set these parameters in main.m:

    Scans_dir:
    Path to the directory containing the scan folders. Default is the current directory.

    Scans_dir = pwd;

    Data_dir:
    Name of the folder containing the specific scan.

    Data_dir = "Data";

    Data_Mag:
    Name of the NIfTI file with magnitude data.

    Data_Mag = "MagnitudeTimeseries.nii";

    Data_Phs:
    Name of the NIfTI file with phase data.

    Data_Phs = "PhaseTimeseries.nii";

    window:
    Size of the isoptropic sliding window for denoising (recommended: 3).

    window = 3;

    slice:
    Slice index to process (e.g., 30).

    slice = 30; 

 ## **Output Parameters**

  The script generates these outputs:

    Mag_Decay_Den: Denoised magnitude data.
    Phs_Decay_Den: Denoised phase data.
    R2s_map_Org & R2s_map_Den: R2* maps for original and denoised data.
    T2s_map_Org & T2s_map_Den: T2* maps for original and denoised data.

  Generated Figures:

    Figure 1: Original vs. denoised T2*-weighted images.
    Figure 2: Original vs. denoised R2* maps.
    Figure 3: Original vs. denoised T2* maps.

## **License**
    This project is licensed under the MIT License - see the LICENSE file for details.

