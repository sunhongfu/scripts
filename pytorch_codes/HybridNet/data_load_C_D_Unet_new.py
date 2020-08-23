import os
import numpy as np
import nibabel as nib
import random
import torch
from torch.utils import data
import scipy.io as scio

 
class yangDataSet(data.Dataset):
    def __init__(self, root, list_path):
        super(yangDataSet,self).__init__()
        self.root = root
        self.list_path = list_path
        self.SNRs = torch.tensor([40, 20, 10, 5])
        self.Prob = 1.5 ## >=1: no noise, 0.5： 50%  noise
 
        ## get the number of files. 
        self.img_ids = [i_id.strip() for i_id in open(list_path)]
        # print(self.img_ids)
        ## get all fil names, preparation for get_item. 
        ## for example, we have two files: 
        ## 102-field.nii for input, and 102-phantom for label; 
        ## then image id is 102, and then we can use string operation
        ## to get the full name of the input and label files. 
        self.files = []
        for name in self.img_ids:

            tmp_idx = int(name)
            tmp_idx = tmp_idx - 1
            tmp_idx = tmp_idx // 15000     ## 0-2 
            file_idx = int(name) - 15000 * tmp_idx    ## 1 - 15000 

            label_file = self.root + ("/QSM_VIVO/%s-Phantom_NIFTI.nii" % str(file_idx))

            ## label_file = self.root + ("/Label_k/%s_Label_k.nii" % name)
            TKD_file = ("../tkd_inputs/%s_tkd_HeadDir_%s.nii" % (str(file_idx), str(tmp_idx + 1))) ## threshold: 0.2 for this network
            LFS_file = ("../lfs_inputs/%s_lfs_HeadDir_%s.nii" % (str(file_idx), str(tmp_idx + 1)))
            ## invDiplole_file =("./invDipole_k/invDipole_%s.nii" % str(tmp_idx + 1)) 
            self.files.append({
                "tkd": TKD_file,
                "lfs": LFS_file,
                "label": label_file,
                ##"Coor": C_file,
                "name": name
            })

    def __len__(self):
        return len(self.files)
 
 
    def __getitem__(self, index):
        datafiles = self.files[index]
 
        '''load the datas'''
        name = datafiles["name"]
        ## nifti read codes. 
        niblabel = nib.load(datafiles["label"])
        nibTKD = nib.load(datafiles["tkd"])
        nibLFS = nib.load(datafiles["lfs"])
        ## nibmask = nib.load(datafiles["mask"])

        label = niblabel.get_fdata() 
        TKD = nibTKD.get_fdata() 
        LFS = nibLFS.get_fdata()
        ## mask = nibmask.get_fdata()

        label = np.array(label)
        TKD = np.array(TKD)
        LFS = np.array(LFS)
        ##mask = np.array(mask)

        ## convert the image data to torch.tesors and return. 
        label = torch.from_numpy(label)
        TKD = torch.from_numpy(TKD)
        LFS = torch.from_numpy(LFS)

        label = torch.unsqueeze(label, 0)
        TKD = torch.unsqueeze(TKD, 0)
        LFS = torch.unsqueeze(LFS, 0)

        label = label.float()
        TKD = TKD.float()
        LFS = LFS.float()
        return LFS, TKD, label, name

def ImagePad(x, pos = [48, 72, 40]):
    x_pad = torch.zeros(144, 192, 128, 2)
    x_pad[pos[0]:pos[0] + 48,pos[1]:pos[1] + 48,pos[2]:pos[2] + 48, 0] = x ## real channel
    return x_pad

def ImageCrop(x, pos = [48, 72, 40]):
    x_crop = torch.zeros(48,48,48)
    x_crop = x[pos[0]:pos[0] + 48,pos[1]:pos[1] + 48,pos[2]:pos[2] + 48]
    return x_crop

def AddNoise(ins, SNR):
    sigPower = SigPower(ins)
    noisePower = sigPower / SNR
    noise = torch.sqrt(noisePower.double()).double() * torch.randn(ins.size()).double()
    mask = ins != 0
    mask = mask.double()
    return ((ins + noise) * mask)

def SigPower(ins):
    ll = torch.numel(ins)
    tmp1 = torch.sum(ins ** 2)
    return torch.div(tmp1, ll)

## before formal usage, test the validation of data loader. 
if __name__ == '__main__':
    DATA_DIRECTORY = '..'
    DATA_LIST_PATH = './single_ori_IDs.txt'
    Batch_size = 1
    dst = yangDataSet(DATA_DIRECTORY,DATA_LIST_PATH)
    print(dst.__len__())
    # just for test,  so the mean is (0,0,0) to show the original images.
    # But when we are training a model, the mean should have another value
    # test code on personal computer: 
    trainloader = data.DataLoader(dst, batch_size = Batch_size, shuffle=True, drop_last = True)
    for i, Data in enumerate(trainloader):
        imgs, tkd_img, labels, names = Data

        imgs = torch.squeeze(imgs, 0)
        labels = torch.squeeze(labels, 0)
        tkd_img = torch.squeeze(tkd_img, 0)

        imgs = imgs.numpy()
        labels = labels.numpy()
        tkd_img = tkd_img.numpy()

        path = 'data_label.mat'
        scio.savemat(path, {'PRED':labels})
        
        path = 'data_input.mat'
        scio.savemat(path, {'PRED':imgs})

        path = 'tkd_input.mat'
        scio.savemat(path, {'PRED':tkd_img})
        print('end2')
