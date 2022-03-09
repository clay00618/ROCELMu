function [train_X, train_Y, test_X, test_Y] = GaussianData


%人工合成数据集
%随机生成符合正态分布的二维随机变量，包含四个高斯分布，四个高斯分布具有相同的单位协方差矩阵，但是均值向量不同。
%添加噪声

%% 第一组数据
mu1=[-2,-2];                  %均值
s1=[.1 0;0 .1];             %协方差矩阵
data1=mvnrnd(mu1, s1, 70);  %mvnrnd生成高斯分布数据
s1_labels=zeros(70,1)+1;
data1=[s1_labels,data1];

%噪声数据
mu_noise=[2,2];
s_noise=[.5 0;0 .5];
data_noise=mvnrnd(mu_noise, s_noise, 10);
sn_labels=zeros(10,1)+1;
data_n=[sn_labels, data_noise];


%第三组数据
mu2=[2,2];
s2=[.5 0;0 .5];
data2=mvnrnd(mu2, s2, 20);
s2_labels=zeros(20,1)-1;
data2=[s2_labels, data2];


%% 绘图
%{
plot(data1(:, 2), data1(:, 3), 'b+');
hold on;
plot(data2(:, 2), data2(:, 3), 'r+');
plot(data3(:, 2), data3(:, 3), 'g+');
%}

%% 生成高斯数据集
G_dataset=[data1;data_n;data2];
% shuffle data
%rowrank_data=randperm(size(G_dataset,1));
%G_dataset=G_dataset(rowrank_data,:);

%% 保存数据集
parentfolder = fileparts(fileparts(mfilename('fullpath')));
save([parentfolder,'\datasets\','GaussianData_non.mat'],'G_dataset');

end