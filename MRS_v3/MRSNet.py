"""
******************************************************************
# MRSNet_ISTANet: 
# Unrolling ISTA algorithm for MRS reconstruction problems; 
# problems formulation: 
# argmin_x |Ax - b|^2 + reg(x)
# x is the spectrum to be reconstructed; 
# b subsampled image domian data; b = mask .* img_full; 
# A system matrix: sqrt(len) * U * FH * FSH 
# AH system matrix: 1/sqrt(len) * FS * F * UH 
# AH * A = FS * F * UH * U * FH * FSH = FS * F * U * FH * FSH
#
# x_0 = 0; 
# r_k = x_k-1 - alpha * AH * (A * x_k-1 - b);
# x_k = argmin_x |x - r_k|^2 + lamda * reg(x); 
# traditional method is to find a non-linear transformation making  P(x - r_k) is nearly proportional to x - r_k;
# then, x_k = soft(PH * P * r_k, lamda)
******************************************************************
"""

## *******import packages********
import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.fft as FFT 

import scipy.io as sio
import numpy as np
import os
import time
## *************end*************
class MRSNet(torch.nn.Module):
    def __init__(self, LayerNo, ini_flag = False, cin = 64, cout = 64, ks = 3, pad = 1):
        super(MRSNet, self).__init__()
        """
        IterNum: Number of Itretive blocks; 
        cin and cout: intput and output channel number for the iterative block; 
        """
        self.ini_flag = ini_flag

        layers = []
        self.LayerNo = LayerNo

        for i in range(LayerNo):
            layers.append(OneIter(cin, cout, ks = 3, pad =1))

        self.nets = nn.ModuleList(layers)

    def forward(self, b_r, b_i, mask, linewidth, delta_T=3800, device='cpu'):
        """
        x0: initial guess, can be set as 0 or AH * b;
        mas
        k: subsampling mask; 
        linewidth: Nb * 1, Nb is batch size;
        """
        ## generate LW convolutional kernels (in image domain)
        length = b_r.size()[-1]   
        Nb = b_r.size()[0]   

        ksp_coords = torch.linspace(0, length - 1, length)
        LW_kernels = DecayingTerm(ksp_coords, linewidth, delta_T) ## size: Nb * N 

        assert len(LW_kernels.size()) < 4

        if len(LW_kernels.size()) == 1:
            LW_kernels = LW_kernels.repeat([Nb, 1, 1])

        if len(LW_kernels.size()) == 2:
            LW_kernels = torch.unsqueeze(LW_kernels, 1)

        b = R2C(b_r, b_i)
        AHb = AHx(b, mask, LW_kernels)
        AHb_r, AHb_i = C2R(AHb)

        x_r = torch.zeros(b_r.shape)
        x_i = torch.zeros(b_i.shape)
        if self.ini_flag:
            x_r = AHb_r
            x_i = AHb_i

        sym_loss_all_r = []   # for computing symmetric loss
        sym_loss_all_i = []   # for computing symmetric loss

        for i in range(self.LayerNo):
            x_r, x_i, layer_sym_r, layer_sym_i = self.nets[i](x_r, x_i, mask, AHb_r, AHb_i, LW_kernels, device)
            sym_loss_all_r.append(layer_sym_r)
            sym_loss_all_i.append(layer_sym_i)

        x_final_r = x_r
        x_final_i = x_i

        return x_final_r, x_final_i, sym_loss_all_r, sym_loss_all_i


# define one iteration Layers
class OneIter(torch.nn.Module):
    def __init__(self, num_in = 32, num_out = 32, ks = 3, pad =1):
        super(OneIter, self).__init__()

        self.alpha_r = nn.Parameter(torch.Tensor([0.5]))
        self.alpha_i = nn.Parameter(torch.Tensor([0]))

        self.soft_thr_r = nn.Parameter(torch.Tensor([0.01]))
        self.soft_thr_i = nn.Parameter(torch.Tensor([0.01]))

        self.conv_D =  CConv(1, num_in, ks = 3, pad = 1)

        self.H_for = H_Operator(num_in, num_out, 3, 1)

        self.H_back = H_Operator(num_out, num_out, 3, 1)

        self.conv_G =  CConv(num_out, 1, ks = 1, pad = 0)

    def SoftThr(self, x_r, x_i):
        ## soft thresholding; 
        x_r = torch.mul(torch.sign(x_r), F.relu(torch.abs(x_r) - self.soft_thr_r)) 
        x_i = torch.mul(torch.sign(x_i), F.relu(torch.abs(x_i) - self.soft_thr_i)) 

        return x_r, x_i

    def forward(self, x_r, x_i, mask, AHb_r, AHb_i, LW_kernels, device):

        x_input_r, x_input_i = R_cal(x_r, x_i, mask, AHb_r, AHb_i, self.alpha_r, self.alpha_i, LW_kernels, device)

        x_D_r, x_D_i = self.conv_D(x_input_r, x_input_i)

        x_D_r = F.relu(x_D_r)
        x_D_i = F.relu(x_D_i)

        x_forward_r, x_forward_i = self.H_for(x_D_r, x_D_i)

        x_r, x_i = self.SoftThr(x_forward_r, x_forward_i)

        x_backward_r, x_backward_i = self.H_back(x_r, x_i)

        x_G_r, x_G_i = self.conv_G(x_backward_r, x_backward_i)

        x_pred_r = x_input_r + x_G_r
        x_pred_i = x_input_i + x_G_i

        x_D_est_r, x_D_est_i = self.H_back(x_forward_r, x_forward_i)

        symloss_r = x_D_est_r - x_D_r
        symloss_i = x_D_est_i - x_D_i

        return x_pred_r, x_pred_i, symloss_r, symloss_i

