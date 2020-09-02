import numpy as np
import nibabel as nib
import torch
from torch.utils import data
import torch.nn.functional as F


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
            img_file = self.root + \
                ("/alldirs_field/alldirs_field_%s.nii" % name)
            label_file = self.root + ("/alldirs_chi/alldirs_chi_%s.nii" % name)
            rot_file = self.root + \
                ("/alldirs_rotation/alldirs_rot_mat_%s.nii" % name)
            inv_file = self.root + \
                ("/alldirs_rotation/alldirs_inv_mat_%s.nii" % name)
            self.files.append({
                "img": img_file,
                "label": label_file,
                "rot_mat": rot_file,
                "inv_mat": inv_file,
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
        niblabel = nib.load(datafiles["label"])
        nibrot = nib.load(datafiles["rot_mat"])
        nibinv = nib.load(datafiles["inv_mat"])

        image = nibimage.get_data()
        label = niblabel.get_data()
        rot_mat = nibrot.get_data()
        inv_mat = nibinv.get_data()

        image = np.array(image)
        label = np.array(label)
        rot_mat = np.array(rot_mat)
        inv_mat = np.array(inv_mat)

        # convert the image data to torch.tesors and return.
        image = torch.from_numpy(image)
        label = torch.from_numpy(label)
        rot_mat = torch.from_numpy(rot_mat)
        inv_mat = torch.from_numpy(inv_mat)

        image = torch.unsqueeze(image, 0)
        label = torch.unsqueeze(label, 0)
        rot_mat = torch.unsqueeze(rot_mat, 0)
        inv_mat = torch.unsqueeze(inv_mat, 0)

        image = image.float()
        label = label.float()
        rot_mat = rot_mat.float()
        inv_mat = inv_mat.float()

        image = F.pad(image, (8, 8, 8, 8, 8, 8), "constant", 0)
        label = F.pad(label, (8, 8, 8, 8, 8, 8), "constant", 0)

        return image, label, rot_mat, inv_mat, name


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
        imgs, labels, names = Data
        print(i)
        if i % 1 == 0:
            print(names)
            print(imgs.size())
            print(labels.size())
