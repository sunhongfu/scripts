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
        print('multiple_dipole_unet')
        # for orien in ['left', 'right', 'forward', 'backward', 'central', 'central_permute132']:
        for orien in ['central_bigAngle']:
            nibimage = nib.load(
                '/scratch/itee/uqhsun8/CommQSM/invivo/testing/renzo/renzo_' + orien + '_field.nii')
            image = nibimage.get_data()
            aff = nibimage.affine
            image = np.array(image)
            print('multiple_dipole_unet')
            image = torch.from_numpy(image)
            print(image.size())

            image = torch.unsqueeze(image, 0)
            image = torch.unsqueeze(image, 0)
            image = image.float()

            nibimage = nib.load(
                '/scratch/itee/uqhsun8/CommQSM/invivo/testing/renzo/renzo_' + orien + '_dipole.nii')
            dipole = nibimage.get_data()
            aff = nibimage.affine
            dipole = np.array(dipole)
            print('multiple_dipole_unet')
            dipole = torch.from_numpy(dipole)
            print(dipole.size())

            dipole = torch.unsqueeze(dipole, 0)
            dipole = torch.unsqueeze(dipole, 0)
            dipole = dipole.float()

            print('multiple_dipole_unet')
            # load trained network
            multiple_dipole_unet = Unet(2)
            multiple_dipole_unet = nn.DataParallel(multiple_dipole_unet)
            device = torch.device(
                "cuda:0" if torch.cuda.is_available() else "cpu")
            multiple_dipole_unet.load_state_dict(torch.load(
                '/scratch/itee/uqhsun8/CommQSM/pytorch_codes/multiple_dipole_unet/multiple_dipole_unet.pth'))
            multiple_dipole_unet.to(device)
            multiple_dipole_unet.eval()
            print(multiple_dipole_unet.state_dict)
            ################ Evaluation ##################
            image = image.to(device)
            dipole = dipole.to(device)
            pred = multiple_dipole_unet(image, dipole)
            print(pred.size())
            pred = torch.squeeze(pred, 0)
            pred = torch.squeeze(pred, 0)
            print(get_parameter_number(multiple_dipole_unet))
            pred = pred.to('cpu')
            pred = pred.numpy()

            name_msk = '/scratch/itee/uqhsun8/CommQSM/invivo/testing/multiple_dipole_unet/renzo_' + \
                orien + '_multiple_dipole_unet.nii'
            path = '/scratch/itee/uqhsun8/CommQSM/invivo/testing/multiple_dipole_unet/renzo_' + \
                orien + '_multiple_dipole_unet.mat'
            scio.savemat(path, {'PRED': pred})
            clipped_msk = nib.Nifti1Image(pred, aff)
            nib.save(clipped_msk, name_msk)
            print('end2')
