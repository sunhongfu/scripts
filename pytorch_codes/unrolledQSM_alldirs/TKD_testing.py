import torch
import nibabel as nib
import numpy as np

# load in the real and image niftis
nibimage = nib.load(
    '/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_left_field.nii')
image = nibimage.get_data()
aff = nibimage.affine
image = np.array(image)
print('unrolledQSM')
image = torch.from_numpy(image)
print(image.size())
image = image.float()
image = torch.unsqueeze(image, 0)
image = torch.cat([image, torch.zeros(image.shape)], 0)

nibimage = nib.load(
    '/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_left_D_shift.nii')
D = nibimage.get_data()
aff = nibimage.affine
D = np.array(D)
print('unrolledQSM')
D = torch.from_numpy(D)
print(D.size())
D = D.float()


D_thr = D < 0.05

invD = 1/D
invD[D_thr] = 0

invD = torch.unsqueeze(invD, 0)
# invD = torch.cat([invD, invD], 0)


# forward fft of phi --> image
image = image.permute(1, 2, 3, 0)
invD = invD.permute(1, 2, 3, 0)


chi = torch.ifft(torch.fft(image, 3)*invD, 3)
chi = chi.numpy()
name_msk = '/Users/uqhsun8/Desktop/test_chi.nii'
clipped_msk = nib.Nifti1Image(chi, aff)
nib.save(clipped_msk, name_msk)
