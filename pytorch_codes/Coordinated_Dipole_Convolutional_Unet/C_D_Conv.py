import torch
import torch.nn as nn

## advanced convolution to combine the field and the dipole kernels. 
## D: dipole kernels; x: input field maps. 
class C_D_Conv(nn.Module):
    def __init__(self, num_in, num_out):
        super(C_D_Conv, self).__init__()
        self.conv_kernel = nn.Conv3d(num_in, num_out - 4, 3, padding = 1)

    def forward(self, x, D, C):
        ## C: coordinates, size 3 * N^3
        ## D: diole kernel: size 1 * N^3
        x = torch.cat([x, D, C], dim = 1)  # concat input and D along the chanel dimension. 
        x = self.conv_kernel(x)
        return x, D, C
        
class C_D_ConvT(nn.Module):
    def __init__(self, num_in):
        super(C_D_ConvT, self).__init__()
        self.convT_kernel = nn.ConvTranspose3d(num_in, num_in, 2, stride = 2)

    def forward(self, x, D, C):
        x = torch.cat([x, D, C], dim = 1)  # concat input and D along the chanel dimension. 
        x = self.convT_kernel(x)
        return x

class C_D_CBlock(nn.Module):
    def __init__(self, num_in, num_out):
        super(C_D_CBlock, self).__init__()
        self.conv1 = C_D_Conv(num_in, num_out)
        self.bn1 = nn.BatchNorm3d(num_out - 4)
        self.relu1 = nn.ReLU(inplace = True)

    def forward(self, x, D, C):
        x, D, C = self.conv1(x, D, C)
        x = self.bn1(x)
        x = self.relu1(x)
        return x, D, C


class C_D_FinalConv(nn.Module):
    def __init__(self, num_inputs):
        super(C_D_FinalConv, self).__init__()
        self.conv_kernel = nn.Conv3d(num_inputs, 1, 1, stride = 1, padding = 0)

    def forward(self, x, D, C):
        x = torch.cat([x, D, C], dim = 1)  
        x = self.conv_kernel(x)
        return x