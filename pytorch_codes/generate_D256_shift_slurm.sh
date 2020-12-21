#!/bin/bash
#SBATCH -N 1
#SBATCH --job-name=generate_D256_shift
#SBATCH -n 1
#SBATCH -c 12
#SBATCH --mem=30000
#SBATCH -e generate_D256_shift.err
#SBATCH -o generate_D256_shift.out

module load matlab

srun matlab -nodisplay -nosplash -nodesktop < generate_D256_shift.m