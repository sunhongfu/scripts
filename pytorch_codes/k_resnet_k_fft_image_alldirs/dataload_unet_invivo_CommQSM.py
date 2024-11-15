import numpy as np
import nibabel as nib
import torch
from torch.utils import data


class yangDataSet(data.Dataset):
    def __init__(self, root, z_prjs_file):
        super(yangDataSet, self).__init__()
        self.root = root

        self.z_prjs_file = z_prjs_file
        z_prjs_arr = [line.strip().split(" ") for line in open(z_prjs_file)]
        # convert z_prjs into a dic
        z_prjs_keys = [z_prjs_arr[i][0] for i in range(0, len(z_prjs_arr))]

        # get the number of files.
        self.img_ids = [i_id.strip() for i_id in z_prjs_keys]
        # print(self.img_ids)
        # get all fil names, preparation for get_item.
        # for example, we have two files:
        # 102-field.nii for input, and 102-phantom for label;
        # then image id is 102, and then we can use string operation
        # to get the full name of the input and label files.
        self.files = []
        for name in self.img_ids:
            field_file = self.root + \
                ("/alldirs_field/alldirs_field_%s.nii" % name)
            label_file = self.root + ("/alldirs_chi/alldirs_chi_%s.nii" % name)
            self.files.append({
                "field": field_file,
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
        nibfield = nib.load(datafiles["field"])
        niblabel = nib.load(datafiles["label"])

        field = nibfield.get_data()
        label = niblabel.get_data()

        field = np.array(field)
        label = np.array(label)
        label = label - np.mean(label)  # set the average of the recon as 0;

        # convert the field data to torch.tesors and return.
        field = torch.from_numpy(field)
        label = torch.from_numpy(label)

        # convert field and label into kspace
        field = torch.unsqueeze(field, 3)
        field = torch.cat([field, torch.zeros(field.shape)], 3)
        label = torch.unsqueeze(label, 3)
        label = torch.cat([label, torch.zeros(label.shape)], 3)

        field_k = torch.fft(field, 3)
        # label_k = torch.fft(label, 3)

        field_k = field_k.permute(3, 0, 1, 2)
        label = label.permute(3, 0, 1, 2)

        field_k = field_k.float()
        label = label.float()

        field_k[:, 0, 0, 0] = 0  # set the average of the recon as 0;

        return field_k, label, name


# before formal usage, test the validation of data loader.
if __name__ == '__main__':
    DATA_DIRECTORY = '/Volumes/LaCie/CommQSM/invivo/data_for_training'
    # DATA_LIST_PATH = '/Users/uqhsun8/Documents/MATLAB/scripts/pytorch_codes/invivo_IDs.txt'
    z_prjs_file = '/Users/uqhsun8/Documents/MATLAB/scripts/pytorch_codes/image_unet_stack_prjs_alldirs/z_prjs_alldirs.txt'
    Batch_size = 4
    dst = yangDataSet(DATA_DIRECTORY, z_prjs_file)
    print(dst.__len__())
    # just for test,  so the mean is (0,0,0) to show the original images.
    # But when we are training a model, the mean should have another value
    # test code on personal computer:
    trainloader = data.DataLoader(
        dst, batch_size=Batch_size, shuffle=False, drop_last=True)
    for i, Data in enumerate(trainloader):
        field_k, label, names = Data
        print(i)
        if i % 1 == 0:
            print(names)
            print(field_k.size())
            print(label.size())
