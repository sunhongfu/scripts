#########  Network Training ####################
import torch
import torch.nn as nn
import torch.optim as optim
import time
import torch.optim.lr_scheduler as LS
from Unet import * 
from DeepResNet import *
from Rot_Functions import *
from data_load_C_D_Unet_new import *
#########  Section 1: DataSet Load #############

def CasForward(Net1, Net2, x, rot_mat, inv_mat):
    # x: shape: Nb * C * D * H * W,
    # rot_mat and inv_mat: Nb * 1 * 3 * 3

    x = rotate(x, rot_mat)  # rotate signal to the pure axial direction.

    x = Net1(x)

    x = rotate(x, inv_mat)  # rotate signal to the pure axial direction.

    x1 = x
    x2 = Net2(x1)

    # return x1, x2
    return x2

def yangDataLoad(Batch_size):
    DATA_DIRECTORY = '../..'
    DATA_LIST_PATH = './single_ori_IDs.txt'
    dst = yangDataSet(DATA_DIRECTORY, DATA_LIST_PATH)
    print('dataLength: %d' % dst.__len__())
    trainloader = data.DataLoader(
        dst, batch_size=Batch_size, shuffle=True, drop_last=True)
    return trainloader


def yangSaveNet(unet, resnet, enSave=False):
    print('save results')
    # save the
    if enSave:
        torch.save(
            resnet, '/scratch/itee/uqhsun8/CommQSM/pytorch_codes/casnet_mixed_alldirs/casnet_mixed_alldirs.pth')
    else:
        torch.save(resnet.state_dict(),
                   'Resnet_For_postprocessing.pth')
        torch.save(unet.state_dict(),
                   'Unet_for_axial_Recon.pth')


def yangTrainNet(unet, resnet, LR=0.001, Batchsize=32, Epoches=100, useGPU=False):
    print('DataLoad')
    trainloader = yangDataLoad(Batchsize)
    print('Dataload Ends')

    print('Training Begins')
    criterion = nn.MSELoss(reduction='sum')

    optimizer1 = optim.Adam(unet.parameters(), lr=LR)
    scheduler1 = LS.MultiStepLR(optimizer1, milestones=[50, 80], gamma=0.1)

    optimizer2 = optim.Adam(resnet.parameters(), lr=LR)
    scheduler2 = LS.MultiStepLR(optimizer2, milestones=[50, 80], gamma=0.1)
    # start the timer.
    time_start = time.time()
    if useGPU:
        if torch.cuda.is_available():
            print(torch.cuda.device_count(), "Available GPUs!")
            device = torch.device(
                "cuda:0" if torch.cuda.is_available() else "cpu")

            unet = nn.DataParallel(unet)
            unet.to(device)

            resnet = nn.DataParallel(resnet)
            resnet.to(device)

            for epoch in range(1, Epoches + 1):
                for i, data in enumerate(trainloader):
                    Inputs_axial, Inputs, Labels, Rot_mats, Inv_mats, Name = data

                    Inputs_axial = Inputs_axial.to(device)  ## inputs with dir [0,0,1]
                    Inputs = Inputs.to(device)
                    Labels = Labels.to(device)
                    Rot_mats = Rot_mats.to(device)
                    Inv_mats = Inv_mats.to(device)

                    # zero the gradient buffers
                    optimizer1.zero_grad()
                    optimizer2.zero_grad()
                    # forward:
                    
                    pred1 = unet(Inputs_axial)  ## unet trained on 0,0,1 data 
                    pred2 = CasForward(unet, resnet, Inputs, Rot_mats, Inv_mats)  ## casnet trained on all directions 

                    ###pred = resnet(Inputs, Rot_mats, Inv_mats)
                    
                    # loss
                    loss1 = criterion(pred1, Labels)
                    loss2 = criterion(pred2, Labels)
                    # backward
                    loss1.backward(retain_graph = True)
                    loss2.backward()
                    # learning one single step
                    optimizer1.step()
                    optimizer2.step()
                    # print statistical information
                    # print every 20 mini-batch size
                    if i % 19 == 0:
                        acc_loss1 = loss1.item()
                        acc_loss2 = loss2.item()
                        time_end = time.time()
                        print('Outside: Epoch : %d, batch: %d, Loss1: %f, Loss2: %f,  lr1: %f, used time: %d s' %
                              (epoch, i + 1, acc_loss1, acc_loss2, optimizer1.param_groups[0]['lr'], time_end - time_start))
                scheduler1.step()
                scheduler2.step()
        else:
            pass
            print('No Cuda Device!')
            quit()
    print('Training Ends')
    yangSaveNet(unet, resnet)


if __name__ == '__main__':
    # data load
    # create network
    unet = Unet(4)
    unet.apply(weights_init)
    unet.train()

    resnet = DeepResNet(1, 1)
    resnet.apply(weights_init)
    resnet.train()
    print('100 EPO-2L')
    #print(resnet.state_dict)
    #print(get_parameter_number(resnet))
    # use this line to check if all layers
    # are leanrable in this programe.
    # train network
    yangTrainNet(unet, resnet, LR=0.001, Batchsize=32, Epoches=100, useGPU=True)
