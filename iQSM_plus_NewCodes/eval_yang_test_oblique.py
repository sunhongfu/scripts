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
 

    # correct = {'left':[-0.3544, -0.1724,0.9190], 
    #         'right':[0.2637, -0.1072, 0.9586], 
    #         'forward':[0, 0.2232, 0.9748], 
    #         'backward':[0, -0.3178, 0.9482],
    #         'central':[0, -0.1514, 0.9885],
    #         'central_permute132':[0, 0.9885, -0.1514],
    #         'central_bigAngle':np.array([np.sqrt(2)/2, 0 , np.sqrt(2)/2])}

    # axial001 = {'left':[0, 0, 1], 
    #         'right':[0, 0, 1], 
    #         'forward':[0, 0, 1], 
    #         'backward':[0, 0, 1],
    #         'central':[0, 0, 1],
    #         'central_permute132':[0, 0, 1],
    #         'central_bigAngle':[0, 0, 1]}

    # sagittal100 = {'left':[1, 0, 0], 
    #         'right':[1, 0, 0], 
    #         'forward':[1, 0, 0], 
    #         'backward':[1, 0, 0],
    #         'central':[1, 0, 0],
    #         'central_permute132':[1, 0, 0],
    #         'central_bigAngle':[1, 0, 0]}

    # coronal010 = {'left':[0, 1, 0], 
    #         'right':[0, 1, 0], 
    #         'forward':[0, 1, 0], 
    #         'backward':[0, 1, 0],
    #         'central':[0, 1, 0],
    #         'central_permute132':[0, 1, 0],
    #         'central_bigAngle':[0, 1, 0]}

    # wrong111 = {'left':[1, 1, 1], 
    #         'right':[1, 1, 1], 
    #         'forward':[1, 1, 1], 
    #         'backward':[1, 1, 1],
    #         'central':[1, 1, 1],
    #         'central_permute132':[1, 1, 1],
    #         'central_bigAngle':[1, 1, 1]}

    # wrong234 = {'left':[2,3,4], 
    #         'right':[2,3,4], 
    #         'forward':[2,3,4], 
    #         'backward':[2,3,4],
    #         'central':[2,3,4],
    #         'central_permute132':[2,3,4],
    #         'central_bigAngle':[2,3,4]}

    # wrongequal = {'left':[0.5774, 0.5774, 0.5774], 
    #         'right':[0.5774, 0.5774, 0.5774], 
    #         'forward':[0.5774, 0.5774, 0.5774], 
    #         'backward':[0.5774, 0.5774, 0.5774],
    #         'central':[0.5774, 0.5774, 0.5774],
    #         'central_permute132':[0.5774, 0.5774, 0.5774],
    #         'central_bigAngle':[0.5774, 0.5774, 0.5774]}

    # test_prjs = {'correct':correct, 'axial001':axial001, 'sagittal100':sagittal100, 'coronal010':coronal010, 'wrong111':wrong111, 'wrong234':wrong234, 'wrongequal':wrongequal}

    # for test_case in ['correct', 'axial001', 'sagittal100', 'coronal010', 'wrong111', 'wrong234', 'wrongequal']:

    with torch.no_grad():
        # print('unet')
        # for orien in ['left', 'right', 'forward', 'backward', 'central', 'central_permute132', 'central_bigAngle']:
        # # for orien in ['central_bigAngle']:
        # # for orien in ['central']:
        nibimage = nib.load(
            '/scratch/itee/uqhsun8/yang_test_data_oblique/lfs8.nii')
        image = nibimage.get_data()
        aff = nibimage.affine
        image = np.array(image)
        print('unet')
        image = torch.from_numpy(image)
        print(image.size())

        image = torch.unsqueeze(image, 0)
        image = torch.unsqueeze(image, 0)
        image = image.float()

        # test big angle
        # z_prjs = np.array([np.sqrt(2)/2, 0 , np.sqrt(2)/2])
        # z_prjs = np.array([0, 0, 1])
        z_prjs = np.array([0, np.sqrt(2)/2, np.sqrt(2)/2])
        z_prjs = torch.from_numpy(z_prjs)
        z_prjs = torch.unsqueeze(z_prjs, 0)
        z_prjs = z_prjs.float()

        print('unet')
        # load trained network
        octnet = ResNet(2)
        octnet = nn.DataParallel(octnet)
        device = torch.device(
            "cuda:0" if torch.cuda.is_available() else "cpu")
        octnet.load_state_dict(torch.load(
            '/scratch/itee/uqhsun8/CROSS_ATT_UNET_ORIG_ANGLES/models/mixed_unet_epoch200.pth', map_location=torch.device(device)))
        octnet.to(device)
        octnet.eval()
        print(octnet.state_dict)
        ################ Evaluation ##################
        image = image.to(device)
        z_prjs = z_prjs.to(device)
        pred = octnet(image, z_prjs)
        print(pred.size())
        pred = torch.squeeze(pred, 0)
        pred = torch.squeeze(pred, 0)
        print(get_parameter_number(octnet))
        pred = pred.to('cpu')
        pred = pred.numpy()

        name_msk = '/scratch/itee/uqhsun8/codes/pos_enc_unet_large/results/yang_test_oblique_ca.nii'
        path = '/scratch/itee/uqhsun8/codes/pos_enc_unet_large/results/yang_test_oblique.mat'
        os.makedirs('/scratch/itee/uqhsun8/codes/pos_enc_unet_large/results/', exist_ok=True)
        # scio.savemat(path, {'PRED': pred})
        clipped_msk = nib.Nifti1Image(pred, aff)
        nib.save(clipped_msk, name_msk)
        print('end2')