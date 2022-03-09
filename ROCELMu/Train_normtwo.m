function [trainsamples,difference, t_min]=Train_normtwo(trainsamples,testsamples)

format shortEng
%数据归一化处理
InputDimensions = size(trainsamples,1);
difference = zeros(1,InputDimensions);
t_min = zeros(1,InputDimensions);

whole_data=[trainsamples,testsamples];

for i=1:InputDimensions
    t_min(1,i) = min(whole_data(i,:));
    difference(1,i) = max(whole_data(i,:))-t_min(1,i);
    if difference(1,i)==0
        difference(1,i)=1;
    end
    trainsamples(i,:) = (trainsamples(i,:) - t_min(1,i))/difference(1,i);
end
