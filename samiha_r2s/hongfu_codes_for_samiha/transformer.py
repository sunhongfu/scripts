import torch
import torch.nn as nn
from einops import repeat

class ImageReconstruction(nn.Module):
    def __init__(self, inputs):
        super(ImageReconstruction, self).__init__()
        dropout_rate = 0.4
        self.input_feature = inputs
        hidden_layers_1 = 1024
        self.fc1 = nn.Linear(inputs, hidden_layers_1)
        self.ln1 = nn.LayerNorm(hidden_layers_1)

        hidden_layers_2 = 512
        self.fc2 = nn.Linear(hidden_layers_1, hidden_layers_2)
        self.ln2 = nn.LayerNorm(hidden_layers_2)

        hidden_layers_3 = 256
        self.fc3 = nn.Linear(hidden_layers_2, hidden_layers_3)
        self.ln3 = nn.LayerNorm(hidden_layers_3)

        hidden_layers_4 = 128
        self.fc4 = nn.Linear(hidden_layers_3, hidden_layers_4)
        self.ln4 = nn.LayerNorm(hidden_layers_4)

        hidden_layers_5 = 64
        self.fc5 = nn.Linear(hidden_layers_4, hidden_layers_5)
        self.ln5 = nn.LayerNorm(hidden_layers_5)

        self.fc6 = nn.Linear(hidden_layers_5, 1)
        self.relu = nn.ReLU()
        self.gelu = nn.GELU()
        self.drop_out = nn.Dropout(dropout_rate)

    def forward(self, x):
        x = x.view(x.size(0), -1)
        x = self.fc1(x)
        x = self.ln1(x)
        x = self.gelu(x)

        x = self.fc2(x)
        x = self.ln2(x)
        x = self.gelu(x)
        x = self.drop_out(x)

        x = self.fc3(x)
        x = self.ln3(x)
        x = self.gelu(x)
        x = self.drop_out(x)

        x = self.fc4(x)
        x = self.ln4(x)
        x = self.gelu(x)
        x = self.drop_out(x)

        x = self.fc5(x)
        x = self.ln5(x)
        x = self.gelu(x)
        x = self.drop_out(x)

        x = self.fc6(x)
        return x


def make_padding_mask(input_ids, padding_idx=0):
    padding_mask = input_ids.eq(padding_idx).clone().detach().to(torch.bool)
    return padding_mask

class Transformer(nn.Module):
    def __init__(self, d_model, num_heads, dropout, bias=True, batch_first=True, num_layers=6):
        super(Transformer, self).__init__()
        self.source_emb = nn.Linear(in_features=1, out_features=256)
        self.target_emb = nn.Linear(in_features=1, out_features=256)
        self.class_token = nn.Parameter(torch.randn(1, 1, 256))
        self.nhead = num_heads
        self.d_model = d_model
        self.num_layers = num_layers

        self.decoderLayer = nn.TransformerDecoderLayer(d_model=256, nhead=4, dim_feedforward=1024, dropout=0.1, activation="gelu", batch_first=True)
        self.decoder = nn.TransformerDecoder(self.decoderLayer, num_layers=2)

        self.encoderLayer = nn.TransformerEncoderLayer(d_model=256, nhead=4, dim_feedforward=1024, dropout=0.1, activation="gelu", batch_first=True)
        self.encoder = nn.TransformerEncoder(self.encoderLayer, num_layers=2)

        self.r2s_mlp = ImageReconstruction(d_model)

    def forward(self, src, tgt):
        src_key_padding_mask = make_padding_mask(src, padding_idx=-999)
        tgt_key_padding_mask = make_padding_mask(tgt, padding_idx=-999)

        # Ensure masks are 2D (batch_size, seq_len)
        src_key_padding_mask = src_key_padding_mask.squeeze(-1)
        tgt_key_padding_mask = tgt_key_padding_mask.squeeze(-1)

        # Ensure the input tensors are in float32
        src = src.to(torch.float32)
        tgt = tgt.to(torch.float32)

        # Transform the source and target using the embeddings
        src = self.source_emb(src)
        tgt = self.target_emb(tgt)
        batch_size = src.size(0)
        class_token = repeat(self.class_token, '1 1 d -> b 1 d', b=batch_size)

        # Adjust target by adding the class token
        tgt = torch.cat((class_token, tgt), dim=1)

        # Adjust the tgt_key_padding_mask to account for the added class token
        # Assuming the class token is not masked (True means it's a valid token)
        tgt_key_padding_mask = torch.cat(
            (torch.zeros(batch_size, 1, dtype=torch.bool, device=tgt.device), tgt_key_padding_mask), dim=1
        )

        # Process through the encoder and decoder
        src = self.encoder(src, src_key_padding_mask=src_key_padding_mask)
        target = self.decoder(tgt, src, tgt_key_padding_mask=tgt_key_padding_mask)

        # Final output
        class_r2s = self.r2s_mlp(target[:, 0, :])
        return class_r2s
