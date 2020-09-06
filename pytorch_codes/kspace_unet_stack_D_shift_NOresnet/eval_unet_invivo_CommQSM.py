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
        print('kspace_unet_stack_D_shift_NOresnet')
        for orien in ['left', 'right', 'forward', 'backward', 'central']:
            nibimage = nib.load(
                '/scratch/itee/uqhsun8/CommQSM/invivo/testing/renzo/renzo_' + orien + '_field_kspace_shift_real.nii')
            real_image = nibimage.get_data()
            aff = nibimage.affine
            real_image = np.array(real_image)
            print('kspace_unet_stack_D_shift_NOresnet')
            real_image = torch.from_numpy(real_image)
            print(real_image.size())
            real_image = real_image.float()

            nibimage = nib.load(
                '/scratch/itee/uqhsun8/CommQSM/invivo/testing/renzo/renzo_' + orien + '_field_kspace_shift_imag.nii')
            imag_image = nibimage.get_data()
            aff = nibimage.affine
            imag_image = np.array(imag_image)
            print('kspace_unet_stack_D_shift_NOresnet')
            imag_image = torch.from_numpy(imag_image)
            print(imag_image.size())
            imag_image = imag_image.float()

            nibimage = nib.load(
                '/scratch/itee/uqhsun8/CommQSM/invivo/testing/renzo/renzo_' + orien + '_D_shift.nii')
            D = nibimage.get_data()
            aff = nibimage.affine
            D = np.array(D)
            print('kspace_unet_stack_D_shift_NOresnet')
            D = torch.from_numpy(D)
            print(D.size())
            D = D.float()

            real_imag_D = torch.stack(
                [real_image.float(), imag_image.float(), D.float()], 0)

            real_imag_D = torch.unsqueeze(real_imag_D, 0)

            print('kspace_unet_stack_D_shift_NOresnet')
            # load trained network
            octnet = ResNet(2)
            octnet = nn.DataParallel(octnet)
            device = torch.device(
                "cuda:0" if torch.cuda.is_available() else "cpu")
            octnet.load_state_dict(torch.load(
                '/scratch/itee/uqhsun8/CommQSM/pytorch_codes/kspace_unet_stack_D_shift_NOresnet/kspace_unet_stack_D_shift_NOresnet.pth'))
            octnet.to(device)
            octnet.eval()
            print(octnet.state_dict)
            ################ Evaluation ##################
            real_imag_D = real_imag_D.to(device)

            pred = octnet(real_imag_D)
            print(pred.size())
            pred = torch.squeeze(pred, 0)

            pred = pred[0, :, :, :]

            print(get_parameter_number(octnet))
            pred = pred.to('cpu')
            pred = pred.numpy()

            name_msk = '/scratch/itee/uqhsun8/CommQSM/invivo/testing/kspace_unet_stack_D_shift_NOresnet/renzo_' + \
                orien + '_kspace_unet_stack_D_shift_NOresnet.nii'
            path = '/scratch/itee/uqhsun8/CommQSM/invivo/testing/kspace_unet_stack_D_shift_NOresnet/renzo_' + \
                orien + '_kspace_unet_stack_D_shift_NOresnet.mat'
            scio.savemat(path, {'PRED': pred})
            clipped_msk = nib.Nifti1Image(pred, aff)
            nib.save(clipped_msk, name_msk)
            print('end2')
