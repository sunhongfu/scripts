import os
import numpy as np
import nibabel as nib
import random
import torch
from torch.utils import data

 
class yangDataSet(data.Dataset):
    def __init__(self, root, list_path):
        super(yangDataSet,self).__init__()
        self.root = root
        self.list_path = list_path
        self.SNRs = torch.tensor([40, 20, 10, 5])
        self.Prob = 0.8 ## >=1: no noise, 0.5： 50%  noise
 
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
            """
            tmp_idx = int(name)
            tmp_idx = tmp_idx - 1
            tmp_idx = tmp_idx // 15000
            file_idx = int(name) - 15000 * tmp_idx
            """
            label_file = self.root + ("/Label_k/%s_Label_k.nii" % name)
            Dipole_file = ("./Dipole_k/Dipole_%s.nii" % str(1))
            invDipole_file = ("./invDipole_k/invDipole_%s.nii" % str(1))
            ## invDiplole_file =("./invDipole_k/invDipole_%s.nii" % str(tmp_idx + 1)) 
            self.files.append({
                "Dipole": Dipole_file,
                "invDipole":invDipole_file,
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
        nibD = nib.load(datafiles["Dipole"])
        nibinvD = nib.load(datafiles["invDipole"])

        label = niblabel.get_fdata() 
        D = nibD.get_fdata() 
        invD = nibinvD.get_fdata()

        label = np.array(label)
        D = np.array(D)
        invD = np.array(invD)

        ## convert the image data to torch.tesors and return. 
        label = torch.from_numpy(label)
        D = torch.from_numpy(D)
        invD = torch.from_numpy(invD)

        ## label = label.permute(3, 0, 1, 2)
        if label[0,0,0,0] != 0:
            print('error')
        if label[1,0,0,0] != 0:
            print('error')       

        """
        Mask = torch.unsqueeze(Mask, 0)
        if Mask[0, 0,0, 0] != 1:
            print('error')
        """

        Label_k = label.permute(1, 2, 3, 0)
        Label_k = Label_k * 1e3

        label_img = torch.ifft(Label_k, 3)
        label_img = label_img[:,:,:,0]  ## get real channel. 

        ##mask = label_img != 0
        ## mask = mask.doubel()

        ##C = C.permute(3, 0, 1, 2)
        ##image = torch.unsqueeze(image, 0)
        ##label = torch.unsqueeze(label, 0)
        ##D = torch.unsqueeze(D, 0)
        ##C = torch.unsqueeze(C, 0)
        label_img = torch.unsqueeze(label_img, 0)

        image = label * D
        image = image.permute(1, 2, 3, 0)
        image = image * 1e3   ## scaling factors.
        input_k = image


        image = torch.ifft(image, 3)
        image = image[:,:,:,0]  ## get real channel. 

        ## image = image * mask   # mask out the outside regions. 

        input_img = image
        input_img = torch.unsqueeze(input_img, 0)

        ## noise regularization to make the network robust to noise and field deviation. 
        tmp = torch.rand(1)
        if tmp > self.Prob:
            #print('noise')
            tmp_idx = torch.randint(4, (1,1))
            tmp_SNR = self.SNRs[tmp_idx]
            image = AddNoise(image, tmp_SNR)
            ## image = image * mask
        
        input_k[:,:,:,0] = image    ## noise-added field maps. 
        input_k[:,:,:,1] = torch.zeros(48, 48, 48)

        input_k = torch.fft(input_k, 3) ## 3D FFT. 
        input_k = input_k.permute(3, 0, 1, 2)  ## re-shape. 
        input_k = input_k / 1e3   ## noisy k-space field data. 

        input_k = input_k * invD  ## use the TKD for preprocessing. 
 
        D = torch.unsqueeze(D, 0)
        input_k = input_k.float()
        input_img = input_img.float()
        label = label.float()
        label_img = label_img.float()
        D = D.float()
        #Mask = Mask.float()
        ##D = D.float()
        ##C = C.float()
        
        return input_k, input_img, label, label_img, D, name

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
    DATA_DIRECTORY = './'
    DATA_LIST_PATH = './test_IDs.txt'
    Batch_size = 3
    dst = yangDataSet(DATA_DIRECTORY,DATA_LIST_PATH)
    print(dst.__len__())
    # just for test,  so the mean is (0,0,0) to show the original images.
    # But when we are training a model, the mean should have another value
    # test code on personal computer: 
    trainloader = data.DataLoader(dst, batch_size = Batch_size, shuffle=True, drop_last = True)
    for i, Data in enumerate(trainloader):
        imgs, labels, D, names = Data
        print(i)
        print('file_name:', names)
        print(D.size())
        ##print(C.size())
        print(imgs.size())
        print(labels.size())
