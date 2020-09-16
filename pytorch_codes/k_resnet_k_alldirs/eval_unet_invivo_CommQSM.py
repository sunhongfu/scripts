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
        print('k_resnet_k_alldirs')
        for orien in ['left', 'right', 'forward', 'backward', 'central', 'central_permute132', 'central_bigAngle', 'resized']:
            nibimage = nib.load(
                '/scratch/itee/uqhsun8/CommQSM/invivo/testing/renzo/renzo_' + orien + '_field.nii')
            field = nibimage.get_data()
            aff = nibimage.affine
            field = np.array(field)
            print('k_resnet_k_alldirs')
            field = torch.from_numpy(field)
            print(field.size())
            field = field.float()

            field = torch.unsqueeze(field, 3)
            field = torch.cat([field, torch.zeros(field.shape)], 3)
            field_k = torch.fft(field, 3)

            field_k = field_k.permute(3, 0, 1, 2)

            print('k_resnet_k_alldirs')
            # load trained network
            octnet = ResNet(2)
            octnet = nn.DataParallel(octnet)
            device = torch.device(
                "cuda:0" if torch.cuda.is_available() else "cpu")
            octnet.load_state_dict(torch.load(
                '/scratch/itee/uqhsun8/CommQSM/pytorch_codes/k_resnet_k_alldirs/k_resnet_k_alldirs.pth'))
            octnet.to(device)
            octnet.eval()
            print(octnet.state_dict)
            ################ Evaluation ##################
            field_k = field_k.to(device)

            pred = octnet(field_k)
            print(pred.size())
            pred = torch.squeeze(pred, 0)

            pred = pred.permute(3, 0, 1, 2)

            pred = torch.fft(pred, 3)

            pred = pred[:, :, :, 0]

            print(get_parameter_number(octnet))
            pred = pred.to('cpu')
            pred = pred.numpy()

            name_msk = '/scratch/itee/uqhsun8/CommQSM/invivo/testing/k_resnet_k_alldirs/renzo_' + \
                orien + '_k_resnet_k_alldirs.nii'
            path = '/scratch/itee/uqhsun8/CommQSM/invivo/testing/k_resnet_k_alldirs/renzo_' + \
                orien + '_k_resnet_k_alldirs.mat'
            scio.savemat(path, {'PRED': pred})
            clipped_msk = nib.Nifti1Image(pred, aff)
            nib.save(clipped_msk, name_msk)
            print('end2')
