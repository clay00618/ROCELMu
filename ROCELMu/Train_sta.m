function[trainsamples,m,s]=Train_sta(trainsamples)

format shortEng
%对训练数据进行标准化处理
InputDimensions=size(trainsamples,2);
m=zeros(InputDimensions,1);
s=zeros(InputDimensions,1);

for i=1:InputDimensions
    m(i) = mean(trainsamples(:,i));
    s(i) = std(trainsamples(:,i));
    trainsamples(:,i)=(trainsamples(:,i) - m(i))./s(i);
end

