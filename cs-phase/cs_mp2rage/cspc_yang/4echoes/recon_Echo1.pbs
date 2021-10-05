#!/bin/bash
#
#PBS  -A UQ-EAIT-ITEE
#PBS -l select=1:ncpus=10:mem=30GB
#PBS  -l walltime=20:00:00
#PBS -N rec_1
#

module load matlab	
echo
which matlab
echo
#
cd /home/uqhsun8/Documents/MATLAB/scripts/cs-phase/cs_mp2rage/cspc_yang
matlab -nodisplay -nosplash -r "CS_Recon_4D_MC(1)"
