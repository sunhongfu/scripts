###### Yang's U-net for comparision study ################
## This file is for network construction. 

#################### Section 1 ###########################
## Import necessary library and packages and further pre-
## -defined packages here.
## import self-defined packages
import torch.nn.functional as F
from Unet_blocks import * 
################# End Section 1 ##########################

#################### Section 2 ###########################
## Parameters： Encoding depth: Times of Poolings 
class OriUnet(nn.Module):
    def __init__(self, EncodingDepth):
        super(OriUnet, self).__init__()
        self.EncodeConvs = []
        self.DecodeConvs = []
        self.EncodingDepth = EncodingDepth
        initial_num_layers = 16
        temp = list(range(1, EncodingDepth + 1))
################### Encoding Layers #######################
        for encodingLayer in temp:
            if encodingLayer == 1:
                num_outputs= initial_num_layers * 2 ** (encodingLayer - 1)
                self.EncodeConvs.append(EncodingBlocks(1, num_outputs))
            else:             
                num_outputs = initial_num_layers * 2 ** (encodingLayer - 1)
                self.EncodeConvs.append(EncodingBlocks(num_outputs // 2, num_outputs))
        self.EncodeConvs = nn.ModuleList(self.EncodeConvs)
################### Mid Layers ############################
        self.MidConv1 = MidBlocks(num_outputs)
        initial_decode_num_ch = num_outputs
################### Decoding Layers #######################
        for decodingLayer in temp:
            if decodingLayer == EncodingDepth:
                num_inputs = initial_decode_num_ch // 2 ** (decodingLayer - 1)
                self.DecodeConvs.append(DecodingBlocks(num_inputs, num_inputs))
            else:
                num_inputs = initial_decode_num_ch // 2 ** (decodingLayer - 1)
                self.DecodeConvs.append(DecodingBlocks(num_inputs, num_inputs // 2))
        self.DecodeConvs = nn.ModuleList(self.DecodeConvs)
        self.FinalConv = nn.Conv3d(num_inputs, 1, 1, stride = 1, padding = 0)
################## End Section 2 ##########################

    def forward(self, x, D):
        INPUT = x
        names = self.__dict__
        temp = list(range(1, self.EncodingDepth + 1))
        for encodingLayer in temp:
            temp_conv = self.EncodeConvs[encodingLayer - 1]
            x = temp_conv(x)
            #print('EncodeConv' + str(encodingLayer) + str(x.size()))
            names['EncodeX' + str(encodingLayer)] = x
            x = F.max_pool3d(x, 2)
           #print('Pooling' + str(encodingLayer) + str(x.size()))

        x = self.MidConv1(x)
        #print('Mid' + str(encodingLayer) + str(x.size()))

        for decodingLayer in temp:
            temp_conv = self.DecodeConvs[decodingLayer - 1]
            x2 = names['EncodeX' + str(self.EncodingDepth - decodingLayer + 1)]
            x = temp_conv(x, x2)
            #print('DecodeConv' + str(decodingLayer) + str(x.size()))

        x = self.FinalConv(x)
        x = x + INPUT  ## removed the data consisteny block. 

        x_img = torch.cat([x, x], 1)
        x_img = x_img.permute(0, 2, 3, 4, 1)

        ##x_img[:,:,:,:,0] = x   ## noise-added field maps. 
        x_img[:,:,:,:,1] = 0

        ## x_img = torch.unsqueeze(x_img, 1)
        ##print(x_k.size())
        x_k = torch.fft(x_img, 3)
        x_k = x_k / 1e3

        x_k = x_k.permute(0, 4, 1, 2, 3)  ## FFT reconstruciton block. 
        x_k[:,:,0,0,0] = 0 ## set the average of the recon as 0; 
        
        return x, x_k


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

#################### For Code Test ##################################
## before running the training codes, verify the network architecture. 
if __name__ == '__main__':
    unet = Unet(2)
    unet.apply(weights_init)
    print(get_parameter_number(unet))
    x = torch.randn(1,2,48,48,48, dtype=torch.float)
    M = torch.randn(1,1,48,48,48, dtype=torch.float)
    print('input' + str(x.size()))
    print(x.dtype)
    y1, y2 = unet(x)
    print('output'+str(y1.size()))
    print('output_2:'+str(y2.size()))
