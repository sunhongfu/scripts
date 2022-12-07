import os
import torch
import torchvision
from PIL import Image
from matplotlib import pyplot as plt
from torch.utils.data import DataLoader
import numpy as np
import nibabel as nib

def plot_images(images):
    plt.figure(figsize=(32,32))
    plt.imshow()
    plt.show()

def save_images(images, path, **kwargs):
    # grid = torchvision.utils.make_grid(images, **kwargs)
    # ndarr = grid.permute(1,2,0).to('cpu').numpy()
    # im = Image.fromarray((ndarr* 255).astype(np.uint8))
    # # im = Image.fromarray(ndarr)
    # im.save(path)
    # save as nifti using nibabel
    print(images.shape)
    images = images.cpu().detach().numpy()
    images_cmp = images[:,0,:,:,] + 1j * images[:,1,:,:]
    images_cmp = np.expand_dims(images_cmp, 1)
    images_mag = np.abs(images_cmp)
    images_pha = np.angle(images_cmp)
    images = np.concatenate((images, images_mag, images_pha), 1)
    nib.save(nib.Nifti1Image(np.transpose(images,(2,3,1,0)), np.eye(4)), path + '.nii')

# def get_data(args):
#     transforms = torchvision.transforms.Compose([
#         torchvision.transforms.Resize(80),
#         torchvision.transforms.RandomResizedCrop(args.image_size, scale=(0.8, 1.0)),
#         torchvision.transforms.ToTensor(), # what does this do???
#         torchvision.transforms.Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5))
#     ])
#     dataset = torchvision.datasets.ImageFolder(args.dataset_path, transform=transforms)
#     dataloader = DataLoader(dataset, batch_size=args.batch_size, shuffle=True)
#     return dataloader

def loader(npy_file):
    # 2D slices: x, y, channels (full_img, under_img, full_k, under_k)
    complex_img = np.load(npy_file)
    # normalized each complex image
    complex_img_normed = complex_img/np.max(np.abs(complex_img[:,:,1]))
    full_img = np.stack((np.real(complex_img_normed[:,:,0]), np.imag(complex_img_normed[:,:,0])), axis=0)
    under_img = np.stack((np.real(complex_img_normed[:,:,1]), np.imag(complex_img_normed[:,:,1])), axis=0)
    return torch.from_numpy(full_img).float(), torch.from_numpy(under_img).float()
    # return (full_real, full_imag) and (under_real, under_imag)

def get_data(args):
    dataset = torchvision.datasets.DatasetFolder(args.dataset_path, loader=loader, extensions='npy')
    dataloader = DataLoader(dataset, batch_size=args.batch_size, shuffle=True)
    return dataloader

def setup_logging(run_name):
    os.makedirs("models", exist_ok=True)
    os.makedirs("results", exist_ok=True)
    os.makedirs(os.path.join("modules", run_name), exist_ok=True)
    os.makedirs(os.path.join("results", run_name), exist_ok=True)

