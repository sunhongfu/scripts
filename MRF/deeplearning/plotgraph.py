#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Mar 22 18:12:01 2022

@author: dingtianyi
"""

import torch
import torch.nn as nn
import torch.nn.functional as F
import scipy.io
import numpy as np
import math as m
import matplotlib.pyplot as plt
from torch.utils.data import Dataset, DataLoader
from mpl_toolkits.axes_grid1 import make_axes_locatable


device = 'cuda' if torch.cuda.is_available() else 'cpu'
print(f'Using {device} device')



## CNN model
class MRFNet(nn.Module):
    def __init__(self, EncodingDepth=5):
        super(MRFNet, self).__init__()
        initial_num_layers = 48
        No_channels = 1000
        No_out_channels = 4
        self.EncodingDepth = EncodingDepth #中间block的长度
        self.init1 = CConv1d_BN_RELU(No_channels, initial_num_layers)

        self.midLayers = []
        temp = list(range(1, EncodingDepth + 1))
        for encodingLayer in temp:
            self.midLayers.append(Basic_block(initial_num_layers, initial_num_layers))
        self.midLayers = nn.ModuleList(self.midLayers)

        self.FinalConv = CConv1d(initial_num_layers*2, No_out_channels)


    def forward(self, x_r, x_i):
        x_r, x_i = self.init1(x_r, x_i)

        temp = list(range(1, self.EncodingDepth + 1))
        for encodingLayer in temp:
            temp_conv = self.midLayers[encodingLayer - 1]
            x_r, x_i = temp_conv(x_r, x_i)

        X = self.FinalConv(x_r, x_i)


        return X


class Basic_block(nn.Module):
    def __init__(self, num_in, num_out):
        super(Basic_block, self).__init__()
        self.cconv1 = CConv1d_BN_RELU(num_in, num_out)
        self.cconv2 = CConv1d_BN_RELU(num_out, num_out)

    def forward(self, x_r, x_i):
        INPUT_r = x_r
        INPUT_i = x_i
        x_r, x_i = self.cconv1(x_r, x_i)
        x_r = x_r + INPUT_r
        x_i = x_i + INPUT_i
        x_r, x_i = self.cconv2(x_r, x_i)
        return x_r, x_i


## complex convolution;
class CConv1d_BN_RELU(nn.Module):
    def __init__(self, num_in, num_out, ks=3, pad=1): #ks kernal size, pading:
        super(CConv1d_BN_RELU, self).__init__()
        self.conv_r = nn.Conv1d(num_in, num_out, ks, padding=pad)
        self.conv_i = nn.Conv1d(num_in, num_out, ks, padding=pad)
        self.bn_r = nn.BatchNorm1d(num_out)
        self.bn_i = nn.BatchNorm1d(num_out)
        self.relu_r = nn.ReLU(inplace=True)
        self.relu_i = nn.ReLU(inplace=True)

    def forward(self, x_r, x_i):
        x_rr = self.conv_r(x_r)
        x_ri = self.conv_i(x_r)
        x_ir = self.conv_r(x_i)
        x_ii = self.conv_i(x_i)
        x_r = x_rr - x_ii
        x_i = x_ri + x_ir
        x_r = self.bn_r(x_r)
        x_i = self.bn_i(x_i)
        x_r = self.relu_r(x_r)
        x_i = self.relu_i(x_i)
        return x_r, x_i


## FC;
class CConv1d(nn.Module):
    def __init__(self, num_in, num_out, ks=1, pad=0, bs=True):
        super(CConv1d, self).__init__()
        self.conv = nn.Conv1d(num_in, num_out, ks, bias=bs, padding=pad)


    def forward(self, x_r, x_i):
        X = torch.cat([x_r, x_i], dim=1)
        #print(str(X.size()))

        X = self.conv(X)
        #print(str(X.size()))

        return X


def weights_init(m):
    if isinstance(m, nn.Conv1d):
        nn.init.normal_(m.weight, mean=0.0, std=1e-2)
        nn.init.zeros_(m.bias)
    if isinstance(m, nn.BatchNorm1d):
        nn.init.ones_(m.weight)
        nn.init.zeros_(m.bias)


def get_parameter_number(net):
    total_num = sum(p.numel() for p in net.parameters())
    trainable_num = sum(p.numel() for p in net.parameters() if p.requires_grad)
    return {'Total': total_num, 'Trainable': trainable_num}

## fully connect model
class NeuralNet(nn.Module):
    def __init__(self, input_size, num_classes):
        super(NeuralNet, self).__init__()
        self.fc1 = nn.Linear(input_size, 2048) 
        self.relu = nn.ReLU(inplace=True)
        self.fc2 = nn.Linear(2048,1024)

        self.fc3 = nn.Linear(1024,512)

        self.fc4 = nn.Linear(512,256)

        self.fc5 = nn.Linear(256,128)
          
        self.fc6 = nn.Linear(128,64)
        
        self.fc7 = nn.Linear(64,32)
        
        self.fc8 = nn.Linear(32, num_classes)  
        
    def forward(self, xr,xi):
        #x_r,x_i = self.init1(xr,xi)
        x = torch.cat([xr,xi],dim=1)
        out = self.fc1(x)
        out = self.relu(out)
        out = self.fc2(out)
        out = self.relu(out)
        out = self.fc3(out)
        out = self.relu(out)
        out = self.fc4(out)
        out = self.relu(out)
        out = self.fc5(out)
        out = self.relu(out)
        out = self.fc6(out)
        out = self.relu(out)
        out =self.fc7(out)
        out = self.relu(out)
        out = self.fc8(out)
        return out
 
    
 
#test dataset data loader    
class testDataset(Dataset):
    def __init__(self,xr,xi):
        self.xr = xr
        self.xi = xi

    def __len__(self):
        return len(self.xr)
    
    def __getitem__(self, idx):
        return self.xr[idx],self.xi[idx]
    


"change file path"    
testdata = scipy.io.loadmat('/Volumes/LaCie_Top/MRF_bSSFP/2022_01_12_Startup_package/recon/img_10shots_noSVD.mat')

datas = testdata['img']

im1 = datas[0]
im2 = datas[1]


#reshape and norm the input data
reim1 = im1.reshape((25600,1000),order='F')
reim2 = im2.reshape((25600,1000),order='F')
nim1 = reim1/np.linalg.norm(reim1,axis=1,keepdims=True)
nim2 = reim2/np.linalg.norm(reim2,axis=1,keepdims=True)


real_num1 = np.real(nim1)
imag_num1 = np.imag(nim1)
real_num2 = np.real(nim2)
imag_num2 = np.imag(nim2)


image_data1 = testDataset(real_num1,imag_num1)
image_data2 = testDataset(real_num2,imag_num2)

test_dataloader1 = DataLoader(image_data1, shuffle=False, batch_size=1)
test_dataloader2 = DataLoader(image_data2,shuffle=False,batch_size = 1)


"load model"

model = torch.load('/Users/uqhsun8/Documents/MATLAB/scripts/MRF/deeplearning/model_cnn_fulldata_new.pkl',map_location = torch.device('cpu'))    
# torch.manual_seed(42)
model.eval()

"if cnn model, run this one"
ops1 = []
ops2 = []
with torch.no_grad():
    for i, (rea1,img1) in enumerate(test_dataloader1):
        real1 = rea1.unsqueeze(2)
        imag1 = img1.unsqueeze(2)
        ops1.append(model(real1,imag1))
        
    for i, (rea2,img2) in enumerate(test_dataloader2):
        real2 = rea2.unsqueeze(2)
        imag2 = img2.unsqueeze(2)
        ops2.append(model(real2,imag2))
        


"if fully connect model, run  this one"
ops1 = []
ops2 = [] 
with torch.no_grad():
    for i, (rea1,img1) in enumerate(test_dataloader1):
        real1 = rea1.to(device)
        imga1 = img1.to(device)
        outputs1 = model(real1,imga1)
        ops1.append(outputs1.data)
    for i,(rea2,img2) in enumerate(test_dataloader2):
        real2 = rea2.to(device)
        imga2 = img2.to(device)
        outputs2 = model(real2,imga2)
        ops2.append(outputs2.data)
        
        
"combine the result"        
res1 = torch.cat(ops1,dim=0)
res2 = torch.cat(ops2,dim=0)
    

"save to matlab matrix"
result1 = res1.numpy()
result2 = res2.numpy()

result1 = result1.reshape((160,160,4),order='F')
result2 = result2.reshape((160,160,4),order='F')

scipy.io.savemat('/Users/uqhsun8/Desktop/MRF_CNN/2048f2_result1.mat',{'result1':result1})
scipy.io.savemat('/Users/uqhsun8/Desktop/MRF_CNN/2048f2_result2.mat',{'result2':result2})


"run to show the graph"


# T1 = res1[:,1]
# T1s = T1.reshape(160,160)
# T2 = res1[:,2]
# T2s = T2.reshape(160,160)
# B0 = res1[:,3]
# B0s = B0.reshape(160,160)

PD = result1[:,:,0]
T1 = result1[:,:,1]
T2 = result1[:,:,2]
B0 = result1[:,:,3]


#%%
fig = plt.figure()
fig.suptitle('CCNN result')

ax1 = fig.add_subplot(241)
ax1.set_title('image1 PD')
im1 = ax1.imshow(PD, cmap= plt.cm.gray)

ax1 = fig.add_subplot(242)
ax1.set_title('image1 T1')
im1 = ax1.imshow(T1, cmap= plt.cm.gray)

ax1 = fig.add_subplot(243)
ax1.set_title('image1 T2')
im1 = ax1.imshow(T2, cmap= plt.cm.gray)

ax1 = fig.add_subplot(244)
ax1.set_title('image1 B0')
im1 = ax1.imshow(B0, cmap= plt.cm.gray)

ax1 = fig.add_subplot(245)
ax1.set_title('image1 PD')
im1 = ax1.imshow(PD, cmap= plt.cm.gray)

ax1 = fig.add_subplot(246)
ax1.set_title('image1 T1')
im1 = ax1.imshow(T1, cmap= plt.cm.gray)

ax1 = fig.add_subplot(247)
ax1.set_title('image1 T2')
im1 = ax1.imshow(T2, cmap= plt.cm.gray)

ax1 = fig.add_subplot(248)
ax1.set_title('image1 B0')
im1 = ax1.imshow(B0, cmap= plt.cm.gray)
#%%

fig = plt.figure()
fig.suptitle('2048 result')

ax1 = fig.add_subplot(231)
ax1.set_title('image1 T1')
im1 = ax1.imshow(T1s.cpu(), cmap= plt.cm.gray)
im1.set_clim(0,3000)
divider = make_axes_locatable(ax1)
#cax = divider.append_axes('right', size='5%', pad=0.05)

fig.colorbar(im1,ax=ax1,orientation='vertical',shrink=.9)
# plt.tight_layout()
# plt.show()

ax2 = fig.add_subplot(232)
ax2.set_title('image1 T2')
im2 = ax2.imshow(T2s.cpu(), cmap= plt.cm.gray)
divider= make_axes_locatable(ax2)
im2.set_clim(0,200)
#cax=divider.append_axes('right', size='5%', pad=0.05)
fig.colorbar(im2,ax=ax2,orientation='vertical')


ax3 = fig.add_subplot(233)
ax3.set_title('image1 B0')
im3 = ax3.imshow(B0s.cpu(), cmap= plt.cm.gray)
divider=make_axes_locatable(ax3)
im3.set_clim(-100,100)
#cax=divider.append_axes('right', size='5%', pad=0.05)
fig.colorbar(im3,ax=ax3,orientation='vertical')

ax4 = fig.add_subplot(234)
ax4.set_title('image2 T1')
im4=ax4.imshow(res2[:,1].reshape(160,160), cmap= plt.cm.gray)
im4.set_clim(0,3000)
divider=make_axes_locatable(ax4)
#cax=divider.append_axes('right', size='5%', pad=0.05)
fig.colorbar(im4,ax=ax4,orientation='vertical',shrink=.9)



ax5 = fig.add_subplot(235)
ax5.set_title('image2 T2')
im5=ax5.imshow(res2[:,2].reshape(160,160), cmap= plt.cm.gray)
divider=make_axes_locatable(ax5)
#cax=divider.append_axes('right', size='5%', pad=0.05)
im5.set_clim(0,200)
fig.colorbar(im5,ax = ax5,orientation='vertical')

ax6 = fig.add_subplot(236)
ax6.set_title('image2 B0')
im6 = ax6.imshow(res2[:,3].reshape(160,160), cmap= plt.cm.gray)
im6.set_clim(-100,100)
divider=make_axes_locatable(ax6)
#cax=divider.append_axes('right', size='5%', pad=0.05)
fig.colorbar(im6,ax=ax6,orientation='vertical')

plt.tight_layout()
plt.show()



