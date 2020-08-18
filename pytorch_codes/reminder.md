- unet (unet_cat_D) ----- **finished**
  concat D(dipole in k-space) to the field
  loss function only cares about the first half
  train with data from 5 orientations

- unet_mixed ----- **finished**
  no dipole gets invovled in training
  train with data from 5 orientations

- single_D_unet ----- **finished**
  feed a single D(k-space) of [0 0 1] orientation to training
  train with data from 1 orientation (e.g. [0 0 1])

- multiple_D_unet ----- **finished**
  feed multiple D(k-space) of 5 different orientations
  train with data from 5 orientations

- unet_cat_dipole_image ----- **finished**
  similar to unet (unet_cat_D)
  however concat d (dipole in image space) to the field

* single_dipole_unet ----- **finished**

* multiple_dipole_unet ----- **finished**

**currently dipole in image space not working well, maybe because the range, try to normalize before concat?**

TODO:

1. orientations try prjs_x = -0.5: 0.5, prjs_y = -0.5:0.5. or bigger angles: x=-1:1, y=-1:1, z always positive
2. run unrolled method
3. change code for 'concatenated inputs mode' to only output half size, currently ignoring the second half

- image_unet_stack_D
  does not work well with other orientations, such as coronal

- image_unet_stack_dipole
  stack field and dipole both in image space

- multiple_dipole_unet **updated**

- single_dipole_unet **updated**

To test:

- single_kspace_D_unet **running** NEED TO UPDATE EVAL
  field in kspace and dipole in kspace (D) as two individual inputs
  generate field using the same single D

- multiple_kspace_D_unet **running** NEED TO UPDATE EVAL
  field in kspace and dipole in kspace (D) as two individual inputs
  generate field using different multiple D of different orientations