# define H_forward/H_backward_operator; 
class H_Operator(torch.nn.Module):
    def __init__(self, num_in = 32, num_out = 32, ks = 3, pad = 1):
        super(H_Operator, self).__init__()

        """
        use two consecutive convolutional layers, to learn the optimal non-linear forward and backward transformation; 
        An additional loss function should be added in the training process to force the H_forwad * H_backward = I; 
        """
        self.conv1 = CConv(num_in, num_out, ks = 3, pad = 1)
        ##self.bn = nn.BatchNorm2d(num_out)  ## batch-normalization is not necessary; 
        self.conv2 = CConv(num_out, num_out, ks = 3, pad = 1)

    def forward(self, x_r, x_i):

        x_r, x_i = self.conv1(x_r, x_i)
        ##x = self.bn(x) ## batch-normalization is not necessary; 
        
        x_r = F.relu(x_r)
        x_i = F.relu(x_i)

        x_r, x_i = self.conv2(x_r, x_i)

        return x_r, x_i

## Physical-modle Block (PMB): where the data fidelity model were involved; 
def R_cal(x_r, x_i, mask, AHb_r, AHb_i, alpha_r, alpha_i, LW_kernels, device):
    """
    R_k = x_k - alpha * AH * A * x_k + alpha * AH *b)
    R_k = x_k - alpha * (AH * A * x_k - AH *b)
    """
    x = R2C(x_r, x_i)  ## convert real data into complex data;
    ##alpha = R2C(alpha_r, alpha_i)  ## convert real data into complex data;
    AHb = R2C(AHb_r, AHb_i)  ## convert real data into complex data;
    alpha = alpha_r + 1j * alpha_i  ## convert real data into complex data;
    
    INPUT = x  ## x_k
    
    x = x.to(device)
    INPUT = INPUT.to(device)
    AHb = AHb.to(device)
    alpha = alpha.to(device)

    x = Ax(x, mask, LW_kernels)
    x = AHx(x, mask, LW_kernels)
    x = x - AHb # AH * A * x - AH * b; 

    R = INPUT - alpha * x
    R_r, R_i = C2R(R) ## convert complex data back into real data;
    return R_r, R_i 

## decaying terms: generate the line-width convolutional kernel in image domain; 
## linewidth = 1 / (pi * tau)
def DecayingTerm(ksp_coords, linewidth = 5, delta_T = 1 / 3800):
    ## ksp_coors: size: 1 * N; where N is the length of the spectrum; 
    ## linewidth: size: Nb * 1, Nb is batch size; 
    ## delta_T: can be a scalar or a vector of the same size as linewidth;
    LW_Kernel_img = torch.exp(-1 * torch.pi * delta_T * linewidth * ksp_coords)
    return LW_Kernel_img


## system forward and backward

def Ax(x, mask, LW_kernels, flag = '1D'):
    if flag == '1D':
        lenth = x.size()[-1]
        x = FFT.ifftshift(x, dim = -1)
        x = FFT.ifft(x, dim = -1)
        x = x * mask 
        x = x * LW_kernels
        res = x * torch.sqrt(torch.tensor(lenth))

    if flag == '2D':
        x = FFT.ifftshift(x, dim = (-2, -1))
        x = FFT.ifft2(x, dim = (-2, -1))
        x = x * mask 
        res = x * torch.sqrt(x.size()[-2] * x.size()[-1])
    
    if flag == '3D':
        x = FFT.ifftshift(x, dim = (-3, -2, -1))
        x = FFT.ifftn(x, dim = (-3, -2, -1))
        x = x * mask 
        res = x * torch.sqrt(x.size()[-3] * x.size()[-2] * x.size()[-1])

    return res

