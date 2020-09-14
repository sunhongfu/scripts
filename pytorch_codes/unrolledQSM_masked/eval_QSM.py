import torch
import torch.nn as nn
import numpy as np
import nibabel as nib
import scipy.io as scio
from model_QSM import unrolledQSM
from model_QSM import get_parameter_number


if __name__ == '__main__':
    with torch.no_grad():
        print('unrolledQSM')
        for orien in ['left', 'right', 'forward', 'backward', 'central', 'central_permute132', 'central_bigAngle', 'resized']:
            nibimage = nib.load(
                '/scratch/itee/uqhsun8/CommQSM/invivo/testing/renzo/renzo_' + orien + '_field.nii')
            image = nibimage.get_data()
            aff = nibimage.affine
            image = np.array(image)
            print('unrolledQSM')
            image = torch.from_numpy(image)
            print(image.size())
            image = image.float()
            image = torch.unsqueeze(image, 0)
            image = torch.cat([image, torch.zeros(image.shape)], 0)
            image = torch.unsqueeze(image, 0)

            nibimage = nib.load(
                '/scratch/itee/uqhsun8/CommQSM/invivo/testing/renzo/renzo_' + orien + '_D_shift.nii')
            D = nibimage.get_data()
            aff = nibimage.affine
            D = np.array(D)
            print('unrolledQSM')
            D = torch.from_numpy(D)
            print(D.size())
            D = D.float()
            D = torch.unsqueeze(D, 0)
            D = torch.cat([D, D], 0)
            D = torch.unsqueeze(D, 0)

            print('unrolledQSM')
            # load trained network
            net = unrolledQSM()
            net = nn.DataParallel(net)
            device = torch.device(
                "cuda:0" if torch.cuda.is_available() else "cpu")
            net.load_state_dict(torch.load(
                '/scratch/itee/uqhsun8/CommQSM/pytorch_codes/unrolledQSM_mask/unrolledQSM_mask.pth'))
            net.to(device)
            net.eval()
            print(net.state_dict)

            image = image.to(device)
            D = D.to(device)

            pred = net(torch.zeros(image.shape), image, D)
            print(pred.size())
            pred = torch.squeeze(pred, 0)
            # pred = torch.squeeze(pred, 0)
            print(get_parameter_number(net))
            pred = pred.to('cpu')
            pred = pred.numpy()
            pred = pred[0, :, :, :]

            name_msk = '/scratch/itee/uqhsun8/CommQSM/invivo/testing/unrolledQSM_mask/renzo_' + \
                orien + '_unrolledQSM_mask.nii'
            path = '/scratch/itee/uqhsun8/CommQSM/invivo/testing/unrolledQSM_mask/renzo_' + \
                orien + '_unrolledQSM_mask.mat'
            scio.savemat(path, {'PRED': pred})
            clipped_msk = nib.Nifti1Image(pred, aff)
            nib.save(clipped_msk, name_msk)
            print('end2')
