#!/bin/bash
#SBATCH -N 1
#SBATCH --job-name=yang_2L30EPO_pytorch
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --mem=50000
#SBATCH -e ResNet_error.err
#SBATCH --partition=gpu
#SBATCH --gres=gpu:tesla-smx2:2

module load anaconda/3.6
source activate /opt/ohpc/pub/apps/pytorch_1.10_openmpi
module load cuda/10.0.130
module load gnu/5.4.0
module load mvapich2

python --version
srun python -u Train_D_Unet_singleLoss.py