def AHx(x, mask, LW_kernels, flag = '1D'):
    if flag == '1D':
        lenth = x.size()[-1]
        x = x * LW_kernels
        x = x * mask
        x = FFT.fft(x, dim = -1)
        x = FFT.fftshift(x, dim = -1)
        res = x / torch.sqrt(torch.tensor(lenth))

    if flag == '2D':
        x = x * mask
        x = FFT.fft2(x, dim = (-2, -1))
        x = FFT.fftshift(x, dim = (-2, -1))
        res = x / torch.sqrt(x.size()[-1] * x.size()[-2])
    
    if flag == '3D':
        x = x * mask
        x = FFT.fftn(x, dim = (-3, -2, -1))
        x = FFT.fftshift(x, dim = (-3, -2, -1))
        res = x / torch.sqrt(x.size()[-1] * x.size()[-2] * x.size()[-3])

    return res

################ basic utility functions ###################
def R2C(x_r, x_i, flag = '1D'):
    """
    input dat: 
    x_r, x_i, real and imag component; 
    output data:
    x, complex data in the size of Nb * 1 * Nx;
    """
    if flag == '1D': 
        x = torch.cat([x_r, x_i], dim = 1)
        x = x.permute(0, 2, 1).contiguous() ## Nb * Nx * 2 
        x = torch.view_as_complex(x) # for FFT. 
    if flag == '2D':
        pass
    if flag == '3D':
        pass
    return torch.unsqueeze(x, 1)

def C2R(x, flag = '1D'):
    """
    input data: 
    x, complex tensor in the size of Nb * 1 * Nx;
    output data: 
    x_r and x_i, real and imag components; 
    """
    if flag == '1D':
        x = torch.view_as_real(x).contiguous()  ## real nb * Nx* 2
        x = torch.squeeze(x, 1)
        x = x.permute(0, 2, 1)
        x_r = x[:, 0, :]
        x_i = x[:, 1, :]
    if flag == '2D':
        pass
    if flag == '3D':
        pass
    return torch.unsqueeze(x_r, 1), torch.unsqueeze(x_i, 1)

## complex convolution; 
class CConv(nn.Module):
    def __init__(self, num_in, num_out, ks = 1, bs = True, pad = 0, flag = '1D'):
        super(CConv, self).__init__()
        self.conv_r = ConvUse(num_in, num_out, ks, bs, pad, flag)
        self.conv_i = ConvUse(num_in, num_out, ks, bs, pad, flag)
        
    def forward(self, x_r, x_i):
        x_rr = self.conv_r(x_r)
        x_ri = self.conv_i(x_r)
        x_ir = self.conv_r(x_i)
        x_ii = self.conv_i(x_i)
        x_r = x_rr - x_ii 
        x_i = x_ri + x_ir

        return x_r, x_i

def FFTUse(x, flag = '1D'):
    if flag == '1D':
        res = FFT.fft(x, dim = -1)
    if flag == '2D':
        res = FFT.fft2(x, dim = (-2, -1))
    if flag == '3D':
        res = FFT.fftn(x, dim = (-3, -2, -1))
    return res


## define the most basic batch-normalization types; 
def BNUse(num_in, flag = '1D'):
    if flag == '1D':
        bn = nn.BatchNorm1d(num_in)
    if flag == '2D':
        bn = nn.BatchNorm2d(num_in)
    if flag == '3D':
        bn = nn.BatchNorm3d(num_in)
    
    return bn


## define the most basic convolutional kernel types; 
def ConvUse(num_in, num_out, ks = 3, bs = True, pd = 1, flag = '1D'):
    if flag == '1D':
        conv = nn.Conv1d(num_in, num_out, ks, bias = bs, padding = pd)
    if flag == '2D':
        conv = nn.Conv2d(num_in, num_out, ks, bias = bs, padding = pd)
    if flag == '3D':
        conv = nn.Conv3d(num_in, num_out, ks, bias = bs, padding = pd)
    
    return conv


def weights_init(m, flag = '1D'):
    if flag == '1D':
        if isinstance(m, nn.Conv1d):
            nn.init.normal_(m.weight, mean=0.0, std=1e-2)
            nn.init.zeros_(m.bias)   
        if isinstance(m, nn.BatchNorm1d):
            nn.init.ones_(m.weight)
            nn.init.zeros_(m.bias)   

    if flag == '2D':
        pass
    if flag == '3D':
        pass


def get_parameter_number(net):
    total_num = sum(p.numel() for p in net.parameters())
    trainable_num = sum(p.numel() for p in net.parameters() if p.requires_grad)
    return {'Total': total_num, 'Trainable': trainable_num}

#################### For Code Test ##################################
## before running the training codes, verify the network architecture. 
if __name__ == '__main__':
   
    a_r = torch.randn(2, 1, 13)
    a_i = torch.randn(2, 1, 13)
    mask = torch.randn(2, 1, 13)
    lw = torch.rand(2,1) * 5 + 5
    conv_op = MRSNet(9)
    print(conv_op.state_dict)
    print(lw)
    c_r, c_i, d_r, d_i = conv_op(a_r, a_i, mask, lw)
    print(c_r.size())
    print(c_r)