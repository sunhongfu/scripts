#!/bin/bash
#SBATCH -N 1
#SBATCH --job-name=HS_DDPM_conditional_sampling
##SBATCH -n 1
##SBATCH -c 1
##SBATCH --mem=30000
#SBATCH -e HS_DDPM_sampling.err
#SBATCH -o HS_DDPM_sampling.out
#SBATCH --partition=p100
#SBATCH --gres=gpu:1



python -u sampling_test.py
