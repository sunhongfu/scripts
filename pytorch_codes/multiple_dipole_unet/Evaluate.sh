#!/bin/bash
#SBATCH -N 1
#SBATCH --job-name=HS_test_multiple_D
#SBATCH -n 1
#SBATCH -c 3
#SBATCH --mem=100000
#SBATCH -e HS_test_multiple_D.err
#SBATCH -o HS_test_multiple_D.out
#SBATCH --partition=gpu
#SBATCH --gres=gpu:tesla-smx2:1

module load anaconda/3.6
source activate /opt/ohpc/pub/apps/pytorch_1.10_openmpi
module load cuda/10.0.130
module load gnu/5.4.0
module load mvapich2
module load matlab

python --version
srun python -u  eval_multiple_D_unet.py
