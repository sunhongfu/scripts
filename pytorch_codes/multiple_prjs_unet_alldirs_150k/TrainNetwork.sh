#!/bin/bash
#SBATCH -N 1
#SBATCH --job-name=train_multiple_prjs_unet_alldirs_150k
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --mem=30000
#SBATCH -e train_multiple_prjs_unet_alldirs_150k.err
#SBATCH -o train_multiple_prjs_unet_alldirs_150k.out
#SBATCH --partition=gpu
#SBATCH --gres=gpu:tesla-smx2:2

module load anaconda/3.6
source activate /opt/ohpc/pub/apps/pytorch_1.10_openmpi
module load cuda/10.0.130
module load gnu/5.4.0
module load mvapich2

srun python -u Train_D_Unet.py