function [train_X0, train_Y0,test_X0, test_Y0] = Preprocessing_wine

%Ecoli

parentPath = fileparts(mfilename('fullpath'));

realData = readtable([parentPath,'\datasets\wine.data'], 'Filetype', 'text', 'ReadVariableNames', false);
attributes = realData{:,2:14};
real_labels = realData{:,1};


labels=zeros(size(real_labels,1),1);
for i=1:size(labels,1)
    if real_labels(i,1)==1
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


