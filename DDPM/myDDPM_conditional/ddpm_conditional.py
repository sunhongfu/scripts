import os
import torch
import torch.nn as nn
from tqdm import tqdm
import logging
from utils import *
from modules import UNet
from torch.utils.tensorboard import SummaryWriter


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

    def sample(self, model, condition):
        logging.info(f"Sampling new images....")
        model.eval()
        with torch.no_grad():
            x = torch.randn((1, 2, self.img_size, self.img_size)).to(self.device)
            for i in tqdm(reversed(range(1, self.noise_steps)), position=0):
                t = (torch.ones(1) * i).long().to(self.device)
                predicted_noise = model(x, t, condition.to(self.device))
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

    for epoch in range(args.epochs):
        logging.info(f"Starting epoch {epoch}:")
        pbar = tqdm(dataloader) # display the progress bar? what about remote?
        for i, (images, _) in enumerate(pbar):
            images_full = images[0].to(device)
            images_under = images[1].to(device)
            t = diffusion.sample_timesteps(images_full.shape[0]).to(device)
            x_t, noise = diffusion.noise_images(images_full, t)
            predicted_noise = model(x_t, t, images_under)
            loss = mse(noise, predicted_noise)

            optimizer.zero_grad()
            loss.backward()
            optimizer.step()

            pbar.set_postfix(MSE=loss.item())
            logger.add_scalar("MSE", loss.item(), global_step=epoch*l + i)
        
        sampled_images = diffusion.sample(model, args.condition)
        save_images(sampled_images, os.path.join("results", args.run_name, f"sample_epoch{epoch}"))
        torch.save(model.state_dict(), os.path.join("modules", args.run_name, f"ckpt_epoch{epoch}.pt"))




def launch():
    import argparse
    parser = argparse.ArgumentParser()
    args = parser.parse_args()
    args.run_name = "DDPM_Unconditional"
    args.epochs = 500
    args.batch_size = 12

    test_sample = np.load('/home/Staff/uqhsun8/sunlab/Hongfu/complex_2d_images_full_undersampled_test_sampling/_home_Staff_uqhsun8_sunlab_Share_raw_kspace_128_MS_TIA_kspace_trainData_TIA_brooklyn_QSMpatients_51_100_PREVENT_099_study_QSM_SPGR_GE/120.npy')[:,:,1] # load in an undersampled condition for sampling
    zero_filled_condition = test_sample/np.max(np.abs(test_sample))
    zero_filled_condition = np.stack((np.real(zero_filled_condition), np.imag(zero_filled_condition)), axis=0)
    args.condition = torch.unsqueeze(torch.from_numpy(zero_filled_condition).float(), 0)

    args.image_size = 128
    args.dataset_path = "/home/Staff/uqhsun8/sunlab/Hongfu/complex_2d_images_full_undersampled"
    args.device = "cuda"
    args.lr = 3e-4
    train(args)


if __name__ == "__main__":
    launch()