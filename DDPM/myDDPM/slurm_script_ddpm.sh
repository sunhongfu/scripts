#!/bin/bash
#SBATCH -N 1
#SBATCH --job-name=HS_DDPM
##SBATCH -n 1
##SBATCH -c 1
##SBATCH --mem=30000
#SBATCH -e HS_DDPM.err
#SBATCH -o HS_DDPM.out
#SBATCH --partition=vgpu40
#SBATCH --gres=gpu:1



python -u ddpm.py
