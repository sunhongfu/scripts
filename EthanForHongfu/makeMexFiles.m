% Script -> compile various mex files.

% Make sure nessisary dependancies are in place

mex -outdir @SimulatePulseSeq/private/ @SimulatePulseSeq/private/SimulatePulseSequence.cpp
mex -outdir @Mask/private/ @Mask/private/BrainExtractor.cpp
mex -outdir @Mask/private/ @Mask/private/MaskFilling.cpp
mex -outdir @Mask/private/ @Mask/private/MaskClipping.cpp
mex @QSM/private/pm_ff_unwrap.c
mex @QSM/private/ConvolveWithMask.cpp
mex -I/Users/ethan/fftw-3.3.3/api @BolusPassagePerfusion/private/PerfusionCalculations.cpp


