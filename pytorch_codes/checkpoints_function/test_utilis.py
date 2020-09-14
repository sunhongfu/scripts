import torch 
import torch.nn as nn
import random
import numpy as np
import torch.optim as optim
import time

from utils_checkpoints import *


def set_random_seed(seed = 0,deterministic=False,benchmark=False):
    np.random.seed(seed)
    torch.manual_seed(seed)
    torch.cuda.manual_seed_all(seed)
    if deterministic:
        torch.backends.cudnn.deterministic = True
    if benchmark:
        torch.backends.cudnn.benchmark = True

"""
This is only a simple net for testing this script. 
"""
class TestNet(nn.Module):
    def __init__(self):
        super(TestNet, self).__init__()
        self.conv1 = nn.Conv2d(1, 1, 3, padding = 1)

    def forward(self, x):
        x = self.conv1(x)
        return x


def yangTrainNet(resnet, LR=0.001, Batchsize=32, Epoches=100, useGPU=False, RESUME = False, path_checkpoint = None, 
                save_folder = './checkpoints'):
    ## -- this is to ensure the training process is repeatable on the same device
    ## comment this line, if you want every training is independently random. 
    set_random_seed(seed = 0)
    ## -- can be removed in the formal training. 

    criterion = nn.MSELoss(reduction='sum')
    optimizer = optim.Adam(resnet.parameters(), lr=LR)
    scheduler = LS.MultiStepLR(optimizer, milestones=[50, 80], gamma=0.1)
    # start the timer.
    time_start = time.time()

    labels = torch.randn(1, 1, 128, 128)
    inputs = torch.randn(1,1,128, 128)

    if useGPU:
        if torch.cuda.is_available():
            print(torch.cuda.device_count(), "Available GPUs!")
            device = torch.device(
                "cuda:0" if torch.cuda.is_available() else "cpu")
            resnet = nn.DataParallel(resnet)
            labels = labels.to(device)
            inputs = inputs.to(device)
            start_epoch  = 0
            # -- resume the checkpoints. --
            print(RESUME)
            if RESUME:
                resnet, optimizer, scheduler, start_epoch = load_checkpoints(path_checkpoint, resnet, optimizer, scheduler)
                print(start_epoch)
                
            resnet.to(device)
            for epoch in range(start_epoch + 1, Epoches + 1):
                acc_loss = 0.0
                for i in range(1, 2):
                    # zero the gradient buffers
                    optimizer.zero_grad()
                    # forward:
                    pred = resnet(inputs)
                    # loss
                    loss = criterion(pred, labels)
                    # backward
                    loss.backward()
                    # learning one single step
                    optimizer.step()
                    # print statistical information
                    # print every 20 mini-batch size
                    if i % 1 == 0:
                        acc_loss = loss.item()
                        time_end = time.time()
                        print('Outside: Epoch : %d, batch: %d, Loss: %f,  lr1: %f, used time: %d s' %
                              (epoch, i + 1, acc_loss, optimizer.param_groups[0]['lr'], time_end - time_start))
                scheduler.step()
                if epoch % 40  == 0:
                    save_checkpoints(resnet, optimizer, scheduler, epoch , save_folder)
        else:
            pass
            print('No Cuda Device!')
            quit()
    print('Training Ends')
    save_checkpoints(resnet, optimizer, scheduler, 100, save_folder)

def weights_init(m):
    if isinstance(m, nn.Conv2d):
        nn.init.normal_(m.weight, mean=0.0, std=1e-2)
        nn.init.zeros_(m.bias)   
    if isinstance(m, nn.ConvTranspose2d):
        nn.init.normal_(m.weight, mean=0, std=1e-2)
        nn.init.zeros_(m.bias)   
    if isinstance(m, nn.BatchNorm2d):
        nn.init.ones_(m.weight)
        nn.init.zeros_(m.bias)   

def get_parameter_number(net):
    total_num = sum(p.numel() for p in net.parameters())
    trainable_num = sum(p.numel() for p in net.parameters() if p.requires_grad)
    return {'Total': total_num, 'Trainable': trainable_num}

if __name__ == '__main__':
    resnet = TestNet()
    resnet.apply(weights_init)
    resnet.train()
    print('100 EPO-2L')
    print(resnet.state_dict)
    print(get_parameter_number(resnet))
    # use this line to check if all layers
    # are leanrable in this programe.
    # train network
    ## -- direct train -- 100 epochs
    yangTrainNet(resnet, LR=0.001, Batchsize=32, Epoches=100, useGPU=True)

    ## test the resume from the checkpoints, from 40 epoch. 
    resnet = TestNet()
    resnet.apply(weights_init)
    resnet.train()
    print('100 EPO-2L')
    print(resnet.state_dict)
    print(get_parameter_number(resnet))
    yangTrainNet(resnet, LR=0.001, Batchsize=32, Epoches=100, useGPU=True, RESUME = True,
                path_checkpoint = './checkpoints/RotNet_ckpt_training_40Epoch.pth', 
                save_folder = './Resume_checkpoints')


    """ comparison of the final parameter values 
        if the resume training is correct, we will 
        get exactly the same value in both training 
        stratergies. 
    """
    resnet = TestNet()
    resnet.apply(weights_init)
    resnet = nn.DataParallel(resnet)
    # direct training;
    checkpoint = torch.load('./checkpoints/RotNet_ckpt_training_80Epoch.pth')  # load checkpoint :80epoch

    resnet.load_state_dict(checkpoint["net"])  # load model parameters
    resnet.eval()

    params = list(resnet.named_parameters())
    for (name, param) in params:
        print(name, param)

    resnet = TestNet()
    resnet.apply(weights_init)
    resnet = nn.DataParallel(resnet)
    # Resumet training;
    checkpoint = torch.load('./Resume_checkpoints/RotNet_ckpt_training_80Epoch.pth')  # load checkpoint : 80epoch

    resnet.load_state_dict(checkpoint["net"])  # load model parameters
    resnet.eval()

    params = list(resnet.named_parameters())
    for (name, param) in params:
        print(name, param)


