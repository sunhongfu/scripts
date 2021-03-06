import torch 
import torch.nn as nn 
import os
import torch.optim.lr_scheduler as LS

def save_checkpoints(net, optimizer, scheduler, epoch, folder_name):
    checkpoint = {
        "net": net.state_dict(),
        'optimizer':optimizer.state_dict(),
        "scheduler": scheduler.state_dict(), 
        "epoch": epoch
    }
    if not os.path.isdir(folder_name):
        os.mkdir(folder_name)
    path_checkpoint = folder_name + ('/RotNet_ckpt_training_%sEpoch.pth' %(str(epoch)))
    torch.save(checkpoint, path_checkpoint)

def load_checkpoints(path_checkpoint, net, optimizer, lr_scheduler):
    checkpoint = torch.load(path_checkpoint)  # load checkpoint

    net.load_state_dict(checkpoint["net"])  # load model parameters
    net.train()

    optimizer.load_state_dict(checkpoint["optimizer"])  # load optimizer parameters

    ## transfer optimizer buffer from cpu to gpu; 
    for k, v in optimizer.state.items():    # key is Parameter, val is a dict {key='momentum_buffer':tensor(...)}
        if 'momentum_buffer' not in v:
            continue
        optimizer.state[k]['momentum_buffer'] = optimizer.state[k]['momentum_buffer'].cuda()

    lr_scheduler_saved = LS.MultiStepLR(optimizer, milestones=[50, 80], gamma=0.1)
    lr_scheduler_saved.load_state_dict(checkpoint["scheduler"])
    lr_scheduler._step_count = lr_scheduler_saved._step_count
    lr_scheduler.last_epoch = lr_scheduler_saved.last_epoch

    start_epoch = checkpoint["epoch"]  # load saved_epoch
    return net, optimizer, lr_scheduler, start_epoch

