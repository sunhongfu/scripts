#########  Network Training ####################
import torch
import torch.nn as nn
import torch.optim as optim
import time
import torch.optim.lr_scheduler as LS
from ResNet_yang import *
from dataload_unet_mixed import *
#########  Section 1: DataSet Load #############


def yangDataLoad(Batch_size):
    DATA_DIRECTORY = '/scratch/itee/uqhsun8/spherical_mixed_unet_data'
    z_prjs_file = '/scratch/itee/uqhsun8/spherical_mixed_unet_data/prjs_sphere_15k.txt'
    dst = yangDataSet(DATA_DIRECTORY, z_prjs_file)
    print('dataLength: %d' % dst.__len__())
    trainloader = data.DataLoader(
        dst, batch_size=Batch_size, shuffle=True, drop_last=True)
    return trainloader


def yangSaveNet(resnet, epoch_num, enSave=False):
    print('save results')
    os.makedirs('/clusterdata/uqhsun8/codes/spherical_mixed_unet/models', exist_ok=True)
    # save the
    if enSave:
        torch.save(
            resnet, '/clusterdata/uqhsun8/codes/spherical_mixed_unet/models/mixed_unet_epoch' + str(epoch_num) + '.pth')
    else:
        torch.save(resnet.state_dict(),
                   '/clusterdata/uqhsun8/codes/spherical_mixed_unet/models/mixed_unet_epoch' + str(epoch_num) + '.pth')

def yangTrainNet(resnet, LR=0.001, Batchsize=32, Epoches=100, useGPU=True):
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
        # if True:
            print(torch.cuda.device_count(), "Available GPUs!")
            device = torch.device(
                "cuda:0" if torch.cuda.is_available() else "cpu")
            resnet = nn.DataParallel(resnet)
            resnet.to(device)
            for epoch in range(1, Epoches + 1):
                acc_loss = 0.0
                for i, data in enumerate(trainloader):
                    Inputs, prjs_elements, Labels, Name = data
                    prjs_elements = prjs_elements.type(torch.float32)
                    Inputs = Inputs.to(device)
                    Labels = Labels.to(device)
                    prjs_elements = prjs_elements.to(device)
                    # zero the gradient buffers
                    optimizer.zero_grad()
                    # forward:
                    pred = resnet(Inputs, prjs_elements)
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
                if (epoch+1) % 10 == 0:
                    yangSaveNet(resnet, epoch+1)
        else:
            pass
            print('No Cuda Device!')
            quit()
    print('Training Ends')
    yangSaveNet(resnet, epoch+1)


if __name__ == '__main__':
    # data load
    # create network
    resnet = ResNet(2)
    resnet.apply(weights_init)
    resnet.train()
    print('100 EPO-2L')
    print(resnet.state_dict)
    print(get_parameter_number(resnet))
    # use this line to check if all layers
    # are leanrable in this programe.
    # train network
    yangTrainNet(resnet, LR=0.001, Batchsize=32, Epoches=200, useGPU=True)
