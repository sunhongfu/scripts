import torch
import torch.nn as nn

# advanced convolution to combine the field and the dipole kernels.
# D: dipole kernels; x: input field maps.


class D_Conv(nn.Module):
    def __init__(self, num_in, num_out):
        super(D_Conv, self).__init__()
        # self.conv_kernel = nn.Conv3d(num_in, num_out - 1, 3, padding=1)
        self.conv_kernel = nn.Conv3d(
            num_in, num_out - 3, 3, padding=1)  # HONGFU

    def forward(self, x, D):
        # concat input and D along the chanel dimension.
        x = torch.cat([x, D], dim=1)
        x = self.conv_kernel(x)
        return x, D


class D_ConvT(nn.Module):
    def __init__(self, num_in):
        super(D_ConvT, self).__init__()
        self.convT_kernel = nn.ConvTranspose3d(num_in, num_in, 2, stride=2)

    def forward(self, x, D):
        # concat input and D along the chanel dimension.
        x = torch.cat([x, D], dim=1)
        x = self.convT_kernel(x)
        return x


class D_CBlock(nn.Module):
    def __init__(self, num_in, num_out):
        super(D_CBlock, self).__init__()
        self.conv1 = D_Conv(num_in, num_out)
        # self.bn1 = nn.BatchNorm3d(num_out - 1)
        self.bn1 = nn.BatchNorm3d(num_out - 3)  # HONGFU
        self.relu1 = nn.ReLU(inplace=True)

    def forward(self, x, D):
        x, D = self.conv1(x, D)
        x = self.bn1(x)
        x = self.relu1(x)
        return x, D


class D_FinalConv(nn.Module):
    def __init__(self, num_inputs):
        super(D_FinalConv, self).__init__()
        self.conv_kernel = nn.Conv3d(num_inputs, 1, 1, stride=1, padding=0)

    def forward(self, x, D):
        # concat input and D along the chanel dimension.
        x = torch.cat([x, D], dim=1)
        x = self.conv_kernel(x)
        return x
