function [testsamples]=Test_normtwo(testsamples,t_min,difference)

format shortEng

%对测试数据做归一化处理

InputDimensions=size(testsamples,1);

for i=1:InputDimensions
    testsamples(i,:)=(testsamples(i,:) - t_min(i))/difference(i);
end