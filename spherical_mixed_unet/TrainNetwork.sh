#!/bin/bash
#SBATCH -N 1
#SBATCH --job-name=mixed_unet
#SBATCH -n 1
#SBATCH -c 2
#SBATCH --mem=30000
#SBATCH -e mixed_unet.err
#SBATCH -o mixed_unet.out
#SBATCH --partition=gpu
#SBATCH --gres=gpu:tesla-smx2:2

module load anaconda/3.7
source activate /scratch/itee/uqhsun8/apps/conda_envs/pytorch
# source activate /scratch/itee/uqzxion3/data/envs/main
module load cuda/11.7.0
# module load cuda/10.0.130
module load gnu/5.4.0
module load mvapich2


srun python -u train_unet_mixed.py
