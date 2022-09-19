using CLEARSWI

TEs = [3.4200    6.9440   10.4680   13.9920   17.5160   21.0400   24.5640   28.0880] # change this to the Echo Time of your sequence. For multi-echoes, set a list of TE values, else set a list with a single TE value.
# nifti_folder = CLEARSWI.dir("test","testData","small") # replace with path to your folder e.g. nifti_folder="/data/clearswi"
# magfile = joinpath(nifti_folder, "Mag.nii") # Path to the magnitude image in nifti format, must be .nii or .hdr
# phasefile = joinpath(nifti_folder, "Phase.nii") # Path to the phase image

mag = readmag("/Users/uqhsun8/Desktop/mag.nii");
phase = readphase("/Users/uqhsun8/Desktop/ph_corr.nii");
data = Data(mag, phase, mag.header, TEs);

swi = calculateSWI(data);
# mip = createIntensityProjection(swi, minimum); # minimum intensity projection, other Julia functions can be used instead of minimum
mip = createMIP(swi); # shorthand for createIntensityProjection(swi, minimum)

savenii(swi, "swi.nii"; header=mag.header) # change <outputpath> with the path where you want to save the reconstructed SWI
savenii(mip, "mip.nii"; header=mag.header)