#!/bin/bash
#SBATCH -N 1
#SBATCH --job-name=sun_test_pytorch
#SBATCH -n 1
#SBATCH -c 2
#SBATCH --mem=30000
#SBATCH -e ResNet_error.err
#SBATCH --partition=gpu
#SBATCH --gres=gpu:tesla-smx2:2

module load anaconda/3.6
source activate /opt/ohpc/pub/apps/pytorch_1.10_openmpi
module load cuda/10.0.130
module load gnu/5.4.0
module load mvapich2
module load matlab

python --version
srun python -u eval_unet_invivo_CommQSM.py
