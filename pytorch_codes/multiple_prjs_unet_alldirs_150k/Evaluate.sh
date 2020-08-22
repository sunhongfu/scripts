#!/bin/bash
#SBATCH -N 1
#SBATCH --job-name=eval_multiple_prjs_unet_alldirs_150k
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --mem=10000
#SBATCH -e eval_multiple_prjs_unet_alldirs_150k.err
#SBATCH -o eval_multiple_prjs_unet_alldirs_150k.out
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
