################ octnet evaluation ####################
############### predic ###################
import torch 
import torch.nn as nn
from yangMFOctnet_16 import *
import numpy as np
import nibabel as nib
from ResNet_yang_4l import *
import scipy.io as scio
##########################################

if __name__ == '__main__':
    with torch.no_grad():        
        print('OCT')   
        nibimage = nib.load('tfs_cropped.nii')
        image = nibimage.get_data() 
        aff = nibimage.affine
        image = np.array(image)
        print('OCT')   
        image = torch.from_numpy(image) 
        print(image.size())   

        image = torch.unsqueeze(image, 0)
        image = torch.unsqueeze(image, 0)
        image = image.float()

        print('OCT')
        ## load trained network 
        octnet = ResNet(3)
        octnet = nn.DataParallel(octnet)
        device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
        octnet.load_state_dict(torch.load('./UNET_48_Patch_333333333333333L_100EPO_31_Mar.pth'))
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

        name_msk = 'pred_cosmos0.6mm_100EPOUnet2L.nii'
        path = 'Pred_cosmos1mm_OCTUnet0.6L.mat'
        scio.savemat(path, {'PRED':pred})
        clipped_msk = nib.Nifti1Image(pred,aff)
        nib.save(clipped_msk, name_msk)
        print('end2')