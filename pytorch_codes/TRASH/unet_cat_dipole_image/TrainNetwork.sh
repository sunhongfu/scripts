#!/bin/bash
#SBATCH -N 1
#SBATCH --job-name=HS_unet_cat_dipole_image
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --mem=30000
#SBATCH -e HS_unet_cat_dipole_image.err
#SBATCH -o HS_unet_cat_dipole_image.out
#SBATCH --partition=gpu
#SBATCH --gres=gpu:tesla-smx2:2

module load anaconda/3.6
source activate /opt/ohpc/pub/apps/pytorch_1.10_openmpi
module load cuda/10.0.130
module load gnu/5.4.0
module load mvapich2

srun python -u train_unet_cat_dipole_image.py