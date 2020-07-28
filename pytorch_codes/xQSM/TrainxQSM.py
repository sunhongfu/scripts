################### train OctNet #####################
#########  Network Training #################### 
import torch 
import torch.nn as nn
import torch.optim as optim
import time
from yangMFOctnet import *
from yangDataLoad import *
#########  Section 1: DataSet Load #############
def yangDataLoad(Batch_size):
    DATA_DIRECTORY = '..'
    DATA_LIST_PATH = './test_IDs.txt'
    dst = yangDataSet(DATA_DIRECTORY,DATA_LIST_PATH)
    print('dataLength: %d'%dst.__len__())
    trainloader = data.DataLoader(dst, batch_size = Batch_size, shuffle=True, drop_last = True)
    return trainloader

def yangSaveNet(octnet, enSave = False):
    print('save results')
    #### save the
    if enSave:
        torch.save(octnet, './yangEntireOctNet.pth')
    else:
        torch.save(octnet.state_dict(), './MFOCTQSM_48_Patch_20EPO_2222L.pth')

def yangTrainNet(octnet, LR = 0.001, Batchsize = 32, Epoches = 40 , useGPU = True):
    print('OctNet')
    print('DataLoad')
    trainloader = yangDataLoad(Batchsize)
    print('Dataload Ends')

    print('Training Begins')
    criterion = nn.MSELoss(reduction='sum')
    optimizer = optim.Adam(octnet.parameters(), lr = LR)
    ## start the timer. 
    time_start=time.time()
    if useGPU:
        if torch.cuda.is_available():
            print(torch.cuda.device_count(), "Available GPUs!")
            device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
            octnet = nn.DataParallel(octnet)
            octnet.to(device)
            for epoch in range(1, Epoches + 1):
                acc_loss = 0.0
                for i, data in enumerate(trainloader):
                    Inputs, Labels, Name = data
                    Inputs = Inputs.to(device)
                    Labels = Labels.to(device)
                    ## zero the gradient buffers 
                    optimizer.zero_grad()
                    ## forward: 
                    pred = octnet(Inputs)
                    ## loss
                    loss = criterion(pred, Labels)
                    ## backward
                    loss.backward()
                    ## learning one single step
                    optimizer.step()
                    ## print statistical information 
                    ## print every 20 mini-batch size
                    if i % 19 == 0:
                        acc_loss = loss.item()   
                        time_end=time.time()
                        print('Outside: Epoch : %d, batch: %d, Loss: %f, used time: %d s' %
                            (epoch, i + 1, acc_loss, time_end - time_start))      
        else:
            pass
            print('No Cuda Device!')
            quit()        
    print('Training Ends')
    yangSaveNet(octnet)

if __name__ == '__main__':
    ## data load
    ## create network 
    octnet = OctNet(2)
    octnet.apply(weights_init)
    print(octnet.state_dict()['FinalOct.FinalConv.bias'])
    print(octnet.state_dict)
    print(get_parameter_number(octnet))
    ###### use this line to check if all layers 
    ###### are leanrable in this programe. 
    print('20EPO')
    ## train network
    yangTrainNet(octnet, LR = 0.001, Batchsize = 32, Epoches = 20 , useGPU = True)

