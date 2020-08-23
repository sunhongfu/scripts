import torch 
import torch.nn as nn
import torch.nn.functional as F


class DeepResNet(nn.Module):
    def __init__(self, num_in, num_out, num_Ch = 16, HG_depth = 5):
        super(DeepResNet, self).__init__()
        self.input_layer = nn.Sequential(
            nn.Conv3d(num_in, num_Ch, 3, padding=1),
            nn.BatchNorm3d(num_Ch),
            nn.ReLU(inplace = True),
        )
        
        self.HG_depth = HG_depth
        self.MidLayers = []

        temp = list(range(1, HG_depth + 1))

        for encodingLayer in temp:
            self.MidLayers.append(HG_block(num_Ch))
            
        self.MidLayers = nn.ModuleList(self.MidLayers)

        self.output_layer = nn.Conv3d(num_Ch, num_out, 1, stride = 1, padding = 0)

    def forward(self, x):
        INPUT = x
        x = self.input_layer(x)
        names = self.__dict__
        temp = list(range(1, self.HG_depth + 1))
        for encodingLayer in temp:
            temp_conv = self.MidLayers[encodingLayer - 1]
            x = temp_conv(x)
        x = self.output_layer(x)
        x = x + INPUT
        return x

  
class HG_block(nn.Module):
    def __init__(self, num_Ch):
        super(HG_block, self).__init__()
        self.conv_res= nn.Sequential(
            nn.Conv3d(num_Ch, num_Ch, 3, padding=1),
            nn.BatchNorm3d(num_Ch),
            nn.ReLU(inplace = True),
        )
        self.conv_for = nn.Sequential(
            nn.Conv3d(num_Ch, num_Ch, 3, padding=1),
            nn.BatchNorm3d(num_Ch),
            nn.ReLU(inplace = True),
        )

    def forward(self, x):
        INPUT = x
        x = self.conv_res(x)
        x = x + INPUT
        x = self.conv_for(x)
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
    HGnet = DeepResNet(1,1)
    HGnet.apply(weights_init)
    print(get_parameter_number(HGnet))
    a = torch.randn(1, 1, 48, 48, 48)
    print(a.size())
    b = HGnet(a)
    print(b.size())
    