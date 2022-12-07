import torch
import torch.nn as nn
import torch.nn.functional as F

class UNet(nn.Module):
    def __init__(self, c_in=4, c_out=2, time_dim=256, device="cuda") -> None:
        super().__init__()
        self.device = device
        self.time_dim = time_dim
        self.inc = DoubleConv(c_in, 64) # input channel
        self.down1 = Down(64, 128)
        self.sa1 = SelfAttention(128)
        self.down2 = Down(128, 256)
        self.sa2 = SelfAttention(256)
        self.down3 = Down(256, 256)
        self.sa3 = SelfAttention(256)

        self.bot1 = DoubleConv(256, 512)
        self.bot2 = DoubleConv(512, 512)
        self.bot3 = DoubleConv(512, 256)

        self.up1 = Up(512, 128) # 512 channels including 256 from skip connection
        self.sa4 = SelfAttention(128)
        self.up2 = Up(256, 64)
        self.sa5 = SelfAttention(64)
        self.up3 = Up(128, 64)
        self.sa6 = SelfAttention(64)
        self.outc = nn.Conv2d(64, c_out, kernel_size=1) # output channel

    def pos_encoding(self, t, channels):
        inv_freq = 1.0 / (
            10000
            ** (torch.arange(0, channels, 2, device=self.device).float() / channels)
        )
        pos_enc_a = torch.sin(t.repeat(1, channels // 2) * inv_freq)
        pos_enc_b = torch.cos(t.repeat(1, channels // 2) * inv_freq)
        pos_enc = torch.cat([pos_enc_a, pos_enc_b], dim=-1)
        return pos_enc

    def forward(self, x, t, condition):
        t = t.unsqueeze(-1).type(torch.float) # size of t?
        t = self.pos_encoding(t, self.time_dim) # size of t?

        x1 = self.inc(torch.cat((x, condition), 1))
        x2 = self.down1(x1, t)
        # x2 = self.sa1(x2)
        x3 = self.down2(x2, t)
        # x3 = self.sa2(x3)
        x4 = self.down3(x3, t)
        x4 = self.sa3(x4)
        
        x4 = self.bot1(x4)
        x4 = self.bot2(x4)
        x4 = self.bot3(x4)

        x = self.up1(x4, x3, t)
        # x = self.sa4(x)
        x = self.up2(x, x2, t)
        # x = self.sa5(x)
        x = self.up3(x, x1, t)
        # x = self.sa6(x)
        output = self.outc(x)
        return output




class DoubleConv(nn.Module):
    def __init__(self, in_channels, out_channels, mid_channels=None, residual=False):
        super().__init__()
        self.residual = residual
        if not mid_channels:
            mid_channels = out_channels

        self.doubleconv = nn.Sequential(
            nn.Conv2d(in_channels, mid_channels, kernel_size=3, padding=1, bias=False),
            nn.GroupNorm(1, mid_channels), # batchNorm
            nn.GELU(),
            nn.Conv2d(mid_channels, out_channels, kernel_size=3, padding=1, bias=False),
            nn.GroupNorm(1, out_channels), # batchNorm
        )

    def forward(self, x):
        if not self.residual:
            return self.doubleconv(x)
        else:
            return F.gelu(x + self.doubleconv(x))

        

class Down(nn.Module):
    def __init__(self, in_channels, out_channels, emb_dim=256) -> None:
        super().__init__()

        self.maxpool_conv = nn.Sequential(
            nn.MaxPool2d(2),
            DoubleConv(in_channels, in_channels, residual=True),
            DoubleConv(in_channels, out_channels),
        )

        self.emb_layer = nn.Sequential(
            nn.SiLU(),
            nn.Linear(emb_dim, out_channels)
        )
        
    def forward(self, x, t):
        x = self.maxpool_conv(x)
        emb = self.emb_layer(t)[:, :, None, None].repeat(1, 1, x.shape[-2], x.shape[-1])
        return x + emb


class Up(nn.Module):
    def __init__(self, in_channels, out_channels, emb_dim=256) -> None:
        super().__init__()
        
        self.up = nn.Upsample(scale_factor=2, mode='bilinear', align_corners=True)

        self.conv = nn.Sequential(
            DoubleConv(in_channels, in_channels, residual=True),
            DoubleConv(in_channels, out_channels, in_channels // 2)
        )

        self.emb_layer = nn.Sequential(
            nn.SiLU(),
            nn.Linear(emb_dim, out_channels)
        )

    def forward(self, x, skip_x, t):
        x = self.up(x)
        x = torch.cat([skip_x, x], dim=1) # concat in the channel dimension
        x = self.conv(x)
        emb = self.emb_layer(t)[:, :, None, None].repeat(1, 1, x.shape[-2], x.shape[-1])
        return x + emb


class SelfAttention(nn.Module):
    def __init__(self, channels) -> None:
        super().__init__() ################## pay attention here, different from tutorial
        self.channels = channels
        self.mha = nn.MultiheadAttention(channels, 4, batch_first=True)

        self.ln = nn.LayerNorm([channels]) # norm each token, serves as instance norm

        self.ff_self = nn.Sequential(
            nn.LayerNorm([channels]),
            nn.Linear(channels, channels),
            nn.GELU(),
            nn.Linear(channels, channels)
        )

    def forward(self, x): # x size: batch, channel, imsize1, imsize2
        imsize = x.shape
        x = x.view(-1, self.channels, imsize[-2] * imsize[-1]).swapaxes(1,2)
        # change x size to: batch, imsize1*imsize2, channel
        x_ln = self.ln(x) # serves as instance norm
        attention_value, _ = self.mha(x_ln, x_ln, x_ln)
        attention_value = attention_value + x # residual
        attention_value = self.ff_self(attention_value) + attention_value # FF and residual
        return attention_value.swapaxes(2,1).view(-1, self.channels, imsize[-2], imsize[-1])









