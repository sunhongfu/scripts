#########  Network Training ####################
import torch
import torch.nn as nn
import torch.optim as optim
import time
import torch.optim.lr_scheduler as LS
from D_Unet import *
from dataload_D_Unet import *
#########  Section 1: DataSet Load #############


def yangDataLoad(Batch_size):
    DATA_DIRECTORY = '/scratch/itee/uqhsun8/CommQSM/invivo'
    z_prjs_file = '/scratch/itee/uqhsun8/CommQSM/pytorch_codes/multiple_prjs_unet_alldirs/z_prjs_alldirs.txt'
    dst = yangDataSet(DATA_DIRECTORY, z_prjs_file)
    print('dataLength: %d' % dst.__len__())
    trainloader = data.DataLoader(
        dst, batch_size=Batch_size, shuffle=True, drop_last=True)
    return trainloader


def yangSaveNet(resnet, enSave=False):
    print('save results')
    # save the
    if enSave:
        torch.save(
            resnet, '/scratch/itee/uqhsun8/CommQSM/pytorch_codes/multiple_prjs_unet_alldirs/multiple_prjs_unet_alldirs.pth')
    else:
        torch.save(resnet.state_dict(
        ), '/scratch/itee/uqhsun8/CommQSM/pytorch_codes/multiple_prjs_unet_alldirs/multiple_prjs_unet_alldirs.pth')


def yangTrainNet(resnet, LR=0.001, Batchsize=32, Epoches=100, useGPU=False):
    print('ResNet')
    print('DataLoad')
    trainloader = yangDataLoad(Batchsize)
    print('Dataload Ends')

    print('Training Begins')
    criterion = nn.MSELoss(reduction='sum')
    optimizer = optim.Adam(resnet.parameters(), lr=LR)
    scheduler = LS.MultiStepLR(optimizer, milestones=[50, 80], gamma=0.1)
    # start the timer.
    time_start = time.time()
    if useGPU:
        if torch.cuda.is_available():
            print(torch.cuda.device_count(), "Available GPUs!")
            device = torch.device(
                "cuda:0" if torch.cuda.is_available() else "cpu")
            resnet = nn.DataParallel(resnet)
            resnet.to(device)
            # send Dipole to GPU:
            for epoch in range(1, Epoches + 1):
                acc_loss = 0.0
                for i, data in enumerate(trainloader):
                    Inputs, Labels, prjs, Name = data

                    prjs = prjs.to(device)
                    Inputs = Inputs.to(device)
                    Labels = Labels.to(device)
                    # zero the gradient buffers
                    optimizer.zero_grad()
                    # forward:
                    pred = resnet(Inputs, prjs)
                    # loss
                    loss = criterion(pred, Labels)
                    # backward
                    loss.backward()
                    # learning one single step
                    optimizer.step()
                    # print statistical information
                    # print every 20 mini-batch size
                    if i % 19 == 0:
                        acc_loss = loss.item()
                        time_end = time.time()
                        print('Outside: Epoch : %d, batch: %d, Loss: %f,  lr1: %f, used time: %d s' %
                              (epoch, i + 1, acc_loss, optimizer.param_groups[0]['lr'], time_end - time_start))
                scheduler.step()
        else:
            pass
            print('No Cuda Device!')
            quit()
    print('Training Ends')
    yangSaveNet(resnet)


if __name__ == '__main__':
    # loading Unit Dipole in nii format.
    # e.g., filename = 'dipole.nii', or 'dipole.mat'
    """
    nib_D = nib.load('dipole.nii')  
    #mat_D = scio.loadmat('dipole.mat', verify_compressed_data_integrity=False)
    #D = mat_D['D'] 
    D = nib_D.get_data() 
    D = np.array(D)
    """
    # create network
    resnet = Unet(2)
    resnet.apply(weights_init)
    resnet.train()
    print('100 EPO')
    print(resnet.state_dict)
    print(get_parameter_number(resnet))
    # use this line to check if all layers
    # are leanrable in this programe.
    # train network
    yangTrainNet(resnet,  LR=0.001, Batchsize=32, Epoches=200, useGPU=True)
