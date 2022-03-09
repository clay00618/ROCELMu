function[trainsamples,m,s]=Train_statwo(trainsamples)

format shortEng
%对训练数据进行标准化处理
InputDimensions=size(trainsamples,1);
m=zeros(1,InputDimensions);
s=zeros(1,InputDimensions);

for i=1:InputDimensions
    m(i) = mean(trainsamples(i,:));
    s(i) = std(trainsamples(i,:));
    trainsamples(i,:)=(trainsamples(i,:) - m(i))./s(i);
end

