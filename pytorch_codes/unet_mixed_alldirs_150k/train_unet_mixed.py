#########  Network Training ####################
import torch
import torch.nn as nn
import torch.optim as optim
import time
import torch.optim.lr_scheduler as LS
from ResNet_yang import *
from dataload_unet_mixed import *
from utils_checkpoints import *
#########  Section 1: DataSet Load #############


def yangDataLoad(Batch_size):
    DATA_DIRECTORY = '/scratch/itee/uqhsun8/CommQSM/invivo'
    z_prjs_file = '/scratch/itee/uqhsun8/CommQSM/pytorch_codes/unet_mixed_alldirs_150k/z_prjs_alldirs.txt'
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
            resnet, '/scratch/itee/uqhsun8/CommQSM/pytorch_codes/unet_mixed_alldirs_150k/unet_mixed_alldirs_150k.pth')
    else:
        torch.save(resnet.state_dict(),
                   '/scratch/itee/uqhsun8/CommQSM/pytorch_codes/unet_mixed_alldirs_150k/unet_mixed_alldirs_150k.pth')


def yangTrainNet(resnet, LR=0.001, Batchsize=32, Epoches=100, useGPU=False, RESUME=False, path_checkpoint=None, save_folder='./checkpoints'):
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

            start_epoch = 0
            # -- resume the checkpoints. --
            if RESUME:
                resnet, optimizer, scheduler, start_epoch = load_checkpoints(
                    path_checkpoint, resnet, optimizer, scheduler)

            resnet.to(device)
            for epoch in range(start_epoch + 1, start_epoch + Epoches + 1):
                acc_loss = 0.0
                for i, data in enumerate(trainloader):
                    Inputs, Labels, Name = data
                    Inputs = Inputs.to(device)
                    Labels = Labels.to(device)
                    # zero the gradient buffers
                    optimizer.zero_grad()
                    # forward:
                    pred = resnet(Inputs)
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
                if epoch % 10 == 0:
                    save_checkpoints(resnet, optimizer,
                                     scheduler, epoch, save_folder)
        else:
            pass
            print('No Cuda Device!')
            quit()
    print('Training Ends')
    yangSaveNet(resnet)
    save_checkpoints(resnet, optimizer, scheduler, Epoches+1, save_folder)


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
    yangTrainNet(resnet, LR=0.001, Batchsize=32, Epoches=50, useGPU=True, RESUME=True,
                 path_checkpoint='./checkpoints/RotNet_ckpt_training_50Epoch.pth', save_folder='./checkpoints')
