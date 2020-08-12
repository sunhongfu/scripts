from Unet import *
from OriUnet import *

class Hnet(nn.Module):
    def __init__(self):
        super(Hnet, self).__init__()
        self.unet = Unet(4)
        self.oriUnet = OriUnet(4)

    def forward(self, x_img, x_k, D):
        img1, k1 = self.oriUnet(x_img, D)
        k2, img2 = self.unet(x_k, D)

        x = k1 + k2

        x[:,:,0,0,0] = 0 ## set the average of the recon as 0; 

        x_k = x.permute(0, 2, 3, 4, 1)  ## FFT reconstruciton block. 
        x_k = x_k * 1e3
        ##print(x_k.size())
        x_img = torch.ifft(x_k, 3)
        x_img = x_img[:,:,:,:,0]  ## get the real channel. 0： real channel, 1, imaginary channel.
        x_img = torch.unsqueeze(x_img, 1) # reshape as Nb * 1 * H * W * D
        return x_img, x, img2, img1


#################### For Code Test ##################################
## before running the training codes, verify the network architecture. 
if __name__ == '__main__':
    pass