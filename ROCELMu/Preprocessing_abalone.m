function [train_X0, train_Y0,test_X0, test_Y0] = Preprocessing_abalone

%Abalone

parentPath = fileparts(mfilename('fullpath'));

realData = readtable([parentPath,'\datasets\abalone.data'], 'Filetype', 'text', 'ReadVariableNames', false);
attributes = realData{:,2:8};
real_labels = realData{:,9};
temp = realData{:,1};
for i=1:size(temp,1)
    if strcmp(temp{i,1},'M')
        temp{i,1}=1;
    end
    if strcmp(temp{i,1},'F')
        temp{i,1}=2;
    end
    if strcmp(temp{i,1},'I')
        temp{i,1}=3;
    end
end
attributes = [cell2mat(temp) attributes];


labels=zeros(size(real_labels,1),1);
for i=1:size(labels,1)
    if real_labels(i,1)==1 || real_labels(i,1)==2 || real_labels(i,1)==3 || real_labels(i,1)==4 || real_labels(i,1)==5 || real_labels(i,1)==6 || real_labels(i,1)==7 || real_labels(i,1)==8
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


