# from collections import OrderedDict
import torch


def load_state_keywise(model, model_path):
    model_dict = model.state_dict()
    pretrained_dict = torch.load(model_path, map_location='cpu')
    key = list(pretrained_dict.keys())[0]
    # 1. filter out unnecessary keys
    # 1.1 multi-GPU ->CPU
    if (str(key).startswith('module.')):
        pretrained_dict = {k[7:]: v for k, v in pretrained_dict.items() if
                           k[7:] in model_dict and v.size() == model_dict[k[7:]].size()}
    else:
        pretrained_dict = {k: v for k, v in pretrained_dict.items() if
                           k in model_dict and v.size() == model_dict[k].size()}
    # 2. overwrite entries in the existing state dict
    model_dict.update(pretrained_dict)
    # 3. load the new state dict
    model.load_state_dict(model_dict)


def load_whole_model(model_path):
    # this function is for loading the networks saved by
    ## torch.save(model, 'model.pth')
    model = torch.load('model.pth')
    return model

# def load_state_same_device(model, model_path)
