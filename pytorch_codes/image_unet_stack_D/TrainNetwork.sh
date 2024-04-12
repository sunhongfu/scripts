#!/bin/bash
#SBATCH -N 1
#SBATCH --job-name=image_unet_stack_D
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --mem=30000
#SBATCH -e image_unet_stack_D.err
#SBATCH -o image_unet_stack_D.out
#SBATCH --partition=gpu
#SBATCH --gres=gpu:tesla-smx2:2

module load anaconda/3.7
module load cuda/10.0.130
module load gnu/5.4.0
module load mvapich2
source activate /opt/ohpc/pub/apps/pytorch_1.10_openmpi

srun python -u train_unet_invivo_CommQSM.py