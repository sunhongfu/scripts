################ CommQSM evaluation ####################
############### predic ###################
import torch
import torch.nn as nn
import numpy as np
import nibabel as nib
from ResNet_yang import *
import scipy.io as scio
import os
##########################################

if __name__ == '__main__':
    os.makedirs(
        '/scratch/itee/uqhsun8/CommQSM/invivo/testing/unetTFI', exist_ok=True)
    with torch.no_grad():
        print('unetTFI')
        for orien in ['left', 'right', 'forward', 'backward', 'central', 'central_permute132', 'central_bigAngle', 'resized']:
            nibimage = nib.load(
                '/scratch/itee/uqhsun8/CommQSM/invivo/testing/renzo/renzo_' + orien + '_field.nii')
            image = nibimage.get_data()
            aff = nibimage.affine
            image = np.array(image)
            print('unet')
            image = torch.from_numpy(image)
            print(image.size())

            image = torch.unsqueeze(image, 0)
            image = torch.unsqueeze(image, 0)
            image = image.float()

            print('unet')
            # load trained network
            octnet = ResNet(2)
            octnet = nn.DataParallel(octnet)
            device = torch.device(
                "cuda:0" if torch.cuda.is_available() else "cpu")
            octnet.load_state_dict(torch.load(
                '/scratch/itee/uqhsun8/CommQSM/pytorch_codes/unetTFI/unetTFI.pth'))
            octnet.to(device)
            octnet.eval()
            print(octnet.state_dict)
            ################ Evaluation ##################
            image = image.to(device)
            pred = octnet(image)
            print(pred.size())
            pred = torch.squeeze(pred, 0)
            pred = torch.squeeze(pred, 0)
            print(get_parameter_number(octnet))
            pred = pred.to('cpu')
            pred = pred.numpy()

            name_msk = '/scratch/itee/uqhsun8/CommQSM/invivo/testing/unetTFI/renzo_' + \
                orien + '_unetTFI.nii'
            path = '/scratch/itee/uqhsun8/CommQSM/invivo/testing/unetTFI/renzo_' + \
                orien + '_unetTFI.mat'
            scio.savemat(path, {'PRED': pred})
            clipped_msk = nib.Nifti1Image(pred, aff)
            nib.save(clipped_msk, name_msk)
            print('end2')
