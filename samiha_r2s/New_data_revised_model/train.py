import torch.nn as nn
import torch
from torch.utils.data import DataLoader
from torch.utils.tensorboard import SummaryWriter
from transformer import Transformer
from dataloader import DataSet1

device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")

training_graphs = SummaryWriter(log_dir='/home/samiha/PycharmProjects/new_data_gen/models/training_graph/')
validation_graphs = SummaryWriter(log_dir='/home/samiha/PycharmProjects/new_data_gen/models/valid_graph/')

if __name__ == '__main__':
    Batch_size = 4

    # Create the dataset and dataloader
    h5_file_path = '/home/samiha/PycharmProjects/new_data_gen/rician_data_gen/voxel_data.h5'
    dataset = DataSet1(h5_file_path)
    trainloader = DataLoader(dataset, batch_size=Batch_size, shuffle=True)

    R2s_Transformer = Transformer(d_model=256, num_heads=1, dropout=0.1, bias=True, batch_first=True, num_layers=4)
    R2s_Transformer = nn.DataParallel(R2s_Transformer)
    R2s_Transformer.to(device)

    optimizer = torch.optim.Adam(R2s_Transformer.parameters(), lr=0.0001, betas=(0.5, 0.999), eps=1e-9, weight_decay=5e-4)
    scheduler = torch.optim.lr_scheduler.StepLR(optimizer, step_size=50, gamma=0.1)
    criterion = nn.MSELoss(reduction='mean')

    Epoch = 500
    total_train_losses = []
    validation_loss = []

    for epoch in range(1, Epoch + 1):
        epoch_loss = 0.0

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

    training_graphs.close()
    validation_graphs.close()
