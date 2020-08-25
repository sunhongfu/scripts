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
        print('multiple_prjs_unet_alldirs_150k')
        z_prjs_file = 'z_prjs_testdata.txt'
        z_prjs_arr = [line.strip().split(" ") for line in open(z_prjs_file)]
        # convert z_prjs into a dic
        z_prjs_keys = [z_prjs_arr[i][0] for i in range(0, len(z_prjs_arr))]
        z_prjs_values = [z_prjs_arr[i][1:4] for i in range(0, len(z_prjs_arr))]
        z_prjs_dict = dict(zip(z_prjs_keys, z_prjs_values))

        for orien in ['left', 'right', 'forward', 'backward', 'central', 'central_permute132']:
            nibimage = nib.load(
                '/scratch/itee/uqhsun8/CommQSM/invivo/testing/renzo/renzo_' + orien + '_field.nii')
            image = nibimage.get_data()
            aff = nibimage.affine
            image = np.array(image)

            print('multiple_prjs_unet_alldirs_150k')
            image = torch.from_numpy(image)
            print(image.size())

            size_prjs = list(image.shape)

            image = torch.unsqueeze(image, 0)
            image = torch.unsqueeze(image, 0)
            image = image.float()

            # nibimage = nib.load(
            #     '/scratch/itee/uqhsun8/CommQSM/invivo/testing/renzo/renzo_' + orien + '_dipole.nii')
            # dipole = nibimage.get_data()
            # aff = nibimage.affine
            # dipole = np.array(dipole)
            # print('multiple_prjs_unet_alldirs_150k')
            # dipole = torch.from_numpy(dipole)
            # print(dipole.size())

            # dipole = torch.unsqueeze(dipole, 0)
            # dipole = torch.unsqueeze(dipole, 0)
            # dipole = dipole.float()

            # size/shape of field
            prjs_elements = np.array([float(i) for i in z_prjs_dict[orien]])
            size_prjs.append(prjs_elements.size)
            prjs = prjs_elements*np.ones(size_prjs)
            prjs = torch.from_numpy(prjs)
            prjs = prjs.permute(3, 0, 1, 2)
            prjs = torch.unsqueeze(prjs, 0)
            prjs = prjs.float()

            print('multiple_prjs_unet_alldirs_150k')
            # load trained network
            multiple_prjs_unet_alldirs_150k = Unet(2)
            multiple_prjs_unet_alldirs_150k = nn.DataParallel(
                multiple_prjs_unet_alldirs_150k)
            device = torch.device(
                "cuda:0" if torch.cuda.is_available() else "cpu")
            multiple_prjs_unet_alldirs_150k.load_state_dict(torch.load(
                '/scratch/itee/uqhsun8/CommQSM/pytorch_codes/multiple_prjs_unet_alldirs_150k/multiple_prjs_unet_alldirs_150k.pth'))
            multiple_prjs_unet_alldirs_150k.to(device)
            multiple_prjs_unet_alldirs_150k.eval()
            print(multiple_prjs_unet_alldirs_150k.state_dict)
            ################ Evaluation ##################
            image = image.to(device)
            prjs = prjs.to(device)
            pred = multiple_prjs_unet_alldirs_150k(image, prjs)
            print(pred.size())
            pred = torch.squeeze(pred, 0)
            pred = torch.squeeze(pred, 0)
            print(get_parameter_number(multiple_prjs_unet_alldirs_150k))
            pred = pred.to('cpu')
            pred = pred.numpy()

            name_msk = '/scratch/itee/uqhsun8/CommQSM/invivo/testing/multiple_prjs_unet_alldirs_150k/renzo_' + \
                orien + '_multiple_prjs_unet_alldirs_150k.nii'
            path = '/scratch/itee/uqhsun8/CommQSM/invivo/testing/multiple_prjs_unet_alldirs_150k/renzo_' + \
                orien + '_multiple_prjs_unet_alldirs_150k.mat'
            scio.savemat(path, {'PRED': pred})
            clipped_msk = nib.Nifti1Image(pred, aff)
            nib.save(clipped_msk, name_msk)
            print('end2')
