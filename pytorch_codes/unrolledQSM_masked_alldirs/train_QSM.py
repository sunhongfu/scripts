import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils import data
import time
import torch.optim.lr_scheduler as LS
from model_QSM import unrolledQSM
from model_QSM import weights_init
from model_QSM import get_parameter_number
from data_QSM import data_QSM
import os
from Net_Load import load_state_keywise
from utils_checkpoints import save_checkpoints


def DataLoad(Batch_size):
    DATA_DIRECTORY = '/scratch/itee/uqhsun8/CommQSM/invivo'
    z_prjs_file = '/scratch/itee/uqhsun8/CommQSM/pytorch_codes/image_unet_stack_prjs_alldirs/z_prjs_alldirs.txt'
    dataset = data_QSM(DATA_DIRECTORY, z_prjs_file)
    print('dataLength: %d' % dataset.__len__())
    trainloader = data.DataLoader(
        dataset, batch_size=Batch_size, shuffle=True, drop_last=True)
    return trainloader


def SaveNet(net, enSave=False):
    print('save results')
    # save the
    os.makedirs(
        '/scratch/itee/uqhsun8/CommQSM/pytorch_codes/unrolledQSM_masked_alldirs', exist_ok=True)
    if enSave:
        torch.save(
            net, '/scratch/itee/uqhsun8/CommQSM/pytorch_codes/unrolledQSM_masked_alldirs/unrolledQSM_masked_alldirs.pth')
    else:
        torch.save(net.state_dict(),
                   '/scratch/itee/uqhsun8/CommQSM/pytorch_codes/unrolledQSM_masked_alldirs/unrolledQSM_masked_alldirs.pth')


def TrainNet(net, LR=0.001, Batchsize=32, Epoches=100, useGPU=False, RESUME=False, path_checkpoint=None, save_folder='./checkpoints'):
    print('unrolledQSM_masked_alldirs')
    print('DataLoad')
    trainloader = DataLoad(Batchsize)
    print('Dataload Ends')

    print('Training Begins')
    criterion = nn.MSELoss(reduction='sum')
    optimizer = optim.Adam(net.parameters(), lr=LR)
    scheduler = LS.MultiStepLR(optimizer, milestones=[50, 80], gamma=0.1)
    # start the timer.
    time_start = time.time()
    if useGPU:
        if torch.cuda.is_available():
            print(torch.cuda.device_count(), "Available GPUs!")
            device = torch.device(
                "cuda:0" if torch.cuda.is_available() else "cpu")
            net = nn.DataParallel(net)

            start_epoch = 0
            # -- resume the checkpoints. --
            if RESUME:
                net, optimizer, scheduler, start_epoch = load_checkpoints(
                    path_checkpoint, net, optimizer, scheduler)

            net.to(device)
            for epoch in range(1, Epoches + 1):
                acc_loss = 0.0
                for i, values in enumerate(trainloader):
                    fields, Dipoles, labels, masks, names = values
                    fields = fields.to(device)
                    Dipoles = Dipoles.to(device)
                    labels = labels.to(device)
                    masks = masks.to(device)
                    # zero the gradient buffers
                    optimizer.zero_grad()
                    # forward:
                    preds = net(torch.zeros(fields.shape),
                                fields, Dipoles, masks)
                    # preds = preds*masks
                    # loss
                    loss = criterion(preds, labels)
                    # loss = criterion(preds*masks, labels)
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
                    save_checkpoints(net, optimizer,
                                     scheduler, epoch, save_folder)
        else:
            pass
            print('No Cuda Device!')
            quit()
    print('Training Ends')
    SaveNet(net)


if __name__ == '__main__':
    # data load
    # create network
    net = unrolledQSM()
    net.apply(weights_init)

    # net = nn.DataParallel(net)
    # net.load_state_dict(torch.load('unrolledQSM_masked_alldirs.pth', map_location='cpu'))

    load_state_keywise(net, 'unrolledQSM_masked_alldirs.pth')

    net.train()
    print('100 EPO-2L')
    print(net.state_dict)
    print(get_parameter_number(net))
    # use this line to check if all layers
    # are leanrable in this programe.
    # train network
    TrainNet(net, LR=0.001, Batchsize=32, Epoches=50, useGPU=True)
