#########  Network Training #################### 
import torch 
import torch.nn as nn
import torch.optim as optim
import time
import torch.optim.lr_scheduler as LS
from hybirdnet import *
from data_load_C_D_Unet import *
#########  Section 1: DataSet Load #############
def yangDataLoad(Batch_size):
    DATA_DIRECTORY = '..'
    DATA_LIST_PATH = './single_ori_IDs.txt'
    dst = yangDataSet(DATA_DIRECTORY,DATA_LIST_PATH)
    print('dataLength: %d'%dst.__len__())
    trainloader = data.DataLoader(dst, batch_size = Batch_size, shuffle=True, drop_last = True)
    return trainloader

def yangSaveNet(resnet, enSave = False):
    print('save results')
    #### save the
    if enSave:
        torch.save(resnet, './D_Unet.pth')
    else:
        torch.save(resnet.state_dict(), './ksapceQSM_Unet_100EPO_SingleOri_singleLoss_test_0p2Noise.pth')


def DataFidelity(x_k, D):
    x_k = x_k * D  ## forward calculation in k-space. 
    x_k = x_k.permute(0, 2, 3, 4, 1)  ## FFT reconstruciton block. 
    x_k = x_k * 1e3
    ##print(x_k.size())
    x_img = torch.ifft(x_k, 3)
    x_img = x_img[:,:,:,:,0]  ## get the real channel. 0： real channel, 1, imaginary channel.
    x_img = torch.unsqueeze(x_img, 1) ## reshape as Nb * 1 * H * W * C. 
    return x_img


def yangTrainNet(resnet, LR = 0.001, Batchsize = 32, Epoches = 100 , useGPU = False):
    print('ResNet')
    print('DataLoad')
    trainloader = yangDataLoad(Batchsize)
    print('Dataload Ends')

    print('Training Begins')
    criterion = nn.MSELoss(reduction='sum')
    criterion2 = nn.L1Loss()
    optimizer = optim.Adam(resnet.parameters(), lr = LR)
    scheduler = LS.MultiStepLR(optimizer, milestones = [50, 80], gamma = 0.1)
    ## start the timer. 
    time_start=time.time()
    if useGPU:
        if torch.cuda.is_available():
            print(torch.cuda.device_count(), "Available GPUs!")
            device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
            resnet = nn.DataParallel(resnet)
            resnet.to(device)
            ## send Dipole to GPU:
            for epoch in range(1, Epoches + 1):
                acc_loss = 0.0
                for i, data in enumerate(trainloader):
                    Inputs, Inputs_img, Labels, Labels_img, D, Name = data  
                    if i == 1:
                        print('file_name:', Name)
                    Inputs = Inputs.to(device)
                    Inputs_img = Inputs_img.to(device)
                    Labels = Labels.to(device)
                    Labels_img = Labels_img.to(device)
                    D = D.to(device)
                    ## zero the gradient buffers 
                    optimizer.zero_grad()
                    ## forward: 
                    pred_img, pred_k, img1, img2 = resnet(Inputs_img, Inputs, D)
                    ## loss
                    loss1 = criterion2(pred_k, Labels)  ## L1 norm for k-space data. 
                    loss2 = criterion(DataFidelity(pred_k, D), Inputs_img)
                    loss3 = criterion(pred_img, Labels_img)
                    loss4 = criterion(img1, img2)
                    ## backward
                    loss4.backward(retain_graph=True)
                    loss3.backward()
                    ## learning one single step
                    optimizer.step()
                    ## print statistical information 
                    ## print every 20 mini-batch size
                    if i % 19 == 0:
                        acc_loss1 = loss1.item()  
                        acc_loss2 = loss2.item() 
                        acc_loss3 = loss3.item()
                        time_end=time.time()
                        print('Outside: Epoch : \n %d, batch: %d, Loss1: %f, Loss2: %f, Loss3: %f, \n lr1: %f, used time: %d s' %
                            (epoch, i + 1, acc_loss1, acc_loss2, acc_loss3, optimizer.param_groups[0]['lr'], time_end - time_start))    
                scheduler.step()       
        else:
            pass
            print('No Cuda Device!')
            quit()        
    print('Training Ends')
    yangSaveNet(resnet)

if __name__ == '__main__':
    ## create network 
    resnet = Hnet()
    resnet.apply(weights_init)
    resnet.train()
    print('100 EPO, SingleLoss')
    print(resnet.state_dict)
    print(get_parameter_number(resnet))
    ###### use this line to check if all layers 
    ###### are leanrable in this programe. 
    ## train network
    yangTrainNet(resnet,  LR = 0.001, Batchsize = 32, Epoches = 100 , useGPU = True)
