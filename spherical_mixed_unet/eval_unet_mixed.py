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
    
    test_prjs = {'left':[-0.3544, -0.1724,0.9190], 
            'right':[0.2637, -0.1072, 0.9586], 
            'forward':[0, 0.2232, 0.9748], 
            'backward':[0, -0.3178, 0.9482],
            'central':[0, -0.1514, 0.9885],
            'central_permute132':[0, 0.9885, -0.1514],
            'central_bigAngle':np.array([np.sqrt(2)/2, 0 , np.sqrt(2)/2])}

    with torch.no_grad():
        print('unet')
        for orien in ['left', 'right', 'forward', 'backward', 'central', 'central_permute132', 'central_bigAngle']:
        # for orien in ['central_bigAngle']:
        # for orien in ['central']:
            nibimage = nib.load(
                '/scratch/itee/uqhsun8/obliqueQSM/invivo/testing/renzo/renzo_' + orien + '_field.nii')
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
            z_prjs = np.array(test_prjs[orien])
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
                '/clusterdata/uqhsun8/codes/POS_ENC_UNET/models/mixed_unet_epoch200.pth', map_location=torch.device(device)))
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

            name_msk = '/clusterdata/uqhsun8/codes/POS_ENC_UNET/results/renzo_' + \
                orien + '_unet_mixed_alldirs.nii'
            path = '/clusterdata/uqhsun8/codes/POS_ENC_UNET/results/renzo_' + \
                orien + '_unet_mixed_alldirs.mat'
            os.makedirs('/clusterdata/uqhsun8/codes/POS_ENC_UNET/results', exist_ok=True)
            scio.savemat(path, {'PRED': pred})
            clipped_msk = nib.Nifti1Image(pred, aff)
            nib.save(clipped_msk, name_msk)
            print('end2')
