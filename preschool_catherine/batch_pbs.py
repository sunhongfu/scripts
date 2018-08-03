import os
import glob

pbs_list = glob.glob("*.pbs")

for pbs in pbs_list:
	os.system("qsub -l nodes=1:ppn=4,walltime=8:00:00,mem=2gb " + pbs)
