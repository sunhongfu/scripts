from C_D_Conv import * 
import torch.nn.functional  as F


## noise adding layer; 
class NoiseAdding(nn.Module):
    def __init__(self, Prob):
        super(NoiseAdding, self).__init__()
        self.Prob = Prob
        self.SNRs = torch.tensor([40, 20, 10, 5])

    def forward(self, x):
        out = x
        if self.training:
            print('Training')
            tmp = torch.rand(1)
            if tmp > self.Prob:
                idx = torch.randint(4, (1,1))
                tmp_SNR = self.SNRs[idx]
                out = AddNoise(x, tmp_SNR)
        return out

def AddNoise(ins, SNR):
    sigPower = SigPower(ins)
    noisePower = sigPower / SNR
    print("hello")
    noise = torch.sqrt(noisePower) * torch.randn(ins.size())
    mask = ins != 0
    return (ins + noise) * mask

def SigPower(ins):
    ll = torch.numel(ins)
    tmp1 = torch.sum(ins ** 2)
    return torch.div(tmp1, ll)


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


#################### For Code Test ##################################
## before running the training codes, verify the network architecture. 
if __name__ == '__main__':
    i = 1
    tmp = 0
    while i < 100:
        NoiseLayer = NoiseAdding(0)
        x = torch.randn(1,2,48,48,48, dtype=torch.float)
        y = NoiseLayer(x)
        z = y - x
        print(SigPower(x) / SigPower(z))
        tmp = tmp + SigPower(x) / SigPower(z)
        i = i + 1
    print(tmp / 100)


