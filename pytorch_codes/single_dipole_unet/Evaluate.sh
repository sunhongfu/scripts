#!/bin/bash
#SBATCH -N 1
#SBATCH --job-name=eval_single_dipole_unet
#SBATCH -n 1
#SBATCH -c 3
#SBATCH --mem=100000
#SBATCH -e eval_single_dipole_unet.err
#SBATCH -o eval_single_dipole_unet.out
#SBATCH --partition=gpu
#SBATCH --gres=gpu:tesla-smx2:1

module load anaconda/3.6
source activate /opt/ohpc/pub/apps/pytorch_1.10_openmpi
module load cuda/10.0.130
module load gnu/5.4.0
module load mvapich2
module load matlab

python --version
srun python -u  /scratch/itee/uqhsun8/CommQSM/pytorch_codes/single_dipole_unet/eval_single_D_unet.py
