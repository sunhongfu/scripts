import os
import torch
import torch.nn as nn
from tqdm import tqdm
import logging
from utils import *
from modules import UNet
from torch.utils.tensorboard import SummaryWriter
import torch.fft as FFT
import numpy as np
import time

class Diffusion:
    def __init__(self, noise_steps=1000, beta_start=1e-4, beta_end=0.02, img_size=128, device="cuda"):
        self.noise_steps = noise_steps
        self.beta_start = beta_start
        self.beta_end = beta_end
        self.img_size = img_size
        self.device = device

        self.beta = self.prepare_noise_schedule().to(device)
        self.alpha = 1.0 - self.beta
        self.alpha_hat = torch.cumprod(self.alpha, dim=0)

    def prepare_noise_schedule(self):
        return torch.linspace(self.beta_start, self.beta_end, self.noise_steps)

    def noise_images(self, x_0, t): # size x_0 -> ?
        eps = torch.randn_like(x_0) # multivariate gaussian noise, mean 0 and covariance 1
        sqrt_alpha_hat = torch.sqrt(self.alpha_hat[t])[:, None, None, None] # reshape to 4 dimensions, but why?
        sqrt_one_minus_alpha_hat = torch.sqrt(1 - self.alpha_hat[t])[:, None, None, None]
        xt = sqrt_alpha_hat * x_0 + sqrt_one_minus_alpha_hat * eps
        return xt, eps

    def sample_timesteps(self, n): # randomly sample n timesteps from 1-t
        return torch.randint(low=1, high=self.noise_steps, size=(n,))

    def sample(self, model, n):
        logging.info(f"Sampling {n} new images....")
        model.eval()
        with torch.no_grad():
            x = torch.randn((n, 1, self.img_size, self.img_size)).to(self.device)
            # for i in tqdm(reversed(range(1, self.noise_steps)), position=0):
            for i in reversed(range(1, self.noise_steps)):
                t = (torch.ones(n) * i).long().to(self.device)
                predicted_noise = model(x, t)
                alpha = self.alpha[t][:, None, None, None]
                alpha_hat = self.alpha_hat[t][:, None, None, None]
                beta = self.beta[t][:, None, None, None]
                if i > 1:
                    noise = torch.randn_like(x)
                else:
                    noise = torch.zeros_like(x)
                x = 1 / torch.sqrt(alpha) * (x - ((1 - alpha) / (torch.sqrt(1 - alpha_hat))) * predicted_noise) + torch.sqrt(beta) * noise
        model.train()
        # x = (x.clamp(-1, 1) + 1) / 2
        # x = (x * 255).type(torch.uint8)
        return x

    def sample_guided(self, model, lowres_k, under_mask):
        logging.info(f"Sampling with low resolution guidance....")
        model.eval()

        lowres_k = lowres_k.to(self.device)
        under_mask = under_mask.to(self.device)

        with torch.no_grad():
            x = torch.randn((lowres_k.shape[0], 1, self.img_size, self.img_size)).to(self.device)
            for i in tqdm(range(self.noise_steps - 1, 0, -1), desc="Processing", ncols=100, position=0):
                t = (torch.ones(lowres_k.shape[0]) * i).long().to(self.device)
                predicted_noise = model(x, t)
                alpha = self.alpha[t][:, None, None, None]
                alpha_hat = self.alpha_hat[t][:, None, None, None]
                beta = self.beta[t][:, None, None, None]
                
                # kspace guidance
                if i > 1:
                    noise = torch.randn_like(lowres_k)
                else:
                    noise = torch.zeros_like(lowres_k)

                F_x_t = to_space(x)
                F_eps = to_space(noise)
                y_t = torch.sqrt(alpha) * lowres_k + torch.sqrt(beta) * F_eps

                if i < 100:
                    lmb = 0
                else:
                    lmb = 0

                x_t_prime = from_space(lmb * under_mask * y_t + (1 - lmb) * under_mask * F_x_t + (1 - under_mask) * F_x_t)
                x = torch.real(x_t_prime)

                # DDPM next time step (inverse), do not add noise in the last step
                if i > 1:
                    noise = torch.randn_like(x)
                else:
                    noise = torch.zeros_like(x)
                x = 1 / torch.sqrt(alpha) * (x - ((1 - alpha) / (torch.sqrt(1 - alpha_hat))) * predicted_noise) + torch.sqrt(beta) * noise   

        model.train()
        x = x.clamp(0, 1)
        # x = (x * 255).type(torch.uint8)
        return x



    def sampled_guided_ddim(self, model, lowres_k, under_mask, sampling_steps):
        logging.info(f"Sampling with low resolution guidance....")
        model.eval()

        lowres_k = lowres_k.to(self.device)
        under_mask = under_mask.to(self.device)

        with torch.no_grad():
            x = torch.randn((lowres_k.shape[0], 1, self.img_size, self.img_size)).to(self.device)
            tau = [round(i * self.noise_steps/sampling_steps) for i in range(sampling_steps)] # tau is a subset of t for acceleration
            for i in tqdm(range(sampling_steps - 1, 0, -1), desc="Processing", ncols=100, position=0): # no acceleration
                t = (torch.ones(lowres_k.shape[0]) * tau[i]).long().to(self.device)
                predicted_noise = model(x, t)
                alpha_hat = self.alpha_hat[t][:, None, None, None]
                beta = self.beta[t][:, None, None, None]
                # predict x0 from xt
                x0 = (x -  torch.sqrt(1 - alpha_hat) * predicted_noise) / torch.sqrt(alpha_hat)

                # perform inverse or projection on x0 to get x0_hat
                                
                if i < 0: # skip the last few projections and do free generation
                    lmb = 0
                else:
                    lmb = 0

                x0_hat = from_space(lmb * under_mask * lowres_k + (1 - lmb) * under_mask * to_space(x0) + (1 - under_mask) * to_space(x0))
                x0_hat = torch.real(x0_hat)

                # try the DPS method to update noise direction
                # try proximity method 

                if i > 1: # back to time step t-1                    
                    t_next = (torch.ones(lowres_k.shape[0]) * tau[i-1]).long().to(self.device)
                    predicted_noise_hat = (x - torch.sqrt(alpha_hat) * x0_hat) / torch.sqrt(1 - alpha_hat)
                    alpha_hat_next = self.alpha_hat[t_next][:, None, None, None]
                    eta = 1
                    sigma = eta * torch.sqrt((1 - alpha_hat_next) / (1 - alpha_hat)) * torch.sqrt(beta)
                    # 1. original noise
                    x = torch.sqrt(alpha_hat_next) * x0_hat + torch.sqrt(1 - alpha_hat_next - sigma ** 2) * predicted_noise + sigma * torch.randn_like(x)
                    # # 2. new noise changed direction
                    # x = torch.sqrt(alpha_hat_next) * x0_hat + torch.sqrt(1 - alpha_hat_next - sigma ** 2) * predicted_noise_hat + sigma * torch.randn_like(x)
                    # # 3. PPN complete random noise
                    # x = torch.sqrt(alpha_hat_next) * x0_hat + torch.sqrt(1 - alpha_hat_next) * torch.randn_like(x)
                else:
                    x = x0_hat

            model.train()
            x = x.clamp(0, 1)
            # x = (x * 255).type(torch.uint8)
            return x



