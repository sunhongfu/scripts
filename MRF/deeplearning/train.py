# -*- coding: utf-8 -*-
"""
Created on Wed Mar 23 12:57:44 2022

@author: Tianyi
"""

import torch
import torch.nn as nn
import torch.nn.functional as F
import scipy.io
import numpy as np
import math as m

import scipy.io
from torch.utils.data import Dataset, DataLoader




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

        X1 = X[:, 1, :]
        X2 = X[:, 2, :]
        X3 = X[:, 3, :]
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



class Dataset(Dataset):
    def __init__(self,xr,xi,y):
        self.xr = xr
        self.xi = xi
        self.y = y
    def __len__(self):
        return len(self.xr)
    
    def __getitem__(self, idx):
        return self.xr[idx],self.xi[idx],self.y[idx]
    
    
    
device = 'cuda' if torch.cuda.is_available() else 'cpu'
print(f'Using {device} device')    

mat = scipy.io.loadmat('E:\codes\data\dictionary.mat')
atoms = mat['dictionary'][0][0][0]
lookup = mat['dictionary'][0][0][1]

batch_size = 48
learning_rate = 0.0001


train_X = atoms
train_y = (lookup).astype(np.float32)
real_tx = (np.real(train_X)).astype(np.float32)
#real_tx = np.expand_dims(real_tx,axis =2)
img_tx = (np.imag(train_X)).astype(np.float32)
train_DL = DataLoader(Dataset(real_tx,img_tx,train_y),batch_size= batch_size,shuffle = True)

batch_size = 64
learning_rate = 0.0001

model = MRFNet(2).to(device)
criterion = nn.MSELoss()
optimizer = torch.optim.Adam(model.parameters(), lr=learning_rate)  
torch.manual_seed(42)
total_step = 205
loss_list = []
num_epochs = 500

for epoch in range(num_epochs):
    for i, (real,imga,label) in enumerate(train_DL):
        real = real.unsqueeze(2)
        imga = imga.unsqueeze(2)
        label = label.unsqueeze(2)
        
        real = real.to(device)
        imga = imga.to(device)
        labels = label.to(device)
        
        outputs = model(real,imga)
        loss = criterion(outputs,labels)
        
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        
        if (i+1) %100 ==0:
            print('Epoch [{}/{}], Step [{}/{}], Loss: {:.4f}' 
                   .format(epoch+1, num_epochs, i+1, total_step, loss.item()))
            
    loss_list.append(loss.item())     
torch.save(model, 'model_cnn_fulldata.pkl')

input_size = 2000
hidden_size = 500
num_classes = 4
num_epochs = 500
batch_size = 64
learning_rate = 0.001

class NeuralNet(nn.Module):
    def __init__(self, input_size, num_classes):
        super(NeuralNet, self).__init__()
        #initial_num_layers = 40
        #No_channels = 1000
        #self.init1 = Linear_RELU(1000, initial_num_layers)
        #self.firstConv = CConv1d_BN_RELU(No_channels, initial_num_layers)
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
    
model = NeuralNet(input_size,  num_classes).to(device)

criterion = nn.MSELoss()
optimizer = torch.optim.Adam(model.parameters(), lr=learning_rate)  

total_step = 205
loss_list = []
num_epochs = 500
for epoch in range(num_epochs):
    for i, (real,imga,label) in enumerate(train_DL):  
        # Move tensors to the configured device
        real = real.to(device)
        imga = imga.to(device)
        labels = label.to(device)
        
        # Forward pass
        outputs = model(real,imga)
        #output_loss = torch.index_select(outputs,1,torch.tensor([1,2,3]))
        #label_loss = torch.index_select(labels,1,torch.tensor([1,2,3]))
        loss = criterion(outputs, labels)

        
        # Backprpagation and optimization
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        
        if (i+1) % 100 == 0:
            print ('Epoch [{}/{}], Step [{}/{}], Loss: {:.4f}' 
                   .format(epoch+1, num_epochs, i+1, total_step, loss.item()))
            
    loss_list.append(loss.item())     
torch.save(model, 'model_complex.pkl')