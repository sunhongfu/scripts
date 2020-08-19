import os
import numpy as np
import nibabel as nib
import random
import torch
from torch.utils import data


class yangDataSet(data.Dataset):
    def __init__(self, root, list_path):
        super(yangDataSet, self).__init__()
        self.root = root
        self.list_path = list_path

        # get the number of files.
        self.img_ids = [i_id.strip() for i_id in open(list_path)]
        # print(self.img_ids)
        # get all fil names, preparation for get_item.
        # for example, we have two files:
        # 102-field.nii for input, and 102-phantom for label;
        # then image id is 102, and then we can use string operation
        # to get the full name of the input and label files.
        self.files = []
        for name in self.img_ids:
            real_img_file = self.root + \
                ("/field_kspace_shift/real_field_kspace_shift_%s.nii" % name)
            imag_img_file = self.root + \
                ("/field_kspace_shift/imag_field_kspace_shift_%s.nii" % name)
            D = self.root + \
                ("/D_shift/D_shift_%s.nii" % name)
            label_file = self.root + ("/chi/chi_%s.nii" % name)
            self.files.append({
                "real_img": real_img_file,
                "imag_img": imag_img_file,
                "D": D,
                "label": label_file,
                "name": name
            })
        # sprint(self.files)

    def __len__(self):
        return len(self.files)

    def __getitem__(self, index):
        datafiles = self.files[index]

        '''load the datas'''
        name = datafiles["name"]
        # nifti read codes.
        nibimage1 = nib.load(datafiles["real_img"])
        nibimage2 = nib.load(datafiles["imag_img"])
        nibD = nib.load(datafiles["D"])
        niblabel = nib.load(datafiles["label"])

        real_img = nibimage1.get_data()
        imag_img = nibimage2.get_data()
        D = nibD.get_data()
        label = niblabel.get_data()

        real_img = np.array(real_img)
        imag_img = np.array(imag_img)
        D = np.array(D)
        label = np.array(label)

        # convert the image data to torch.tesors and return.
        real_img = torch.from_numpy(real_img)
        imag_img = torch.from_numpy(imag_img)
        D = torch.from_numpy(D)
        label = torch.from_numpy(label)

        real_imag_D = torch.stack(
            [real_img.float(), imag_img.float(), D.float()], 0)
        label = torch.unsqueeze(label, 0)

        real_imag_D = real_imag_D.float()
        label = label.float()

        return real_imag_D, label, name


# before formal usage, test the validation of data loader.
if __name__ == '__main__':
    DATA_DIRECTORY = '/scratch/itee/uqhsun8/CommQSM/invivo'
    DATA_LIST_PATH = '/scratch/itee/uqhsun8/CommQSM/invivo/invivo_IDs.txt'
    Batch_size = 4
    dst = yangDataSet(DATA_DIRECTORY, DATA_LIST_PATH)
    print(dst.__len__())
    # just for test,  so the mean is (0,0,0) to show the original images.
    # But when we are training a model, the mean should have another value
    # test code on personal computer:
    trainloader = data.DataLoader(
        dst, batch_size=Batch_size, shuffle=False, drop_last=True)
    for i, Data in enumerate(trainloader):
        real_imag_D, labels, names = Data
        print(i)
        if i % 1 == 0:
            print(names)
            print(real_imag_D.size())
            print(labels.size())
