import torch
import torch.nn as nn
import numpy as np
import nibabel as nib
from CasNet2 import *
import scipy.io as scio


if __name__ == '__main__':
    with torch.no_grad():
        print('casnet2_mixed_alldirs')
        for orien in ['left', 'right', 'forward', 'backward', 'central', 'central_permute132', 'central_bigAngle']:
            nibimage = nib.load(
                '/scratch/itee/uqhsun8/CommQSM/invivo/testing/renzo/renzo_' + orien + '_field.nii')
            image = nibimage.get_data()
            aff = nibimage.affine
            image = np.array(image)
            print('casnet2_mixed_alldirs')
            image = torch.from_numpy(image)
            print(image.size())
            image = image.float()
            image = torch.unsqueeze(image, 0)
            image = torch.unsqueeze(image, 0)

            nibimage = nib.load(
                '/scratch/itee/uqhsun8/CommQSM/invivo/testing/renzo/renzo_' + orien + '_rotmat.nii')
            rotmat = nibimage.get_data()
            aff = nibimage.affine
            rotmat = np.array(rotmat)
            print('casnet2_mixed_alldirs')
            rotmat = torch.from_numpy(rotmat)
            print(rotmat.size())
            rotmat = rotmat.float()
            rotmat = torch.unsqueeze(rotmat, 0)
            rotmat = torch.unsqueeze(rotmat, 0)

            nibimage = nib.load(
                '/scratch/itee/uqhsun8/CommQSM/invivo/testing/renzo/renzo_' + orien + '_invmat.nii')
            invmat = nibimage.get_data()
            aff = nibimage.affine
            invmat = np.array(invmat)
            print('casnet2_mixed_alldirs')
            invmat = torch.from_numpy(invmat)
            print(invmat.size())
            invmat = invmat.float()
            invmat = torch.unsqueeze(invmat, 0)
            invmat = torch.unsqueeze(invmat, 0)

            print('casnet2_mixed_alldirs')
            # load trained network
            net = CasNet()
            net = nn.DataParallel(net)
            device = torch.device(
                "cuda:0" if torch.cuda.is_available() else "cpu")
            net.load_state_dict(torch.load(
                '/scratch/itee/uqhsun8/CommQSM/pytorch_codes/casnet2_mixed_alldirs/casnet2_mixed_alldirs.pth'))
            net.to(device)
            net.eval()
            print(net.state_dict)

            image = image.to(device)
            rotmat = rotmat.to(device)
            invmat = invmat.to(device)

            pred = net(image, rotmat, invmat)
            print(pred.size())
            pred = torch.squeeze(pred, 0)
            pred = torch.squeeze(pred, 0)
            print(get_parameter_number(net))
            pred = pred.to('cpu')
            pred = pred.numpy()

            name_msk = '/scratch/itee/uqhsun8/CommQSM/invivo/testing/casnet2_mixed_alldirs/renzo_' + \
                orien + '_casnet2_mixed_alldirs.nii'
            path = '/scratch/itee/uqhsun8/CommQSM/invivo/testing/casnet2_mixed_alldirs/renzo_' + \
                orien + '_casnet2_mixed_alldirs.mat'
            scio.savemat(path, {'PRED': pred})
            clipped_msk = nib.Nifti1Image(pred, aff)
            nib.save(clipped_msk, name_msk)
            print('end2')
