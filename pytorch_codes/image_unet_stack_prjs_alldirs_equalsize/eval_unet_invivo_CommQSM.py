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
        print('image_unet_stack_prjs_alldirs_equalsize')
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

            # generate mask based on field maps
            mask = np.not_equal(image, 0)
            mask = mask.astype(float)

            print('image_unet_stack_prjs_alldirs_equalsize')
            image = torch.from_numpy(image)
            print(image.size())
            image = image.float()

            # nibimage = nib.load(
            #     '/scratch/itee/uqhsun8/CommQSM/invivo/testing/renzo/renzo_' + orien + '_dipole.nii')
            # dipole = nibimage.get_data()
            # aff = nibimage.affine
            # dipole = np.array(dipole)
            # print('image_unet_stack_prjs_alldirs_equalsize')
            # dipole = torch.from_numpy(dipole)
            # print(dipole.size())
            # dipole = dipole.float()

            # size/shape of field
            prjs_elements = np.array([float(i) for i in z_prjs_dict[orien]])
            size_prjs = list(image.shape)
            size_prjs.append(prjs_elements.size)
            prjs = prjs_elements*np.ones(size_prjs)

            # prjs = prjs*np.expand_dims(mask, axis=3)

            prjs = torch.from_numpy(prjs)

            prjs = prjs.permute(3, 0, 1, 2)
            image = torch.unsqueeze(image, 0)

            field_prjs = torch.cat(
                [image.float(), prjs.float()], 0)

            field_prjs = torch.unsqueeze(field_prjs, 0)

            print('image_unet_stack_prjs_alldirs_equalsize')
            # load trained network
            octnet = ResNet(2)
            octnet = nn.DataParallel(octnet)
            device = torch.device(
                "cuda:0" if torch.cuda.is_available() else "cpu")
            octnet.load_state_dict(torch.load(
                '/scratch/itee/uqhsun8/CommQSM/pytorch_codes/image_unet_stack_prjs_alldirs_equalsize/image_unet_stack_prjs_alldirs_equalsize.pth'))
            octnet.to(device)
            octnet.eval()
            print(octnet.state_dict)
            ################ Evaluation ##################
            field_prjs = field_prjs.to(device)

            pred = octnet(field_prjs)
            print(pred.size())
            pred = torch.squeeze(pred, 0)
            pred = torch.squeeze(pred, 0)
            print(get_parameter_number(octnet))
            pred = pred.to('cpu')
            pred = pred.numpy()

            name_msk = '/scratch/itee/uqhsun8/CommQSM/invivo/testing/image_unet_stack_prjs_alldirs_equalsize/renzo_' + \
                orien + '_image_unet_stack_prjs_alldirs_equalsize.nii'
            path = '/scratch/itee/uqhsun8/CommQSM/invivo/testing/image_unet_stack_prjs_alldirs_equalsize/renzo_' + \
                orien + '_image_unet_stack_prjs_alldirs_equalsize.mat'
            scio.savemat(path, {'PRED': pred})
            clipped_msk = nib.Nifti1Image(pred, aff)
            nib.save(clipped_msk, name_msk)
            print('end2')
