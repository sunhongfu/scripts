import numpy as np
import nibabel as nib
import torch
from torch.utils import data


class data_QSM(data.Dataset):
    def __init__(self, data_path, list_file):
        super(data_QSM, self).__init__()
        self.data_path = data_path
        self.list_file = list_file

        # get the number of files.
        self.img_ids = [i_id.strip() for i_id in open(list_file)]
        # print(self.img_ids)
        # get all fil names, preparation for get_item.
        # for example, we have two files:
        # 102-field.nii for input, and 102-phantom for label;
        # then image id is 102, and then we can use string operation
        # to get the full name of the input and label files.
        self.files = []
        for name in self.img_ids:
            phi_file = self.data_path + ("/field/field_%s.nii" % name)
            chi_file = self.data_path + ("/chi/chi_%s.nii" % name)
            D_file = self.data_path + ("/D_shift/D_shift_%s.nii" % name)

            self.files.append({
                "name": name,
                "field": phi_file,
                "Dipole": D_file,
                "label": chi_file
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
        nibDipole = nib.load(datafiles["Dipole"])
        niblabel = nib.load(datafiles["label"])

        field = nibfield.get_data()
        Dipole = nibDipole.get_data()
        label = niblabel.get_data()

        field = np.array(field)
        Dipole = np.array(Dipole)
        label = np.array(label)

        # convert the field data to torch.tesors and return.
        field = torch.from_numpy(field)
        Dipole = torch.from_numpy(Dipole)
        label = torch.from_numpy(label)

        field = torch.unsqueeze(field, 0)
        Dipole = torch.unsqueeze(Dipole, 0)
        label = torch.unsqueeze(label, 0)

        mask = torch.zeros(Dipole.shape)
        mask[label == 0] = 1

        # extend into 2 channels (real + imag)
        field = torch.cat([field, torch.zeros(field.shape)], 0)
        # keep Dipole single real channel, can do broadcasting during complex multiplication
        # Dipole = torch.cat([Dipole, Dipole], 0)
        label = torch.cat([label, torch.zeros(label.shape)], 0)

        field = field.float()
        Dipole = Dipole.float()
        label = label.float()
        mask = mask.float()

        return field, Dipole, label, mask, name


# before formal usage, test the validation of data loader.
if __name__ == '__main__':
    DATA_DIRECTORY = '/Volumes/LaCie/CommQSM/invivo/data_for_training'
    DATA_LIST_PATH = '/Users/uqhsun8/Documents/MATLAB/scripts/pytorch_codes/invivo_IDs.txt'
    Batch_size = 4
    dst = data_QSM(DATA_DIRECTORY, DATA_LIST_PATH)
    print(dst.__len__())
    # just for test,  so the mean is (0,0,0) to show the original images.
    # But when we are training a model, the mean should have another value
    # test code on personal computer:
    trainloader = data.DataLoader(
        dst, batch_size=Batch_size, shuffle=False, drop_last=True)
    for i, values in enumerate(trainloader):
        fields, Dipoles, labels, names = values
        print(i)
        if i % 1 == 0:
            print(names)
            print(fields.size())
            print(Dipoles.size())
            print(labels.size())
