#!/bin/bash
#SBATCH -N 1
#SBATCH --job-name=prepare_testdata
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -e prepare_testdata.err
#SBATCH -o prepare_testdata.out
#SBATCH --partition=cpu



python -u prepare_testdata.py
