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
            img_file = self.root + ("/Field_VIVO/%s-Field_NIFTI.nii" % name)
            label_file = self.root + ("/QSM_VIVO/%s-Phantom_NIFTI.nii" % name)
            dipole_file = "/scratch/itee/uqhsun8/CommQSM/pytorch_codes/dipole.nii"
            self.files.append({
                "img": img_file,
                "label": label_file,
                "dipole": dipole_file,
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
        nibimage = nib.load(datafiles["img"])
        niblabel = nib.load(datafiles["label"])
        nibDipole = nib.load(datafiles["dipole"])

        image = nibimage.get_data() 
        label = niblabel.get_data() 
        D = nibDipole.get_data() 

        image = np.array(image)
        label = np.array(label)
        D = np.array(D)

        ## convert the image data to torch.tesors and return. 
        image = torch.from_numpy(image) 
        label = torch.from_numpy(label)
        D = torch.from_numpy(D)

        image = torch.unsqueeze(image, 0)
        label = torch.unsqueeze(label, 0)
        D = torch.unsqueeze(D, 0)

        image = image.float()
        label = label.float()
        D = D.float()
        
        return image, label, D, name
 
## before formal usage, test the validation of data loader. 
if __name__ == '__main__':
    DATA_DIRECTORY = '../QSM'
    DATA_LIST_PATH = '../QSM/test_IDs.txt'
    Batch_size = 4
    dst = yangDataSet(DATA_DIRECTORY,DATA_LIST_PATH)
    print(dst.__len__())
    # just for test,  so the mean is (0,0,0) to show the original images.
    # But when we are training a model, the mean should have another value
    # test code on personal computer: 
    trainloader = data.DataLoader(dst, batch_size = Batch_size, shuffle=False, drop_last = True)
    for i, Data in enumerate(trainloader):
        imgs, labels, D, names = Data
        print(i)
        if i%1 == 0:
            print(names)
            print(D.size())
            print(imgs.size())
            print(labels.size())
