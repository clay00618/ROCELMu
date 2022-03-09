function[testsamples]=Test_sta(testsamples,m,s)

format shortEng
%对测试数据进行标准化
InputDimensions=size(testsamples,2);

for i=1:InputDimensions
    testsamples(:,i)=(testsamples(:,i) - m(i))./s(i);
end