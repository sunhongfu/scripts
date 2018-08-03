import os

merge_folder = "/home/hongfu.sun/data/project_preschool/merge"

for name in os.listdir(merge_folder):
	# print to file
	pbs_cmd = ("""#!/bin/bash\n"""
		"""#PBS -S /bin/bash\n"""
		"""cd $PBS_O_WORKDIR\n"""
		"""echo "Current working directory is `pwd`"\n"""
		"""echo "Starting run at: `date`"\n"""
		"python2 /home/hongfu.sun/standalone/project_preschool/merge/ants_mag1_to_b0_helix.py " + merge_folder + "/" + name + " mycode_${PBS_JOBID}.out \n"
		"""echo "Job finished with exit code $? at: `date`"\n"""
		)
	file = open(name + ".pbs", "w")
	file.write(pbs_cmd)
	file.close
