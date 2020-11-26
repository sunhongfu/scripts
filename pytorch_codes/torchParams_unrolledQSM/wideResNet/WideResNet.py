import torch.nn as nn
import torch

DROPOUT_RATE = 0.5
DEVICE = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")

def makeWideBlocks(blocks, num):
    seq = nn.Sequential()
    for i in range(num):
        seq.add_module('wBlock' + str(i), blocks())
    return seq


class WideResNet(nn.Module):

    def __init__(self):
        super(WideResNet,self).__init__()

        self.input = nn.Sequential(
            nn.Conv3d(1,32,3,stride=1,padding=1).cuda(),
            nn.ReLU(inplace=True).cuda()
        ).to(torch.float)
        self.wideResBlocks = makeWideBlocks(WideResBlock,8)

        self.output = nn.Sequential(
            nn.Conv3d(32, 32, 1, stride=1, padding=0, bias=False).cuda(),
            nn.ReLU(inplace=True).cuda(),
            nn.Conv3d(32, 32, 1, stride=1, padding=0, bias=False).cuda(),
            nn.ReLU(inplace=True).cuda(),
            nn.Conv3d(32, 1, 1, stride=1, padding=0, bias=False).cuda()
        )

    def forward(self, x):
        x = self.input(x)
        x = self.wideResBlocks(x)
        x = self.output(x)
        return x


class WideResBlock(nn.Module):

    def __init__(self, inChannel=32, outChannel=32, kSize=3):
        super(WideResBlock,self).__init__()

        self.convBlock = nn.Sequential(
            nn.Conv3d(inChannel, outChannel, kSize, stride=1, padding=1),
            nn.BatchNorm3d(outChannel),
            nn.ReLU(inplace=True)
        )

        self.dropout = nn.Dropout3d(p=DROPOUT_RATE)

        self.__conv2 = nn.Conv3d(inChannel, outChannel, kSize, stride=1, padding=1)
        self.__bn2 = nn.BatchNorm3d(outChannel)
        self.__Relu2 = nn.ReLU(inplace=True)

    def forward(self, x):
        res = x
        x = self.convBlock(x)
        x = self.dropout(x)
        x = self.__conv2(x)
        x = self.__bn2(x)
        x += res
        return self.__Relu2(x)
