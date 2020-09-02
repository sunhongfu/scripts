from Unet import * 
from Rot_Functions import * 
from DeepResNet import *

class CasNet(nn.Module):
    def __init__(self):
        super(CasNet, self).__init__()
        self.Net1 = Unet(4)
        self.Net2 = DeepResNet(1, 1)

    def forward(self, x, rot_mat, inv_mat):
        ## x: shape: Nb * D * H * W, 
        ## rot_mat and inv_mat: Nb * 1 * 3 * 3

        x = rotate(x, rot_mat)  ## rotate signal to the pure axial direction. 
        
        x = self.Net1(x)

        x = rotate(x, inv_mat)  ## rotate signal to the pure axial direction. 

        x1 = x
        x2 = self.Net2(x1)
        
        return x1, x2


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
    HGnet = CasNet()
    HGnet.apply(weights_init)
    print(get_parameter_number(HGnet))
    a = torch.randn(2, 1, 48, 48, 48)
    rot_a = torch.randn(2, 1, 3, 3)
    invrot_a = torch.randn(2,1,3,3)
    print(a.size())
    b, c = HGnet(a, rot_a, invrot_a)
    print(b.size())
    print(c.shape)
    