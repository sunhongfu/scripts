import os
import torch
import torchvision
from PIL import Image
from matplotlib import pyplot as plt
from torch.utils.data import DataLoader
import numpy as np
import nibabel as nib
from torchvision.datasets import VisionDataset
import random

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
    # 2D slices: 256 x 256
    complex_img = np.load(npy_file)
    # normalized each complex image
    complex_img_normed = complex_img/np.max(np.abs(complex_img))
    complex_img_normed_dual_channels = np.stack((np.real(complex_img_normed), np.imag(complex_img_normed)), axis=0)

    # load in the fully-sampled image, then undersample it randomly
    # also try to include cases with no undersample condition, to use the guidance free approach, maybe in future
    # for now, do conditional but mixed undersampling patterns (and acceleration rates)

    complex_img_undersampled = under_sample(complex_img)
    complex_img_undersampled_normed = complex_img_undersampled/np.max(np.abs(complex_img_undersampled))
    complex_img_undersampled_normed_dual_channels = np.stack((np.real(complex_img_undersampled_normed), np.imag(complex_img_undersampled_normed)), axis=0)

    return torch.from_numpy(complex_img_normed_dual_channels).float(), torch.from_numpy(complex_img_undersampled_normed_dual_channels).float()


def under_sample(full_img):
    # convert to kspace
    full_k = np.fft.ifftshift(np.fft.ifft2(np.fft.ifftshift(full_img)))
    # generate a random k-space undersampling mask
    k_mask = get_cartesian_mask(256, n_keep=random.randint(16, 128)).numpy()
    # perform masking and converting back to image space (zero-filling results)
    under_img = np.fft.fftshift(np.fft.fft2(np.fft.fftshift(full_k * k_mask)))
    return under_img


def get_cartesian_mask(size, n_keep=30):
    # shape [Tuple]: (H, W)
    center_fraction = n_keep / 1000
    acceleration = size / n_keep

    num_rows, num_cols = size, size
    num_low_freqs = int(round(num_cols * center_fraction))

    # create the mask
    mask = torch.zeros((num_rows, num_cols), dtype=torch.float32)
    pad = (num_cols - num_low_freqs + 1) // 2
    mask[:, pad: pad + num_low_freqs] = True

    # determine acceleration rate by adjusting for the number of low frequencies
    adjusted_accel = (acceleration * (num_low_freqs - num_cols)) / (
        num_low_freqs * acceleration - num_cols
    )

    offset = round(adjusted_accel) // 2

    accel_samples = torch.arange(offset, num_cols - 1, adjusted_accel)
    accel_samples = torch.round(accel_samples).to(torch.long)
    mask[:, accel_samples] = True

    # print("====>>>>> acc: %.5f, adjust: %.5f" % (acceleration, adjusted_accel))
    return mask


def get_data(args):
    # dataset = torchvision.datasets.DatasetFolder(args.dataset_path, loader=loader, extensions='npy')
    dataset = RandomDataset(args.dataset_path, args.num_samples, loader=loader, extensions='npy')
    dataloader = DataLoader(dataset, batch_size=args.batch_size, shuffle=True)
    return dataloader

def setup_logging(run_name):
    os.makedirs("models", exist_ok=True)
    os.makedirs("results", exist_ok=True)
    os.makedirs(os.patorch.join("models", run_name), exist_ok=True)
    os.makedirs(os.path.join("results", run_name), exist_ok=True)



class RandomDataset(VisionDataset):
    def __init__(self, root, num_samples, loader, extensions='.npy'):
        super().__init__(root, transform=None, target_transform=None)
        self.loader = loader
        self.extensions = extensions
        self.samples = self._find_samples()
        self.num_samples = min(num_samples, len(self.samples))
        self.selected_indices = random.sample(range(len(self.samples)), self.num_samples)

    def _find_samples(self):
        samples = []
        for dirpath, _, filenames in os.walk(self.root):
            for filename in filenames:
                if filename.endswith(self.extensions):
                    samples.append(os.path.join(dirpath, filename))
        return samples

    def __getitem__(self, index):
        selected_index = self.selected_indices[index]
        filename = self.samples[selected_index]
        data = self.loader(filename)
        return data

    def __len__(self):
        return self.num_samples
    


if __name__ == "__main__":
    loader('/Users/uqhsun8/Desktop/echo_01_slice_084.npy')