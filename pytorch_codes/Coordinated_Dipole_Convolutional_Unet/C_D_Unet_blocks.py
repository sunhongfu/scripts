from C_D_Conv import * 
import torch.nn.functional  as F


## basic blocks
class EncodingBlocks(nn.Module):
    def __init__(self, num_in, num_out):
        super(EncodingBlocks, self).__init__()
        self.conv_block1 = C_D_CBlock(num_in, num_out)
        self.conv_block2 = C_D_CBlock(num_out, num_out)

    def forward(self, x, D, C):
        x, D, C = self.conv_block1(x, D, C)
        x, D, C = self.conv_block2(x, D, C)
        return x, D, C


class MidBlocks(nn.Module):
    def __init__(self, num_ch):
        super(MidBlocks, self).__init__()
        self.conv_block1 = C_D_CBlock(num_ch, 2 * num_ch)
        self.conv_block2 = C_D_CBlock(2 * num_ch, num_ch)

    def forward(self, x, D, C):
        x, D, C = self.conv_block1(x, D, C)
        x, D, C = self.conv_block2(x, D, C)
        return x, D, C


class DecodingBlocks(nn.Module):
    def __init__(self, num_in, num_out, bilinear=False):
        super(DecodingBlocks, self).__init__()
        if bilinear:
            pass  
        else:
            self.up = C_D_ConvT(num_in)
            self.bn_up= nn.BatchNorm3d(num_in)
            self.relu_up = nn.ReLU(inplace = True)
        self.conv_block1 = C_D_CBlock(2 * num_in, num_in)
        self.conv_block2 = C_D_CBlock(num_in, num_out)           

    def forward(self, x1, x2, D1, D2, C1, C2):
        x1 = self.up(x1, D1, C1)
        x1 = self.bn_up(x1)
        x1 = self.relu_up(x1)
        x = torch.cat([x1, x2], dim = 1)
        x, D, C = self.conv_block1(x, D2, C2)
        x, D, C = self.conv_block2(x, D, C)
        return x, D, C



