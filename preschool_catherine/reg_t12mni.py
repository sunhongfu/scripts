# -*- coding: utf-8 -*-

import os, sys  # system functions
import nipype.interfaces.io as nio  # Data i/o
import nipype.interfaces.fsl as fsl  # fsl
import nipype.pipeline.engine as pe  # pypeline engine
import nipype.interfaces.utility as util  # utility
import nipype.interfaces.ants as ants
from nipype.interfaces.c3 import C3dAffineTool
from nipype.interfaces.ants.segmentation import BrainExtraction

import multiprocessing, time
from multiprocessing import Pool
nprocs=multiprocessing.cpu_count()

start_time = time.time()


fsl.FSLCommand.set_default_output_type('NIFTI_GZ')

"""
Project info
"""
# which subjects to run
subject_id = str(sys.argv[1])
scan_id = str(sys.argv[2])

main_dir = "/home/dmitrii/"
project_dir = main_dir+"/Analysis/ASL/"
work_dir = "/data/dmitrii/scratch/ASL/"

if not os.path.exists(work_dir):
    os.makedirs(work_dir)

template_brain = os.path.join(project_dir,'MNI','nihpd_asym_04.5-08.5_t1w.nii')
moving_image = project_dir+subject_id+"/"+scan_id+"/anat/anat.nii.gz"


"""
Create workflow
"""

wf = pe.Workflow(name='wf')
wf.base_dir = os.path.join(work_dir, "reg_wdir", subject_id, scan_id)
wf.config = {"execution": {"crashdump_dir": os.path.join(work_dir, 'reg_crashdumps', subject_id, scan_id)}}

"""
Register T1 to MNI
"""
reg = pe.Node(ants.Registration(), name='antsRegister')
reg.inputs.output_transform_prefix = "anat2mni_"
reg.inputs.transforms = ['Rigid', 'Affine', 'SyN']
reg.inputs.transform_parameters = [(0.1,), (0.1,), (0.2, 3.0, 0.0)]
reg.inputs.number_of_iterations = [[10000,111110,11110]] * 2 + [[100, 100, 50]]
reg.inputs.dimension = 3
reg.inputs.write_composite_transform = True
reg.inputs.collapse_output_transforms = True
reg.inputs.initial_moving_transform_com = True
reg.inputs.metric = ['Mattes'] * 2 + [['Mattes', 'CC']]
reg.inputs.metric_weight = [1] * 2 + [[0.5, 0.5]]
reg.inputs.radius_or_number_of_bins = [32] * 2 + [[32, 4]]
reg.inputs.sampling_strategy = ['Regular'] * 2 + [[None, None]]
reg.inputs.sampling_percentage = [0.3] * 2 + [[None, None]]
reg.inputs.convergence_threshold = [1.e-7] * 2 + [-0.01]
reg.inputs.convergence_window_size = [20] * 2 + [5]
reg.inputs.smoothing_sigmas = [[4, 2, 1]] * 2 + [[1, 0.5, 0]]
reg.inputs.sigma_units = ['vox'] * 3
reg.inputs.shrink_factors = [[3, 2, 1]]*2 + [[4, 2, 1]]
reg.inputs.use_estimate_learning_rate_once = [True] * 3
reg.inputs.use_histogram_matching = [False] * 2 + [True]
reg.inputs.winsorize_lower_quantile = 0.005
reg.inputs.winsorize_upper_quantile = 0.995
reg.inputs.args = '--float'
reg.inputs.output_warped_image = 'anat2mni_warped_image.nii.gz'
reg.inputs.output_inverse_warped_image = 'mni2anat_warped_image.nii.gz'
reg.inputs.num_threads = 2

reg.inputs.fixed_image=template_brain
reg.inputs.moving_image=moving_image


"""
Transform MNI mask, which is aligned to T1, to MNI
"""

warp_mask = pe.MapNode(ants.ApplyTransforms(), iterfield=['input_image','transforms'], name='warp_mask')
warp_mask.inputs.input_image_type = 0
warp_mask.inputs.interpolation = 'Linear'
warp_mask.inputs.invert_transform_flags = [False]
warp_mask.inputs.terminal_output = 'file'
warp_mask.inputs.input_image = os.path.join(project_dir,'MNI','sub-08_T1w_brainmask.nii.gz')

wf.connect(reg, 'inverse_composite_transform', warp_mask, 'transforms') # using transform matrix from t1 to mni
warp_mask.inputs.reference_image = moving_image


"""
Save data
"""

datasink = pe.Node(nio.DataSink(), name='sinker')
datasink.inputs.base_directory = os.path.join(project_dir, "reg")

datasink.inputs.container = subject_id+'_'+scan_id

wf.connect(reg, 'warped_image', datasink, 'anat.anat2mni')
wf.connect(reg, 'inverse_warped_image', datasink, 'anat.mni2anat')
wf.connect(reg, 'composite_transform', datasink, 'anat.anat2mni_mat')
wf.connect(reg, 'inverse_composite_transform', datasink, 'anat.mni2anat_mat')
wf.connect(warp_mask, 'output_image', datasink, 'anat.mask2t1')

"""
Run
"""
outgraph = wf.run(plugin='MultiProc')

print("--- %s seconds ---" % (time.time() - start_time))
