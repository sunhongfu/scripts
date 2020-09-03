################ CommQSM evaluation ####################
############### predic ###################
import torch
import torch.nn as nn
import numpy as np
import nibabel as nib
from D_Unet import *
import scipy.io as scio
##########################################

if __name__ == '__main__':
    with torch.no_grad():
        print('multiple_D_unet')
        for orien in ['left', 'right', 'forward', 'backward', 'central', 'central_permute132']:
            nibimage = nib.load(
                '/scratch/itee/uqhsun8/CommQSM/invivo/testing/renzo/renzo_' + orien + '_field.nii')
            image = nibimage.get_data()
            aff = nibimage.affine
            image = np.array(image)
            print('multiple_D_unet')
            image = torch.from_numpy(image)
            print(image.size())

            image = torch.unsqueeze(image, 0)
            image = torch.unsqueeze(image, 0)
            image = image.float()

            nibimage = nib.load(
                '/scratch/itee/uqhsun8/CommQSM/invivo/testing/renzo/renzo_' + orien + '_D.nii')
            dipole = nibimage.get_data()
            aff = nibimage.affine
            dipole = np.array(dipole)
            print('multiple_D_unet')
            dipole = torch.from_numpy(dipole)
            print(dipole.size())

            dipole = torch.unsqueeze(dipole, 0)
            dipole = torch.unsqueeze(dipole, 0)
            dipole = dipole.float()

            print('multiple_D_unet')
            # load trained network
            multiple_D_unet = Unet(2)
            multiple_D_unet = nn.DataParallel(multiple_D_unet)
            device = torch.device(
                "cuda:0" if torch.cuda.is_available() else "cpu")
            multiple_D_unet.load_state_dict(torch.load(
                '/scratch/itee/uqhsun8/CommQSM/pytorch_codes/multiple_D_unet/D_Unet_test.pth'))
            multiple_D_unet.to(device)
            multiple_D_unet.eval()
            print(multiple_D_unet.state_dict)
            ################ Evaluation ##################
            image = image.to(device)
            dipole = dipole.to(device)
            pred = multiple_D_unet(image, dipole)
            print(pred.size())
            pred = torch.squeeze(pred, 0)
            pred = torch.squeeze(pred, 0)
            print(get_parameter_number(multiple_D_unet))
            pred = pred.to('cpu')
            pred = pred.numpy()

            name_msk = '/scratch/itee/uqhsun8/CommQSM/invivo/testing/multiple_D_unet/renzo_' + \
                orien + '_multiple_D_unet.nii'
            path = '/scratch/itee/uqhsun8/CommQSM/invivo/testing/multiple_D_unet/renzo_' + \
                orien + '_multiple_D_unet.mat'
            scio.savemat(path, {'PRED': pred})
            clipped_msk = nib.Nifti1Image(pred, aff)
            nib.save(clipped_msk, name_msk)
            print('end2')
