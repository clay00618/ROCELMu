#!/usr/bin/env python
# coding: utf-8

# In[1]:


import torch
import torch.nn as nn
import torch.nn.functional as F
import torchvision
import torchvision.transforms as transforms
import numpy as np
import datetime as dt


# In[3]:


device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
print (f'device:{device}')
# Hyper-paramesters
num_epochs = 12
batch_size = 10
learning_rate = 0.001


# In[ ]:


# dataset has PILImage images of rang [0,1]
# we transform them to Tensors of normalized range [-1,1]
transform = transforms.Compose(
    [transforms.ToTensor(),
     transforms.Normalize((0.5,0.5,0.5), (0.5,0.5,0.5))])


# In[5]:


train_dataset = torchvision.datasets.CIFAR10(root='./data', train=True, download=True, transform=transform)
test_dataset = torchvision.datasets.CIFAR10(root='./data', train=False, download=True, transform=transform)
train_loader = torch.utils.data.DataLoader(train_dataset, batch_size=batch_size, shuffle=True)
test_loader = torch.utils.data.DataLoader(test_dataset, batch_size=batch_size, shuffle=False)


# In[6]:


classes = ['plane', 'car', 'bird', 'cat', 'deer', 'dog', 'frog', 'horse', 'ship', 'truck']


# In[7]:


class GoogLeNet(nn.Module):
    def __init__(self, in_channels=3, num_classes=1000):
        super(GoogLeNet, self).__init__()
        # 输入通道是3，处理后的图像大小为112×112(原图像为224×224)
        self.conv1 = Conv_block(in_channels=in_channels, out_channels=64, kernel_size=(7,7),
                               stride=(2,2), padding=(3,3))
        # 输出8×8
        self.maxpool1 = nn.MaxPool2d(kernel_size=3, stride=2, padding=1)
        #
        self.conv2 = Conv_block(64, 192, kernel_size=3, stride=1, padding=1)
        self.maxpool2 = nn.MaxPool2d(kernel_size=3, stride=2, padding=1)
        
        self.inception3a = Inception_block(192, 64, 96, 128, 16, 32, 32)
        self.inception3b = Inception_block(256, 128, 128, 192, 32, 96, 64)
        self.maxpool3 = nn.MaxPool2d(kernel_size=3, stride=2, padding=1)
        
        self.inception4a = Inception_block(480, 192, 96, 208, 16,48, 64)
        self.inception4b = Inception_block(512, 160, 112, 224, 24, 64, 64)
        self.inception4c = Inception_block(512, 128, 128, 256, 24, 64, 64)
        self.inception4d = Inception_block(512, 112, 144, 288, 32, 64, 64)
        self.inception4e = Inception_block(528, 256, 160, 320, 32, 128, 128)
        self.maxpool4 = nn.MaxPool2d(kernel_size=3, stride=2, padding=1)
        
        self.inception5a = Inception_block(832, 256, 160, 320, 32, 128, 128)
        self.inception5b = Inception_block(832, 384, 192, 384, 48, 128, 128)
        
        self.avgpool = nn.AvgPool2d(kernel_size=1, stride=1) #  224/2/2/2/2/2 = 7    32/2/2/2/2/2 = 1
        self.dropout = nn.Dropout(p=0.4)
        
        self.fc1 = nn.Linear(1024, num_classes)
        
    def forward(self, x):
        x = self.conv1(x)
        x = self.maxpool1(x)
        
        x = self.conv2(x)
        x = self.maxpool2(x)
        
        x = self.inception3a(x)
        x = self.inception3b(x)
        x = self.maxpool3(x)
        
        x = self.inception4a(x)
        x = self.inception4b(x)
        x = self.inception4c(x)
        x = self.inception4d(x)
        x = self.inception4e(x)
        x = self.maxpool4(x)
        
        x = self.inception5a(x)
        x = self.inception5b(x)
        x = self.avgpool(x)              # 可以不调用。
        x = x.reshape(x.shape[0], -1)
        x = self.dropout(x)
        x = self.fc1(x)
        return x
        


# In[2]:


class Inception_block(nn.Module):
    def __init__(self, in_channels, out_1x1, red_3x3, out_3x3, red_5x5, out_5x5, out_1x1pool):
        super(Inception_block,self).__init__()
        
        self.branch1 = Conv_block(in_channels, out_1x1, kernel_size=1)
        
        self.branch2 =nn.Sequential(
            Conv_block(in_channels, red_3x3, kernel_size=1),
            Conv_block(red_3x3, out_3x3, kernel_size=3, padding = 1)
        )
        self.branch3=nn.Sequential(
            Conv_block(in_channels, red_5x5, kernel_size=1),
            Conv_block(red_5x5, out_5x5, kernel_size=5, padding = 2)
        )
            
        self.branch4 = nn.Sequential(
            nn.MaxPool2d(kernel_size =3, stride=1, padding=1),
            Conv_block(in_channels, out_1x1pool, kernel_size=1)
        )
        
    def forward(self, x):
        return torch.cat([self.branch1(x), self.branch2(x), self.branch3(x), self.branch4(x)],1)


# In[9]:


class Conv_block(nn.Module):
    def __init__(self, in_channels, out_channels, **kwargs):
        super(Conv_block, self).__init__()
        self.relu = nn.ReLU()
        self.conv = nn.Conv2d(in_channels, out_channels, **kwargs)
        self.batchnorm = nn.BatchNorm2d(out_channels)
        
    def forward(self, x):
        return self.relu(self.batchnorm(self.conv(x)))
        


# In[10]:


model = GoogLeNet(in_channels=3, num_classes = 10).to(device)
criterion = nn.CrossEntropyLoss()
optimizer = torch.optim.SGD(model.parameters(), lr=learning_rate)

n_total_steps = len(train_loader)
t1 = dt.datetime.now()
print (f'Training started at {t1}')


# In[11]:


for epoch in range(num_epochs):
    for i, (images, labels) in enumerate(train_loader):
        images = images.to(device)
        labels = labels.to(device)

        outputs = model(images)
        
        loss = criterion(outputs, labels)
        
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        
        if (i+1) % 1000 == 0:
            print (f'Epoch [{epoch+1}/{num_epochs}], Step [{i+1}/{n_total_steps}], loss: {loss.item():.4f}')


# In[12]:


t2 = dt.datetime.now()
print(f'Finished Training at {t2}')
print(f'Training time :  {t2-t1}')
with torch.no_grad():
    n_correct = 0
    n_samples = 0
    n_class_correct = [0 for i in range(10)]
    n_class_samples = [0 for i in range(10)]
    for images, labels in test_loader:
        images = images.to(device)
        labels = labels.to(device)    
        outputs = model(images)  
        _, predicted = torch.max(outputs, 1)
        n_samples += labels.size(0)
        n_correct += (predicted == labels).sum().item()
        
        for i in range (batch_size):
            label = labels[i]
            pred = predicted[i]
            if label == pred:
                n_class_correct[label] += 1
            n_class_samples[label] += 1
    acc = 100.0 * n_correct / n_samples
    print (f'Accuracy of the network: {acc} %')  
    for i in range(10):
        acc = 100.0 * n_class_correct[i] / n_class_samples[i]
        print (f'Accuracy of {classes[i]}: {acc} %')





