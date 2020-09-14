import os
import numpy as np
import nibabel as nib
import random
import torch
from torch.utils import data
import scipy.io as scio
import torch.nn.functional as F

 
class yangDataSet(data.Dataset):
    def __init__(self, root, list_path):
        super(yangDataSet,self).__init__()
        self.root = root
        self.list_path = list_path
        ##self.SNRs = torch.tensor([40, 20, 10, 5])
        ##self.Prob = 1.5 ## >=1: no noise, 0.5： 50%  noise
        ##self.Prob_RM = 0.8  ## 20 probability to train on other directions. 
        ## 1 for [0, 0, 1] 2 for [0, 1, 0]; 3 for [1, 0, 0]; 4 for [sqrt(2)/2, 0, sqrt(2)/2]
        ## 5 for [0, sqrt(2)/2, sqrt(2)/2]
        self.RM = np.array([1, 2, 3, 4, 5, 6]) 
 
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
            label_file = self.root + ("/QSM_VIVO/%s-Phantom_NIFTI.nii" % str(name))
            img_file = self.root + ("/Field_VIVO/%s-Field_NIFTI.nii" % str(name))

            self.files.append({
                "label": label_file,
                "img": img_file,
                "name": name
            })

    def __len__(self):
        return len(self.files)
 
 
    def __getitem__(self, index):
        datafiles = self.files[index]

        tmp_idx = torch.randint(6, (1,1))
        tmp_RM = self.RM[tmp_idx]
        dipole_file = ("./Dipole/%s-dipole.nii" % str(tmp_RM))
        rot_mat_file = ("./rot_mat/%s-rot_mat.nii" % str(tmp_RM))
        invRot_mat_file = ("./invRot_mat/%s-invRot_mat.nii" % str(tmp_RM))

        nibRM = nib.load(rot_mat_file)
        nibiRM = nib.load(invRot_mat_file)

        RM = nibRM.get_fdata() 
        iRM = nibiRM.get_fdata()

        RM = np.array(RM)
        iRM = np.array(iRM)

        RM = torch.from_numpy(RM)
        iRM = torch.from_numpy(iRM)

        '''load the datas'''
        name = datafiles["name"]
        ## nifti read codes. 
        niblabel = nib.load(datafiles["label"])  ## size 48^3
        nibD = nib.load(dipole_file)   ## size 64^3 
        ## nibmask = nib.load(datafiles["mask"])

        label = niblabel.get_fdata() 
        D = nibD.get_fdata() 
        ## invD = nibinvD.get_fdata()
        ## mask = nibmask.get_fdata()

        label = np.array(label)
        D = np.array(D)

        D = torch.from_numpy(D)
        ## invD = torch.from_numpy(invD)
        D = D.float()    # D size: 64^3 
        ## invD = invD.float()
        ## mask = torch.from_numpy(mask)

        label = torch.from_numpy(label)
        label = label.float()
        ##invD = np.array(invD)
        ##mask = np.array(mask)

        ## convert the image data to torch.tesors and return.
        label_img = F.pad(label, (8, 8, 8, 8, 8, 8), "constant", 0)  # image size: 64^3
        Mask = (label_img != 0).float()    ## get mask for loss calculation. 
        
        label_c = torch.zeros(64, 64, 64, 2)
        label_c[:,:,:,0] = label_img # real component set as label_img; 
        label_k = torch.fft(label_c, 3) ## fftn
        label_k = label_k.permute(3, 0, 1, 2)  ## re-shape

        input_k = label_k * D  ## forward calculation DFP 
        input_k = input_k.permute(1, 2, 3, 0)  ## re-shape. 

        input_img = torch.ifft(input_k, 3) ## F*DFP
        input_img = input_img[:,:,:,0]   ## get the real component

        input_img = input_img * Mask   ## mask out the bakground regions. 
        
        input_img = torch.unsqueeze(input_img, 0)
        label_img = torch.unsqueeze(label_img, 0)

        input_img = input_img.float()
        RM = RM.float()
        iRM = iRM.float()

        nibimg_axial = nib.load(datafiles["img"]) 
        input_axial = nibimg_axial.get_fdata() 

        input_axial = np.array(input_axial)

        input_axial = torch.from_numpy(input_axial)

        input_axial = input_axial.float()
        input_axial = F.pad(input_axial, (8, 8, 8, 8, 8, 8), "constant", 0)  # image size: 64^3
        input_axial = torch.unsqueeze(input_axial, 0)
        ## tkd_img = tkd_img.float()
        ## Inputs, Labels, Rot_mats, Inv_mats, Name 
        return input_axial, input_img, label_img, RM, iRM, name


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
    DATA_DIRECTORY = '.'
    DATA_LIST_PATH = './single_ori_IDs.txt'
    Batch_size = 1
    dst = yangDataSet(DATA_DIRECTORY,DATA_LIST_PATH)
    print(dst.__len__())
    # just for test,  so the mean is (0,0,0) to show the original images.
    # But when we are training a model, the mean should have another value
    # test code on personal computer: 
    trainloader = data.DataLoader(dst, batch_size = Batch_size, shuffle=True, drop_last = True)
    for i, Data in enumerate(trainloader):
        imgs, labels, RM, iRM, names = Data

        imgs = torch.squeeze(imgs, 0)
        labels = torch.squeeze(labels, 0)
        RM = torch.squeeze(RM, 0)
        iRM = torch.squeeze(iRM, 0)

        print(RM)
        print(iRM)

        imgs = imgs.numpy()
        labels = labels.numpy()

        path = 'data_label.mat'
        scio.savemat(path, {'PRED':labels})
        
        path = 'data_input.mat'
        scio.savemat(path, {'PRED':imgs})
