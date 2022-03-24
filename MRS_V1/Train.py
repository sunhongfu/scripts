import torch
import os
import torch.backends.cudnn as cudnn
import argparse
from torch.utils.data import DataLoader
from MrsNet import MRSNet, weights_init

from utils.Dataloader import Dataset

from utils.Dataloader_512 import Dataset_512
parser = argparse.ArgumentParser(description='MRSNet')

parser.add_argument('--batchSize', type=int, default=10, help='Training batch size')
parser.add_argument('--testBatchSize', type=int, default=10, help='Testing batch size')
parser.add_argument('--nEpochs', type=int, default=100, help='Number of epochs to train for')
parser.add_argument('--lr', type=float, default=0.001, help='Learning Rate. Default=0.01')
parser.add_argument('--seed', type=int, default=1, help='Random seed to use. Default=1')
opt = parser.parse_args()

class proj1():
    def __init__(self, config, training_set, testing_set):
        super(proj1, self).__init__()
        self.CUDA = torch.cuda.is_available()
        self.device = torch.device('cuda' if self.CUDA else 'cpu')
        self.model = None
        self.lr = config.lr
        self.nEpochs = config.nEpochs
        self.criterion = None
        self.optimizer = None
        self.scheduler = None
        self.seed = config.seed
        self.training_set = training_set
        self.testing_set = testing_set

    def build_model(self):
        self.model = MRSNet(5).to(self.device)
        self.model.apply(weights_init)
        self.criterion = torch.nn.MSELoss()
        torch.manual_seed(self.seed)

        if self.CUDA:
            torch.cuda.manual_seed(self.seed)
            cudnn.benchmark = True
            self.criterion.cuda()

        self.optimizer = torch.optim.Adam(self.model.parameters(), lr=self.lr)
        self.scheduler = torch.optim.lr_scheduler.MultiStepLR(self.optimizer, milestones=[25, 50, 75], gamma=0.1)

    def save_checkpoint(self, epoch):
        model_out_path = "checkpoint_256/" + "model_epoch_{}.pth".format(epoch)
        state = {"epoch": epoch, "model": self.model}
        if not os.path.exists("checkpoint_256/"):
            os.makedirs("checkpoint_256/")

        torch.save(state, model_out_path)

        print("Checkpoint saved to {}".format(model_out_path))

    def train(self):
        self.model.train()
        print('<==============================================================Train start==============================================================>')
        train_loss_y = 0
        train_loss_ini = 0
        for i, data in enumerate(self.training_set):
            samp_r, samp_i, samp_dft_r, samp_dft_i, full_dft_r, full_dft_i, mask = data
            samp_r = samp_r.to(self.device)
            samp_i = samp_i.to(self.device)
            # full_r = full_r.to(self.device)
            # full_i = full_i.to(self.device)
            samp_dft_r = samp_dft_r.to(self.device)
            samp_dft_i = samp_dft_i.to(self.device)
            full_dft_r = full_dft_r.to(self.device)
            full_dft_i = full_dft_i.to(self.device)
            mask = mask.to(self.device)
            self.optimizer.zero_grad()
            ini_r, ini_i, y_r, y_i = self.model(samp_dft_r, samp_dft_i, samp_r, samp_i, mask)

            loss1 = self.criterion(y_r, full_dft_r)
            loss2 = self.criterion(y_i, full_dft_i)

            loss3 = self.criterion(ini_r, full_dft_r)
            loss4 = self.criterion(ini_i, full_dft_i)

            loss_y = loss1 + loss2
            loss_ini = loss3 + loss4
            train_loss_y += loss_y.item()
            train_loss_ini += loss_ini.item()
            loss_ini.backward(retain_graph=True)
            loss_y.backward()

            self.optimizer.step()
            # print(i, 'Loss_y: {}'.format(loss_y), 'Loss_ini: {}'.format(loss_ini))



        print("    Average Loss: {}".format(train_loss_y))
        print('    Learning Rate: {}'.format(self.optimizer.param_groups[0]['lr']))

    def test(self):
        self.model.eval()
        print('<==============================================================Test start==============================================================>')
        train_loss_y = 0
        train_loss_ini = 0
        with torch.no_grad():
            for i, data in enumerate(self.testing_set):
                samp_r, samp_i, samp_dft_r, samp_dft_i, full_dft_r, full_dft_i, mask = data
                samp_r = samp_r.to(self.device)
                samp_i = samp_i.to(self.device)
                # full_r = full_r.to(self.device)
                # full_i = full_i.to(self.device)
                samp_dft_r = samp_dft_r.to(self.device)
                samp_dft_i = samp_dft_i.to(self.device)
                full_dft_r = full_dft_r.to(self.device)
                full_dft_i = full_dft_i.to(self.device)
                mask = mask.to(self.device)

                ini_r, ini_i, y_r, y_i = self.model(samp_dft_r, samp_dft_i, samp_r, samp_i, mask)

                loss1 = self.criterion(y_r, full_dft_r)
                loss2 = self.criterion(y_i, full_dft_i)

                loss3 = self.criterion(ini_r, full_dft_r)
                loss4 = self.criterion(ini_i, full_dft_i)

                loss_y = loss1 + loss2
                loss_ini = loss3 + loss4
                train_loss_y += loss_y.item()
                train_loss_ini += loss_ini.item()

                # print(i, 'Loss_y: {}'.format(loss_y), 'Loss_ini: {}'.format(loss_ini))

        print("   Test Average Loss: {}".format(train_loss_y))
        print("   Test Average Loss Without DC: {}".format(train_loss_ini))

    def run(self):
        self.build_model()
        for epoch in range(1, self.nEpochs + 1):
            print("\n===> Epoch {} starts:".format(epoch))
            self.train()
            self.test()
            self.scheduler.step()
            self.save_checkpoint(epoch)

def main():
    opt = parser.parse_args()
    print(opt)

    print("===> Loading datasets")
    # Load train set
    train_path = 'train_dataset_256/'
    train_dataset = Dataset(train_path)
    train_dataloader = DataLoader(train_dataset, shuffle=True, batch_size=opt.batchSize)
    # Load test set
    test_path = 'test_dataset_256/'
    test_dataset = Dataset(test_path)
    test_dataloader = DataLoader(test_dataset, shuffle=True, batch_size=opt.testBatchSize)
    model = proj1(opt, train_dataloader, test_dataloader)
    model.run()


if __name__ == "__main__":
    main()