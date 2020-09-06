'''
This source code is for unrolled network
Hyper-params:
- 3 iterations
- in each iteration, one U-Net one DC block
- inputs: 
subsampled image x (2, 240,240)
subsampled measurement k0 (2, 240, 240)
samping mask mask (2, 240, 240)

author: Xinwen Liu (xinwen.liu@uq.net.au)
'''
import torch
import torch.nn as nn

# Data consistency block:


def data_consistency(k, k0, mask):
    """
    this part need to be revised according to QSM's physics

    k    - reconstructed image in k-space
    k0   - initially sampled elements in k-space
    """
    out = (1 - mask) * k + mask * k0
    return out


class DataConsistencyInKspace(nn.Module):
    """ Create data consistency operator
    the data_consistency part needs to be revised according to QSM's physics

    """

    def __init__(self):
        super(DataConsistencyInKspace, self).__init__()

    def forward(self, *input, **kwargs):
        return self.perform(*input)

    def perform(self, x, k0, mask):
        """
        k    - reconstructed image in k-space
        k0   - sampled measurement in k-space
        mask - sampling mask
        """
        x = x.permute(0, 2, 3, 1)
        k0 = k0.permute(0, 2, 3, 1)
        mask = mask.permute(0, 2, 3, 1)

        k = torch.fft(x, 2)   # turn into k-space
        out = data_consistency(k, k0, mask)  # data consistency
        x_res = torch.ifft(out, 2)  # turn into image domain

        x_res = x_res.permute(0, 3, 1, 2)
        return x_res

# U-Net:


def res_block(in_channels, out_channels):
    return nn.Sequential(
        nn.Conv2d(in_channels, out_channels,
                  kernel_size=(3, 3), padding=(1, 1)),
        nn.BatchNorm2d(out_channels),
        nn.ReLU())


def down_sampling(channels):
    return nn.MaxPool2d(2)


def transpose_res_block(in_channels, out_channels):
    return nn.Sequential(
        nn.ConvTranspose2d(in_channels, out_channels,
                           kernel_size=(2, 2), stride=2),
        nn.BatchNorm2d(out_channels),
        nn.ReLU())


class unet(nn.Module):
    '''
            This is based on:
        Olaf Ronneberger et.al. U-net: Convolutional networks
        for biomedical image segmentation. In MICCAI 2015.
    '''

    def __init__(self):
        super().__init__()

        self.res1 = res_block(2, 64)
        self.res11 = res_block(64, 64)
        self.res2 = res_block(64, 128)
        self.res21 = res_block(128, 128)
        self.res3 = res_block(128, 256)
        self.res31 = res_block(256, 256)

        self.pool1 = down_sampling(64)
        self.pool2 = down_sampling(128)

        self.up1 = transpose_res_block(256, 128)
        self.up2 = res_block(128+128, 128)
        self.up3 = transpose_res_block(128, 64)
        self.up4 = res_block(64+64, 64)

        self.conv_last0 = nn.Conv2d(64, 2, 3, padding=(1, 1))
        self.conv_last1 = nn.Conv2d(2, 2, 1, padding=0)

    def forward(self, x):

        conv1 = self.res1(x)
        conv11 = self.res11(conv1)
        x = self.pool1(conv11)

        conv2 = self.res2(x)
        conv21 = self.res21(conv2)
        x = self.pool2(conv21)

        x = self.res3(x)

        x = self.up1(x)
        x = torch.cat([x, conv21], dim=1)
        x = self.up2(x)

        x = self.up3(x)
        x = torch.cat([x, conv11], dim=1)
        x = self.up4(x)

        x = self.conv_last0(x)
        out = self.conv_last1(x)

        return out

# construct unrolled network


class one_iteration(nn.Module):

    def __init__(self):
        super().__init__()
        self.dc = DataConsistencyInKspace()
        self.reg = unet()

    def forward(self, x, k0, mask):
        dc0 = self.dc(x, k0, mask)
        reg0 = self.reg(x)
        sum1 = x + dc0 + reg0
        return sum1


class unrolled_net(nn.Module):
    '''
    this is the unrolled network, inputs are:
    x: sub-sampled image
    k0: sampled k-space
    mask: sampling pattern
    The output and input images are 2 channels
    '''

    def __init__(self):
        super().__init__()
        self.one_iter1 = one_iteration()
        self.one_iter2 = one_iteration()
        self.one_iter3 = one_iteration()

    def forward(self, x, k0, mask):
        x = self.one_iter1(x, k0, mask)
        x = self.one_iter2(x, k0, mask)
        x = self.one_iter3(x, k0, mask)
        return x


if __name__ == '__main__':
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    net = unrolled_net().to(device)
