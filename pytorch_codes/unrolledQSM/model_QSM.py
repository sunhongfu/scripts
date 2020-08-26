"""
This source code is for unrolled QSM
Hyper-params:
- 3 iterations
- in each iteration, one U-Net one DC block
- inputs:
chi
phi
D

Authors:
Hongfu Sun (hongfu.sun@uq.edu.au)
Xinwen Liu (xinwen.liu@uq.net.au)
"""
import torch
import torch.nn as nn


# Data consistency block:

class DataConsistency(nn.Module):
    """
    Create data consistency operator
    DC(chi, phi, D) = f*D*D*F*chi - f*D*F*phi
    """

    def __init__(self):
        super(DataConsistency, self).__init__()

    def forward(self, chi, phi, D):
        """
        f - inverse FFT
        D - dipole kernel in kspace
        chi - susceptibility
        phi - field/phase
        input size of D,chi,phi: [batch, channel, x, y, z]
        torch.ifft and torch.fft take [batch, x, y, z, channel]
        """

        # convert to two channels for complex signal
        chi = chi.permute(0, 2, 3, 4, 1)
        phi = phi.permute(0, 2, 3, 4, 1)
        D = D.permute(0, 2, 3, 4, 1)

        DC = torch.ifft(D*D*torch.fft(chi, 3), 3) - \
            torch.ifft(D*torch.fft(phi, 3), 3)

        DC = DC.permute(0, 4, 1, 2, 3)

        return DC


# U-Net:

def res_block(in_channels, out_channels):
    return nn.Sequential(
        nn.Conv3d(in_channels, out_channels, 3, padding=1),
        nn.BatchNorm3d(out_channels),
        nn.ReLU())


def down_sampling(channels):
    return nn.MaxPool3d(2)


def transpose_res_block(in_channels, out_channels):
    return nn.Sequential(
        nn.ConvTranspose3d(in_channels, out_channels, 2, stride=2),
        nn.BatchNorm3d(out_channels),
        nn.ReLU())


class unet(nn.Module):
    """
    This is based on:
    Olaf Ronneberger et.al. U-net: Convolutional networks
    for biomedical image segmentation. In MICCAI 2015.
    """

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

        self.conv_last0 = nn.Conv3d(64, 2, 3, padding=1)
        self.conv_last1 = nn.Conv3d(2, 2, 1, padding=0)

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

    """
    x_t = x_{t-1} - alpha_t * DC - lambda * alpha_t * REG
    alpha_t to be learned from a 1*1 conv
    lambda * alpha_t to be learned through CNN in REG
    """

    def __init__(self):
        super().__init__()
        self.dc = DataConsistency()
        self.reg = unet()
        self.conv_scale = nn.Conv3d(2, 2, 1, padding=0)

    def forward(self, x, phi, D):
        dc0 = self.dc(x, phi, D)
        dc0 = self.conv_scale(dc0)
        reg0 = self.reg(x)
        sum1 = x + dc0 + reg0
        return sum1


class unrolledQSM(nn.Module):
    """
    this is the unrolled network, inputs are:
    x: sub-sampled image
    k0: sampled k-space
    mask: sampling pattern
    The output and input images are 2 channels
    """

    def __init__(self):
        super().__init__()
        self.one_iter1 = one_iteration()
        self.one_iter2 = one_iteration()
        self.one_iter3 = one_iteration()

    def forward(self, x, phi, D):
        x = self.one_iter1(x, phi, D)
        x = self.one_iter2(x, phi, D)
        x = self.one_iter3(x, phi, D)
        return x


def weights_init(m):
    if isinstance(m, nn.Conv3d):
        nn.init.normal_(m.weight, mean=0.0, std=1e-2)
        nn.init.zeros_(m.bias)
    if isinstance(m, nn.ConvTranspose3d):
        nn.init.normal_(m.weight, mean=0, std=1e-2)
        nn.init.zeros_(m.bias)
    if isinstance(m, nn.BatchNorm3d):
        nn.init.ones_(m.weight)
        nn.init.zeros_(m.bias)


def get_parameter_number(net):
    total_num = sum(p.numel() for p in net.parameters())
    trainable_num = sum(p.numel() for p in net.parameters() if p.requires_grad)
    return {'Total': total_num, 'Trainable': trainable_num}


if __name__ == '__main__':
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    net = unrolledQSM().to(device)

    net.apply(weights_init)
    a = net.state_dict
    print(a)
    print(get_parameter_number(net))
    chi = torch.randn(1, 2, 48, 48, 48, dtype=torch.float)
    phi = torch.randn(1, 2, 48, 48, 48, dtype=torch.float)
    D = torch.randn(1, 2, 48, 48, 48, dtype=torch.float)

    print('input' + str(chi.size()))
    print(chi.dtype)
    y = net(chi, phi, D)
    print('output'+str(y.size()))
