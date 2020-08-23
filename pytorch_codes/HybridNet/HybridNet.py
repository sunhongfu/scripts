from DeepResNet import * 
from Unet import * 

class HybridNet(nn.Module):
    def __init__(self,num_in, num_out):
        super(HybridNet, self).__init__()
        self.imgNet = Unet(4)
        self.KNet = DeepResNet(num_in, num_out)
        self.AG = AG_block()

    def forward(self, x, x_tkd):
        x = self.imgNet(x)
        G = self.KNet(x_tkd)
        x = self.AG(x, G)
        x = x + G
        return x, G


class AG_block(nn.Module):
    def __init__(self, num_Ch = 16):
        super(AG_block, self).__init__()
        self.convG = nn.Conv3d(1, num_Ch, 1, stride = 1, padding = 0)
        self.convX = nn.Conv3d(1, num_Ch, 1, stride = 1, padding = 0)
        self.Relu1 = nn.ReLU()
        self.convPh = nn.Conv3d(num_Ch, 1, 1, stride = 1, padding = 0)
        self.sig1 = nn.Sigmoid()

    def forward(self, x, G):
        INPUT = x
        x = self.convX(x)
        G = self.convG(G)
        x = x + G
        x = self.Relu1(x)
        x = self.convPh(x)
        x = self.sig1(x)
        x = INPUT * x
        return x

        
if __name__ == '__main__':
    HGnet = HybridNet(1,1)
    HGnet.apply(weights_init)
    print(get_parameter_number(HGnet))
    a = torch.randn(1, 1, 48, 48, 48)
    print(a.size())
    b, c = HGnet(a, a)
    print(b.size())
    