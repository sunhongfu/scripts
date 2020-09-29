import torch
import numpy as np
import nibabel as nib
from Rot_Functions import rotate

if __name__ == '__main__':
    with torch.no_grad():
        for orien in ['left', 'right', 'forward', 'backward', 'central', 'central_permute132', 'central_bigAngle']:
            # load image
            nibimage = nib.load(
                'renzo/renzo_' + orien + '_field.nii')
            image = nibimage.get_data()
            aff = nibimage.affine
            image = np.array(image)
            image = torch.from_numpy(image)
            print(image.size())
            image = image.float()
            image = torch.unsqueeze(image, 0)
            image = torch.unsqueeze(image, 0)

            # load forward rotation matrix
            nibimage = nib.load(
                'renzo/renzo_' + orien + '_rotmat.nii')
            rotmat = nibimage.get_data()
            rotmat = np.array(rotmat)
            rotmat = torch.from_numpy(rotmat)
            print(rotmat.size())
            rotmat = rotmat.float()
            rotmat = torch.unsqueeze(rotmat, 0)
            rotmat = torch.unsqueeze(rotmat, 0)

            # load inverse rotation matrix
            nibimage = nib.load(
                'renzo/renzo_' + orien + '_invmat.nii')
            invmat = nibimage.get_data()
            invmat = np.array(invmat)
            invmat = torch.from_numpy(invmat)
            print(invmat.size())
            invmat = invmat.float()
            invmat = torch.unsqueeze(invmat, 0)
            invmat = torch.unsqueeze(invmat, 0)

            # (1) deepQSM without any rotation
            deepqsm = ???image???
            nibimage = nib.Nifti1Image(deepqsm, aff)
            nib.save(nibimage, 'renzo/renzo_' + orien + '_deepqsm.nii')
            # (2) QSMnet without any rotation
            qsmnet = ???image???
            nibimage = nib.Nifti1Image(qsmnet, aff)
            nib.save(nibimage, 'renzo/renzo_' + orien + '_qsmnet.nii')
            # (3) xQSM without any rotation
            xqsm = ???image???
            nibimage = nib.Nifti1Image(xqsm, aff)
            nib.save(nibimage, 'renzo/renzo_' + orien + '_xqsm.nii')

            # apply rotations
            image_rot = rotate(image, rotmat)
            # (4) deepQSM with forward and inverse rotations
            deepqsm_rot = ???image_rot???
            deepqsm_rot_inv = rotate(deepqsm_rot, invmat)
            nibimage = nib.Nifti1Image(deepqsm_rot_inv, aff)
            nib.save(nibimage, 'renzo/renzo_' + orien + '_deepqsm_rot_inv.nii')
            # (5) QSMnet with forward and inverse rotations
            qsmnet_rot = ???image_rot???
            qsmnet_rot_inv = rotate(qsmnet_rot, invmat)
            nibimage = nib.Nifti1Image(qsmnet_rot, aff)
            nib.save(nibimage, 'renzo/renzo_' + orien + '_qsmnet_rot.nii')
            # (6) xQSM with forward and inverse rotations
            xqsm_rot = ???image_rot???
            xqsm_rot_inv = rotate(xqsm_rot, invmat)
            nibimage = nib.Nifti1Image(xqsm_rot, aff)
            nib.save(nibimage, 'renzo/renzo_' + orien + '_xqsm_rot.nii')
