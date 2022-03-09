function [trainsamples,difference, t_min]=Train_norm(trainsamples,testsamples)

format shortEng
%数据归一化处理
InputDimensions = size(trainsamples,2);
difference = zeros(InputDimensions,1);
t_min = zeros(InputDimensions,1);

whole_data=[trainsamples;testsamples];

for i=1:InputDimensions
    t_min(i,1) = min(whole_data(:,i));
    difference(i,1) = max(whole_data(:,i))-t_min(i,1);
    if difference(i,1)==0
        difference(i,1)=1;
    end
    trainsamples(:,i) = (trainsamples(:,i) - t_min(i,1))/difference(i,1);
end
