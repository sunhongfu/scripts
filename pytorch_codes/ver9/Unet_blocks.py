#################### ResNet Blocks ########################
## import defaults packages 
import torch
import torch.nn as nn

## learnable TKD layers. 
class TKD_layer(nn.Module):
    def __init__(self, th = 0.15):
        ## th: TKD threshold, default: 0.1 
        super(TKD_layer, self).__init__()
        self.th = nn.Parameter(th * torch.ones(1), requires_grad=True)

    def forward(self, x, D):
        ## inputs: x: field masp, D: unit dipole kernel. 
        sgns = torch.sign(D)
        D = D.abs()   ## |D(k)|
        ##D[D.abs() < self.th] = self.th  ## max(|D(k)|, th)
        D[D.abs() < self.th] = 0  ## max(|D(k)|, th)
        D = D * sgns     
        invD = 1 / D
        invD[D == 0] = 0
        x = x * invD
        return x

## basic blocks
class EncodingBlocks(nn.Module):
    def __init__(self, num_in, num_out):
        super(EncodingBlocks, self).__init__()
        self.EncodeConv = nn.Sequential(
            nn.Conv3d(num_in, num_out, 3, padding=1),
            nn.BatchNorm3d(num_out),
            nn.ReLU(inplace = True),
            nn.Conv3d(num_out, num_out, 3, padding=1),
            nn.BatchNorm3d(num_out),
            nn.ReLU(inplace = True)
        )

    def forward(self, x):
        x = self.EncodeConv(x)
        return x


class MidBlocks(nn.Module):
    def __init__(self, num_ch):
        super(MidBlocks, self).__init__()
        self.MidConv = nn.Sequential(
            nn.Conv3d(num_ch, 2 * num_ch, 3, padding=1),
            nn.BatchNorm3d(2 * num_ch),
            nn.ReLU(inplace = True),
            nn.Conv3d(2 * num_ch, num_ch, 3, padding=1),
            nn.BatchNorm3d(num_ch),
            nn.ReLU(inplace = True)
        )

    def forward(self, x):
        x = self.MidConv(x)
        return x


class DecodingBlocks(nn.Module):
    def __init__(self, num_in, num_out, bilinear=False):
        super(DecodingBlocks, self).__init__()
        if bilinear:
            self.up = nn.Sequential(
                nn.Upsample(scale_factor=2, mode='nearest'),
                nn.BatchNorm3d(num_in),
                nn.ReLU(inplace = True)
            )
        else:
            self.up = nn.Sequential(
                nn.ConvTranspose3d(num_in, num_in, 2, stride = 2),
                nn.BatchNorm3d(num_in),
                nn.ReLU(inplace = True)
            )
        self.DecodeConv = nn.Sequential(
            nn.Conv3d(2 * num_in, num_in, 3, padding=1),
            nn.BatchNorm3d(num_in),
            nn.ReLU(inplace = True),
            nn.Conv3d(num_in, num_out, 3, padding=1),
            nn.BatchNorm3d(num_out),
            nn.ReLU(inplace = True)
        )
          
    def forward(self, x1, x2):
        x1 = self.up(x1)
        x = torch.cat([x1, x2], dim = 1)
        x = self.DecodeConv(x)
        return x


if __name__ == '__main__':
    tkd_layer = TKD_layer(th = 0.1)
    print('tkd_layer: ', list(tkd_layer.parameters()))