- unet (unet_cat_D) ----- finished
  concat D(dipole in k-space) to the field
  loss function only cares about the first half
  train with data from 5 orientations

- unet_mixed ----- finished
  no dipole gets invovled in training
  train with data from 5 orientations

- single_D_unet ----- finished
  feed a single D(k-space) of [0 0 1] orientation to training
  train with data from 1 orientation (e.g. [0 0 1])

- multiple_D_unet ----- finished
  feed multiple D(k-space) of 5 different orientations
  train with data from 5 orientations

- unet_cat_dipole_image ----- running now
  similar to unet (unet_cat_D)
  however concat d (dipole in image space) to the field

* single_dipole_unet ----- to be run the last, probably won't work

* multiple_dipole_unet ----- to be run
