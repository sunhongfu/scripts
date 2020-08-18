################ CommQSM evaluation ####################
############### predic ###################
import torch
import torch.nn as nn
import numpy as np
import nibabel as nib
from ResNet_yang import *
import scipy.io as scio
##########################################

if __name__ == '__main__':
    with torch.no_grad():
        print('image_unet_stack_dipole')
        for orien in ['left', 'right', 'forward', 'backward', 'central', 'central_permute132']:
            nibimage = nib.load(
                '/scratch/itee/uqhsun8/CommQSM/invivo/testing/renzo/renzo_' + orien + '_field.nii')
            image = nibimage.get_data()
            aff = nibimage.affine
            image = np.array(image)
            print('image_unet_stack_dipole')
            image = torch.from_numpy(image)
            print(image.size())
            image = image.float()

            nibimage = nib.load(
                '/scratch/itee/uqhsun8/CommQSM/invivo/testing/renzo/renzo_' + orien + '_dipole.nii')
            dipole = nibimage.get_data()
            aff = nibimage.affine
            dipole = np.array(dipole)
            print('image_unet_stack_dipole')
            dipole = torch.from_numpy(dipole)
            print(dipole.size())
            dipole = dipole.float()

            field_dipole = torch.stack([image.float(), dipole.float()], 0)
            field_dipole = torch.unsqueeze(field_dipole, 0)

            print('image_unet_stack_dipole')
            # load trained network
            octnet = ResNet(2)
            octnet = nn.DataParallel(octnet)
            device = torch.device(
                "cuda:0" if torch.cuda.is_available() else "cpu")
            octnet.load_state_dict(torch.load(
                '/scratch/itee/uqhsun8/CommQSM/pytorch_codes/image_unet_stack_dipole/image_unet_stack_dipole.pth'))
            octnet.to(device)
            octnet.eval()
            print(octnet.state_dict)
            ################ Evaluation ##################
            image = image.to(device)
            dipole = dipole.to(device)

            pred = octnet(field_dipole)
            print(pred.size())
            pred = torch.squeeze(pred, 0)
            pred = torch.squeeze(pred, 0)
            print(get_parameter_number(octnet))
            pred = pred.to('cpu')
            pred = pred.numpy()

            name_msk = '/scratch/itee/uqhsun8/CommQSM/invivo/testing/image_unet_stack_dipole/renzo_' + \
                orien + '_image_unet_stack_dipole.nii'
            path = '/scratch/itee/uqhsun8/CommQSM/invivo/testing/image_unet_stack_dipole/renzo_' + \
                orien + '_image_unet_stack_dipole.mat'
            scio.savemat(path, {'PRED': pred})
            clipped_msk = nib.Nifti1Image(pred, aff)
            nib.save(clipped_msk, name_msk)
            print('end2')