def train(args):
    setup_logging(args.run_name)
    device = args.device
    dataloader = get_data(args)
    model = UNet(device=device).to(device)
    optimizer = torch.optim.AdamW(model.parameters(), lr=args.lr)
    mse = nn.MSELoss()
    diffusion = Diffusion(img_size=args.image_size, device=device)
    logger = SummaryWriter(os.path.join("runs", args.run_name))
    l = len(dataloader) # number of items in a dataloader

    # start the timer.
    time_start = time.time()

    for epoch in range(args.epochs):
        logging.info(f"Starting epoch {epoch}:")
        # pbar = tqdm(dataloader) # display the progress bar? what about remote?
        for i, (images, _) in enumerate(dataloader):
            images = images.to(device)
            t = diffusion.sample_timesteps(images.shape[0]).to(device) # t from 1 to 999 including 1 and 999
            x_t, noise = diffusion.noise_images(images, t)
            predicted_noise = model(x_t, t)
            loss = mse(noise, predicted_noise)

            optimizer.zero_grad()
            loss.backward()
            optimizer.step()

            if (i+1) % 20 == 0:
                acc_loss = loss.item()
                time_end = time.time()
                print('Epoch : %d, batch: %d, Loss: %f,  lr1: %f, used time: %d s' %
                        (epoch, i + 1, acc_loss, optimizer.param_groups[0]['lr'], time_end - time_start))

            # pbar.set_postfix(MSE=loss.item())
            logger.add_scalar("MSE", loss.item(), global_step=epoch*l + i)
        
        if (epoch+1) % 100 == 0:
            sampled_images = diffusion.sample(model, n=args.batch_size)
            save_images(sampled_images, os.path.join("results", args.run_name, f"sample_epoch{epoch}"))
            # torch.save(model.state_dict(), os.path.join("models", args.run_name, f"ckpt_epoch{epoch}.pt"))
            torch.save({
                'epoch': epoch,
                'model_state_dict': model.state_dict(),
                'optimizer_state_dict': optimizer.state_dict(),
                'loss': loss,
                # Add any other relevant information you want to save
            }, os.path.join("models", args.run_name, f"ckpt_epoch{epoch}.pt"))




def launch():
    import argparse
    parser = argparse.ArgumentParser()
    args = parser.parse_args()
    args.run_name = "DDPM_Unconditional"
    args.epochs = 10000
    args.batch_size = 24
    args.image_size = 384
    args.dataset_path = "/scratch/project/deepmri/hongfu/3T_dwi"
    args.device = "cuda"
    args.lr = 3e-4
    train(args)


if __name__ == "__main__":
    launch()
