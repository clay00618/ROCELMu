function [train_X0, train_Y0,test_X0, test_Y0] = Preprocessing

% Breast
format shortEng

% 获取高斯数据集
%{
parentPath = fileparts(mfilename('fullpath'));
data = load(fullfile(parentPath,'\datasets\GaussianData_non.mat'));
G_dataset = data.G_dataset;

train_X0=G_dataset(1:80,2:end);  
train_Y0=ones(80,1);
test_X0=G_dataset(81:100,2:end);
test_Y0=zeros(20,1)-1;
%}

% cell数组用小括号索引得到的还是cell小数组，cell数组用大括号索引得到的是cell小数组当中的内容
% 获取UCI数据集

parentPath = fileparts(mfilename('fullpath'));

%load(fullfile(parentPath,'\datasets\phoneme.mat'));
realData = readtable([parentPath,'\datasets\breast-cancer-wisconsin.data'], 'Filetype', 'text', 'ReadVariableNames', false);
attributes = realData{:,2:10};
real_labels = realData{:,11};

labels=zeros(size(real_labels,1),1);
for i=1:size(labels,1)
    if real_labels(i,1)==2
        labels(i,1)=1;
    else
        labels(i,1)=-1;
    end
end 

% 处理丢失数据

miss_ind = zeros(size(attributes));
signed=0;
for j=1:size(attributes,2)
    sum = 0;
    for k=1:size(attributes,1)
        if isnan(attributes(k,j))
            miss_ind(k,j)=1;
            signed = signed+1;
        else
            sum = sum + attributes(k,j);
        end
    end
    for m=1:size(miss_ind,1)
        if miss_ind(m,j)==1
            attributes(m,j)=floor(sum/(size(attributes,1)-signed));
        end
    end
end

            

% 正类
train_X0 = attributes(labels(:,1)==1,:);
train_Y0 = labels(labels(:,1)==1,:);
disp('正类个数：')
disp(size(train_X0,1))


% 负类
test_X0 = attributes(labels(:,1)==-1,:);
test_Y0 = labels(labels(:,1)==-1,:);
disp('负类个数:')
disp(size(test_X0,1))

end

