import os
import numpy as np
import random
import torch
from torch.utils import data
import scipy.io as scio
from MRSNet import * 


class DataSet(data.Dataset):
    def __init__(self, root, list_path, transform=None):
        super(DataSet,self).__init__()
        self.root = root
        self.list_path = list_path
        ##self.Mask = mask  ## subsampling mask; file 'Real_Mask_Acc4_forTraining.mat' in current folder
        self.delta_T = 1 / 3800

        self.Prob = torch.tensor(0.8)   ## 20% (1 - 0.8) probability to add noise; 
        self.SNRs = torch.tensor([50, 40, 20, 10])  # Noise SNRs. 

        self.img_ids = []
        ## get the number of files. 
        # self.img_ids = [i_id.strip() for i_id in open(list_path)]
        self.img_ids = [i_id.strip() for i_id in open(list_path)]
        # print(self.img_ids)
        ## get all fil names, preparation for get_item. 
        ## for example, we have two files: 
        ## 102-field.nii for input, and 102-phantom for label; 
        ## then image id is 102, and then we can use string operation
        ## to get the full name of the input and label files. 
        self.files = []
        for name in self.img_ids:
            label_file = self.root + ("/FullySampled_256/full_%s.mat" % name)
            self.files.append({
                #"img": img_file,
                "label": label_file,
                "name": name
            })
        ## sprint(self.files)

    def __len__(self):
        return len(self.files)
 
 
    def __getitem__(self, index):
        datafiles = self.files[index]
 
        '''load the datas'''
        name = datafiles["name"]
        ## nifti read codes. 
        matLabel = scio.loadmat(datafiles["label"], verify_compressed_data_integrity=False)
        label = matLabel['k_full']        

        label = np.array(label)

        mask = matLabel['mask']

        image = np.multiply(label, mask)
        # image = image / 35 

        # convert to images
        # image = np.fft.fft(image)
        # image = np.fft.fftshift(image)
        # image = image / np.sqrt(256)
        # ###mag = np.absolute(image)
        # image = image / 35  # normalization. 

        label = np.fft.fft(label, axis = -1)
        label = np.fft.fftshift(label, axes = -1)
        label = label / np.sqrt(256)
        ###mag = np.absolute(label)
        # label = label / 35  # normalization

        image_r = np.real(image)
        image_i = np.imag(image)
        label_r = np.real(label)
        label_i = np.imag(label)

        ## convert the image data to torch.tesors and return. 
        image_r = torch.from_numpy(image_r) 
        label_r = torch.from_numpy(label_r)
        image_i = torch.from_numpy(image_i) 
        label_i = torch.from_numpy(label_i)

        mask = torch.from_numpy(mask)

        image_r = image_r.float()
        label_r = label_r.float()
        image_i = image_i.float()
        label_i = label_i.float()
        mask = mask.float()

        ## LW convolution: 
        length = image_r.size()[-1]   
        ksp_coords = torch.linspace(0, length - 1, length)
        linewidth = 5 + 5 * torch.rand(1)   ## random line-width, 5-10 Hz. 
        LW_kernels = DecayingTerm(ksp_coords, linewidth, delta_T) 
        image = image * LW_kernels

        ### add noise into the input images; 
        tmp = torch.rand(1)
        if tmp > self.Prob:
            #print('noise')
            tmp_mask = lfs != 0
            tmp_idx = torch.randint(4, (1,1))
            tmp_SNR = self.SNRs[tmp_idx]
            image_r = AddNoise(image_r, tmp_SNR)
            image_r = image_r * mask
            image_i = AddNoise(image_i, tmp_SNR)
            image_i = image_i * mask

        return image_r, image_i, mask, label_r, label_i, linewidth, name

def AddNoise(ins, SNR):
    sigPower = SigPower(ins)
    noisePower = sigPower / SNR
    noise = torch.sqrt(noisePower.float()) * torch.randn(ins.size()).float()
    return ins + noise

def SigPower(ins):
    ll = torch.numel(ins)
    tmp1 = torch.sum(ins ** 2)
    return torch.div(tmp1, ll)


## before formal usage, test the validation of data loader. 
if __name__ == '__main__':
    DATA_DIRECTORY = '..'
    DATA_LIST_PATH = './test_IDs.txt'
    Batch_size = 5
    dst = DataSet(DATA_DIRECTORY,DATA_LIST_PATH)
    print(dst.__len__())
    # just for test,  so the mean is (0,0,0) to show the original images.
    # But when we are training a model, the mean should have another value
    # test code on personal computer: 
    trainloader = data.DataLoader(dst, batch_size = Batch_size, shuffle=False)
    for i, Data in enumerate(trainloader):
        imgs, labels, names = Data
        if i%10 == 0:
            print(i)
            print(names)
            print(imgs.size())
            print(labels.size())
