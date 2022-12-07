#!/bin/bash
#SBATCH -N 1
#SBATCH --job-name=sampling
##SBATCH -n 1
##SBATCH -c 1
##SBATCH --mem=30000
#SBATCH -e sampling.err
#SBATCH -o sampling.out
#SBATCH --partition=p100
#SBATCH --gres=gpu:1



python -u sampling_test.py
