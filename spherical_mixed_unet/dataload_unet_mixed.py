import os
import numpy as np
import nibabel as nib
import random
import torch
from torch.utils import data


class yangDataSet(data.Dataset):
    def __init__(self, root, z_prjs_file):
        super(yangDataSet, self).__init__()
        self.root = root
        # self.list_path = list_path

        z_prjs_arr = [line.strip().split() for line in open(z_prjs_file)]
        # convert z_prjs into a dic
        z_prjs_keys = range(0, len(z_prjs_arr))
        z_prjs_values = [z_prjs_arr[i][0:3] for i in range(0, len(z_prjs_arr))]
        z_prjs_dict = dict(zip(z_prjs_keys, z_prjs_values))

        # get the number of files.
        self.img_ids = z_prjs_keys
        # print(self.img_ids)
        # get all fil names, preparation for get_item.
        # for example, we have two files:
        # 102-field.nii for input, and 102-phantom for label;
        # then image id is 102, and then we can use string operation
        # to get the full name of the input and label files.
        self.files = []
        for name in self.img_ids:
            img_file = self.root + \
                ("/spherical_dirs_field/spherical_dirs_field_%s.nii" % str(int(name)+1))
            label_file = self.root + ("/spherical_dirs_chi/spherical_dirs_chi_%s.nii" % str(int(name)+1))
            self.files.append({
                "img": img_file,
                "prjs": z_prjs_dict[name],
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
        nibimage = nib.load(datafiles["img"])
        niblabel = nib.load(datafiles['label'])

        image = nibimage.get_data()
        label = niblabel.get_data()

        image = np.array(image)
        label = np.array(label)

        prjs_elements = np.array([float(i) for i in datafiles["prjs"]])

        # convert the image data to torch.tesors and return.
        image = torch.from_numpy(image)
        label = torch.from_numpy(label)

        image = torch.unsqueeze(image, 0)
        label = torch.unsqueeze(label, 0)

        image = image.float()
        label = label.float()

        return image, prjs_elements, label, name


# before formal usage, test the validation of data loader.
if __name__ == '__main__':
    DATA_DIRECTORY = '/Volumes/LaCie_Top/obliqueQSM/data_prep/invivo/data_for_training'
    # DATA_LIST_PATH = '/Users/uqhsun8/Documents/MATLAB/scripts/pytorch_codes/invivo_IDs.txt'
    z_prjs_file = '/Users/uqhsun8/Documents/MATLAB/scripts/spherical_mixed_unet/prjs_sphere_15k.txt'
    Batch_size = 4
    dst = yangDataSet(DATA_DIRECTORY, z_prjs_file)
    print(dst.__len__())
    # just for test,  so the mean is (0,0,0) to show the original images.
    # But when we are training a model, the mean should have another value
    # test code on personal computer:
    trainloader = data.DataLoader(
        dst, batch_size=Batch_size, shuffle=True, drop_last=True)
    for i, Data in enumerate(trainloader):
        image, prjs_elements, label, name = Data
        print(i)
        if i % 1 == 0:
            print(name)
            print(image.size())
            print(label.size())
            print(prjs_elements.size())
