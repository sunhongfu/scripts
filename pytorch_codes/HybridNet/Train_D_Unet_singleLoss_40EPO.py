#########  Network Training #################### 
import torch 
import torch.nn as nn
import torch.optim as optim
import time
import torch.optim.lr_scheduler as LS
from HybridNet import *
from data_load_C_D_Unet_new import *
#########  Section 1: DataSet Load #############
def yangDataLoad(Batch_size):
    DATA_DIRECTORY = '../..'
    DATA_LIST_PATH = './triple_ori_IDs.txt'
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
        torch.save(resnet.state_dict(), './ksapceQSM_Unet_40EPO_SingleOri_singleLoss_test_0p2Noise.pth')


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
                    Inputs_img, Inputs_tkd, Labels_img, Name = data  
                    if i == 1:
                        print('file_name:', Name)
                    Inputs_img = Inputs_img.to(device)
                    Labels_img = Labels_img.to(device)
                    Inputs_tkd = Inputs_tkd.to(device)
                    ## zero the gradient buffers 
                    optimizer.zero_grad()
                    ## forward: 
                    pred_img, pred_tkd = resnet(Inputs_img, Inputs_tkd)
                    ## loss
                    loss1 = criterion(pred_tkd, Labels_img)
                    #loss2 = criterion(DataFidelity(pred_k, D), Inputs_img)
                    loss3 = criterion(pred_img, Labels_img)

                    ## loss_t = 0.1 * loss + loss3
                    ## backward
                    loss1.backward(retain_graph = True)
                    #loss2.backward(retain_graph = True)
                    loss3.backward()
                    ## learning one single step
                    optimizer.step()
                    ## print statistical information 
                    ## print every 20 mini-batch size
                    if i % 19 == 0:
                        acc_loss1 = loss1.item()  
                        #acc_loss2 = loss2.item() 
                        acc_loss3 = loss3.item()
                        time_end=time.time()
                        print('Outside: Epoch : \n %d, batch: %d,Loss1: %f,  Loss3: %f, \n lr1: %f, used time: %d s' %
                            (epoch, i + 1, acc_loss1, acc_loss3, optimizer.param_groups[0]['lr'], time_end - time_start))    
                scheduler.step()       
        else:
            pass
            print('No Cuda Device!')
            quit()        
    print('Training Ends')
    yangSaveNet(resnet)

if __name__ == '__main__':
    ## create network 
    Hnet = HybridNet(1,1)
    Hnet.apply(weights_init)
    Hnet.train()
    print('40 EPO, SingleLoss')
    print(Hnet.state_dict)
    print(get_parameter_number(Hnet))
    ###### use this line to check if all layers 
    ###### are leanrable in this programe. 
    ## train network
    yangTrainNet(Hnet,  LR = 0.001, Batchsize = 32, Epoches = 40 , useGPU = True)
