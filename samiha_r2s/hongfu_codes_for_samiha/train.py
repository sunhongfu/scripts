import torch.nn as nn
import torch
from torch.utils.data import DataLoader
from torch.utils.tensorboard import SummaryWriter
from transformer import Transformer
from dataloader import DataSet1
from dataloader import DataSet2
from dataloader import DataSet3
from dataloader import DataSet4
import os
import time

device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")

training_graphs = SummaryWriter(log_dir='training_graph/')
validation_graphs = SummaryWriter(log_dir='valid_graph/')

if __name__ == '__main__':
    # Batch_size = 4
    Batch_size = 2000


    # # Create the dataset and dataloader
    # h5_file_path = 'train_voxel_data.h5'
    # # dataset = DataSet1(h5_file_path)
    # dataset = DataSet1(h5_file_path) # DataSet1 is the fastest way so far
    
    ################################################################
    # multiple H5 files dataset
    h5_files = ['train_voxel_data_1_of_8.h5', 'train_voxel_data_2_of_8.h5', 'train_voxel_data_3_of_8.h5', 'train_voxel_data_4_of_8.h5',
            'train_voxel_data_5_of_8.h5', 'train_voxel_data_6_of_8.h5', 'train_voxel_data_7_of_8.h5', 'train_voxel_data_8_of_8.h5']
    dataset = DataSet4(h5_files)
    ################################################################

    trainloader = DataLoader(dataset, batch_size=Batch_size, shuffle=True)

    ################################################################
    # Validation DataLoader
    val_h5_file_path = 'val_voxel_data.h5'
    val_dataset = DataSet1(val_h5_file_path)
    val_loader = DataLoader(val_dataset, batch_size=Batch_size, shuffle=False)
    ################################################################

    R2s_Transformer = Transformer(d_model=256, num_heads=1, dropout=0.1, bias=True, batch_first=True, num_layers=4)
    R2s_Transformer = nn.DataParallel(R2s_Transformer)
    R2s_Transformer.to(device)

    optimizer = torch.optim.Adam(R2s_Transformer.parameters(), lr=0.0001, betas=(0.5, 0.999), eps=1e-9, weight_decay=5e-4)
    scheduler = torch.optim.lr_scheduler.StepLR(optimizer, step_size=50, gamma=0.1)
    criterion = nn.MSELoss(reduction='mean')

    Epoch = 100
    total_train_losses = []
    validation_loss = []

    for epoch in range(1, Epoch + 1):
        epoch_loss = 0.0

        epoch_start = time.time()  # Start time for the epoch

        for batch_no, data in enumerate(trainloader):
            mags, tes, r2s = data
            #import pdb; pdb.set_trace()
            mags = mags.unsqueeze(-1).to(device)
            tes = tes.unsqueeze(-1).to(device)
            r2s = r2s.unsqueeze(-1).to(device)
            optimizer.zero_grad()
            class_r2s = R2s_Transformer(src=tes, tgt=mags)
            loss = criterion(class_r2s.float(), r2s.float())
            loss.backward()
            optimizer.step()
            epoch_loss += loss.item()
            if batch_no % 1200 == 0:
                print({'epoch': epoch, 'batch_no': batch_no, 'lr_rate': optimizer.param_groups[0]['lr'], 'loss': loss.item()})

        scheduler.step()
        training_graphs.add_scalar('Loss/Train', epoch_loss, epoch)

        # Save checkpoint every 100 epochs directly in the loop
        if epoch % 5 == 0:
            checkpoint_dir = 'checkpoints'
            if not os.path.exists(checkpoint_dir):
                os.makedirs(checkpoint_dir)
            torch.save({
                'epoch': epoch,
                'model_state_dict': R2s_Transformer.module.state_dict() if isinstance(R2s_Transformer, nn.DataParallel) else R2s_Transformer.state_dict(),
                'optimizer_state_dict': optimizer.state_dict(),
                'scheduler_state_dict': scheduler.state_dict(),
            }, f'checkpoints/checkpoint_epoch_{epoch}.pth')        

        ################################################################
        # Validation phase
        R2s_Transformer.eval()  # Set the model to evaluation mode
        with torch.no_grad():
            val_loss = 0.0
            for data in val_loader:
                mags, tes, r2s = data
                mags = mags.unsqueeze(-1).to(device)
                tes = tes.unsqueeze(-1).to(device)
                r2s = r2s.unsqueeze(-1).to(device)

                class_r2s = R2s_Transformer(src=tes, tgt=mags)
                loss = criterion(class_r2s.float(), r2s.float())
                val_loss += loss.item()

            validation_graphs.add_scalar('Loss/Validation', val_loss, epoch)
        ################################################################

        epoch_end = time.time()  # End time for the epoch
        print({'epoch': epoch, 'epoch run time': epoch_end - epoch_start})


    training_graphs.close()
    validation_graphs.close()
