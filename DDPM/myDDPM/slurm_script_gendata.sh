#!/bin/bash
#SBATCH -N 1
#SBATCH --job-name=HS_DDPM
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -e HS_DDPM.err
#SBATCH -o HS_DDPM.out



python -u preprocessing.py
