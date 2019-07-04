module load cuda/9.2.148.1
module load gnu7
module load mvapich2
module load anaconda/3.6
module load pmix

#!/bin/bash
#SBATCH -N 2
#SBATCH --job-name=xuanyu_test_tensor_gpu
#SBATCH -n 2
#SBATCH -c 1
#SBATCH --mem=50000
#SBATCH -o tensor_out.txt
#SBATCH -e tensor_error.txt
#SBATCH --partition=gpu
#SBATCH --gres=gpu:tesla:2


srun -n2 python3.6 train.py --patch_height=48 --patch_width=48 --patch_depth=48 --data_path /scratch/itee/uqxuanyu/Dataset
