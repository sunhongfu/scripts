import torch
import torch.nn.functional as F
import nibabel as nib
import numpy as np
import scipy.io as scio


def get_3d_locations(d, h, w, device_):
    # torch.linspace Returns a one-dimensional tensor of steps equally spaced points between start and end
    # x, y, z: 0:1:63 for training;
    locations_x = torch.linspace(-w/2, w/2-1, w).view(1,
                                                      1, 1, w).to(device_).expand(1, d, h, w)
    locations_y = torch.linspace(-h/2, h/2-1, h).view(1,
                                                      1, h, 1).to(device_).expand(1, d, h, w)
    locations_z = torch.linspace(-d/2, d/2-1, d).view(1,
                                                      d, 1, 1).to(device_).expand(1, d, h, w)
    # generate 3D image locations, shape: (1, D, H, W, 3)
    locations_3d = torch.stack(
        [locations_x, locations_y, locations_z], dim=4).view(-1, 3, 1)
    return locations_3d


def rotate(input_tensor, rotation_matrix):
    # input_tensor: input data to be rotated;
    # shape: Nb * 1 * H * W * D
    # rotation_matrix: rotation matrix generated;
    # shape: Nb * 1 * 3 * 3
    device_ = input_tensor.device
    Nb, _, d, h, w = input_tensor.shape
    # input_tensor = input_tensor.unsqueeze(0)
    # get x,y,z indices of target 3d data
    locations_3d = get_3d_locations(d, h, w, device_)
    # rotate target positions to the source coordinate
    rotated_3d_positions = torch.matmul(rotation_matrix.view(
        Nb, 1, 3, 3).expand(Nb, d*h*w, 3, 3), locations_3d).view(Nb, d, h, w, 3)
    # shape: Nb * d * h * w, 3, 1
    rot_locs = torch.split(rotated_3d_positions,
                           split_size_or_sections=1, dim=4)
    # change the range of x,y,z locations to [-1,1]
    normalised_locs_x = (2.0*rot_locs[0])/(w)  # shape: Nb, d * h * w, 3, 1
    normalised_locs_y = (2.0*rot_locs[1])/(h)
    normalised_locs_z = (2.0*rot_locs[2])/(d)
    """
    # change the range of x,y,z locations to [-1,1]
    normalised_locs_x = (2.0*rot_locs[0] - (w-1))/(w-1)
    normalised_locs_y = (2.0*rot_locs[1] - (h-1))/(h-1)
    normalised_locs_z = (2.0*rot_locs[2] - (d-1))/(d-1)
    """
    grid = torch.stack([normalised_locs_x, normalised_locs_y,
                        normalised_locs_z], dim=4).view(Nb, d, h, w, 3)
    # here we use the destination voxel-positions and sample the input 3d data trilinearly
    rotated_signal = F.grid_sample(
        # input=input_tensor, grid=grid, mode='bilinear',  align_corners=True)
        input=input_tensor, grid=grid, mode='bilinear')
    return rotated_signal


# debugging codes before usage.
if __name__ == '__main__':
    nibimage = nib.load('lfs.nii')
    image = nibimage.get_fdata()
    image = np.array(image)

    nibRM = nib.load('rot_mat.nii')
    RM = nibRM.get_fdata()
    RM = np.array(RM)

    image = torch.from_numpy(image)
    RM = torch.from_numpy(RM)

    #image = image.unsqueeze(0)
    #image = image.unsqueeze(0)

    image = image.float()
    RM = RM.float()
    print(RM.shape)
    print(image.shape)

    data_test = image
    rot_mat = RM
    #data_test = torch.randn(3, 1, 64, 64, 64)
    #rot_mat = torch.randn(3, 1, 3,3)
    rot_signal = rotate(data_test, rot_mat)
    print(rot_signal.shape)

    pred_img = rot_signal.numpy()

    #path = 'Pred_chi_k.mat'
    #scio.savemat(path, {'PRED':pred_k})
    path = 'rotated_lfs.mat'
    scio.savemat(path, {'PRED': pred_img})
    print('end2')
