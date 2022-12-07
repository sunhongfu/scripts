################### train DCRNet #####################
#########  Network Training #################### 
import torch 
import torch.nn as nn
import torch.optim as optim
import torch.optim.lr_scheduler as LS
import time
from TrainingDataLoad import *
from MRSNet import * 
 
#########  Section 1: DataSet Load #############
def DataLoad(Batch_size):
    DATA_DIRECTORY = '../'
    DATA_LIST_PATH = './test_IDs.txt'

    dst = DataSet(DATA_DIRECTORY,DATA_LIST_PATH)
    print('dataLength: %d'%dst.__len__())
    trainloader = data.DataLoader(dst, batch_size = Batch_size, shuffle=True, drop_last = True)
    return trainloader

def SaveNet(dcrnet, epo, enSave = False):
    print('save results')
    #### save the
    if enSave:
        pass
    else:
        torch.save(dcrnet.state_dict(), './MRSNet_AF4_final.pth')
        torch.save(dcrnet.state_dict(), ("MRSNet_AF4_%s.pth" % epo))

def TrainNet(dcrnet, LR = 0.001, Batchsize = 64, Epoches = 300 , useGPU = True):
    print('DeepResNet')
    print('DataLoad')
    trainloader = DataLoad(Batchsize)
    print('Dataload Ends')

    print('Training Begins')
    criterion = nn.MSELoss(size_average=None, reduce=None, reduction='sum')
    optimizer2 = optim.Adam(dcrnet.parameters())
    scheduler2 = LS.MultiStepLR(optimizer2, milestones = [50,100,150,200,250], gamma = 0.7)
    
    layer_num = dcrnet.LayerNo
    ## start the timer. 
    time_start=time.time()
    if useGPU:
        if torch.cuda.is_available():
            print(torch.cuda.device_count(), "Available GPUs!")
            device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
            dcrnet = nn.DataParallel(dcrnet)
            dcrnet.to(device)

            for epoch in range(1, Epoches + 1):
                
                if epoch % 20 == 0:
                    SaveNet(dcrnet, epoch, enSave = False)

                acc_loss = 0.0
                for i, data in enumerate(trainloader):
                    image_r, image_i, masks, label_r, label_i, linewidths, Name = data
                    image_r = image_r.to(device)
                    image_i = image_i.to(device)
                    label_r = label_r.to(device)
                    label_i = label_i.to(device)
                    masks = masks.to(device)
                    linewidths = linewidths.to(device)

                    ###print(image_i.size())
                    ## zero the gradient buffers 
                    optimizer2.zero_grad()
                    ## forward: 
                    pred_r, pred_i, floss_r, floss_i = dcrnet(image_r, image_i, masks, linewidths, device)

                    loss1 = criterion(pred_r, label_r)
                    loss2 = criterion(pred_i, label_i)

                    loss_constraint = torch.mean(torch.pow(floss_r[0], 2))
                    for k in range(layer_num - 1):
                        loss_constraint += torch.mean(torch.pow(floss_r[k+1], 2))
                        loss_constraint += torch.mean(torch.pow(floss_i[k+1], 2))

                    loss = loss1 + loss2 + 5e-5 * loss_constraint

                    loss.backward()
                    ##
                    optimizer2.step()
                    optimizer2.zero_grad()
                    
                    ## print statistical information 
                    ## print every 20 mini-batch size
                    if i % 20 == 0:
                        acc_loss1 = (loss1 + loss2).item()   
                        acc_loss2 = loss_constraint.item()
                        time_end=time.time()
                        print('Outside: Epoch : %d, batch: %d, Loss_final: %f, loss_sym: %f, \n lr2: %f, used time: %d s' %
                            (epoch, i + 1, acc_loss1, acc_loss2, optimizer2.param_groups[0]['lr'], time_end - time_start))   
                scheduler2.step()
        else:
            pass
            print('No Cuda Device!')
            quit()        
    print('Training Ends')
    SaveNet(dcrnet, Epoches, enSave = False)

if __name__ == '__main__':
    ## data load
    ## create network 
    dcrnet = MRSNet(12)
    print(dcrnet.state_dict)
    print(get_parameter_number(dcrnet))
    ## train network
    TrainNet(dcrnet, LR = 0.001, Batchsize = 64, Epoches = 300, useGPU = True)

