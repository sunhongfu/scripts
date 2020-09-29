import torch 
import torch.nn as nn 
import os
import torch.optim.lr_scheduler as LS

from Unet import * 

class FeatureExtractor(nn.Module):
    def __init__(self, model, EncodingDepth , layers_list, index_extract):
        super(FeatureExtractor, self).__init__()
        self.model = model
        self.EncodingDepth = EncodingDepth
        self.extracted_layers = []
        for i in index_extract:
            self.extracted_layers.append(layers_list[i])

    def forward(self, x):
        outputs = []
        dicts = self.__dict__
        for name, module in self.model._modules.items():
            if type(module) == nn.modules.container.ModuleList:
                keys_list = module._modules.keys()
                for k in keys_list:
                    if 'Decode' in name:
                        x2 = dicts['EncodeX' + str(self.EncodingDepth - int(k))]
                        mm = module._modules.get(k)
                        x = mm(x, x2)
                        mname = name + k 
                        if mname in self.extracted_layers:
                            outputs.append(x)
                    elif 'Encod' in name:
                        mm = module._modules.get(k)
                        x = mm(x)
                        mname = name + k 
                        dicts['EncodeX' + str(int(k) + 1) ] = x
                        if mname in self.extracted_layers:
                            outputs.append(x)
                        x = F.max_pool3d(x, 2)
                    else:
                        mm = module._modules.get(k)
                        x = mm(x)
                        mname = name + k 
                        dicts['EncodeX' + str(int(k) + 1) ] = x
                        if mname in self.extracted_layers:
                            outputs.append(x)
            else:
                x = module(x)
                mname = name
                if mname in self.extracted_layers:
                            outputs.append(x)
        return outputs


"""
This is only a simple net for testing this script. 
"""
class TestNet(nn.Module):
    def __init__(self):
        super(TestNet, self).__init__()
        self.conv1 = nn.Conv2d(1, 1, 3)
        self.relu1 = nn.ReLU()
        self.conv2 = nn.Conv2d(1, 1, 3)
        self.relu2 = nn.ReLU()

    def forward(self, x):
        x = self.conv1(x)
        x = self.relu1(x)
        x = self.conv2(x)
        x = self.relu2(x)
        return x

##  -- main function --
if __name__ == '__main__':

    EncodingDepth = 2
    resnet = Unet(EncodingDepth)
    resnet.eval()
    #print(resnet.state_dict)

    layer_list = []
    for name, module in resnet._modules.items():
        if type(module) == nn.modules.container.ModuleList:
            keys_list = module._modules.keys()
            for k in keys_list:
                mName = name + k
                layer_list.append(mName)
        else:
            layer_list.append(name)
            
            

    print(layer_list)
    indx = [0, 1, 2, 3]

    x = torch.randn(1,1,24,24, 24) ## test data; 

    extract_result = FeatureExtractor(resnet, EncodingDepth, layer_list, indx)
    for i in range(0, len(indx)):
        print(extract_result(x)[i].size()) 