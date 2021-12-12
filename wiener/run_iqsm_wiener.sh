#!/bin/bash
#SBATCH -N 1
#SBATCH --job-name=PA_TI
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --mem=10000
#SBATCH -e iqsm_hand.err
#SBATCH -o iqsm_hand.out
#SBATCH --partition=gpu
#SBATCH --gres=gpu:tesla-smx2:1

module load anaconda/3.6
source activate pytorch_1.7
module load cuda/10.0.130
module load gnu/5.4.0
module load mvapich2
module load matlab

srun matlab -nodisplay -singleCompThread -r "demo_single_echo"