function[testsamples]=Test_statwo(testsamples,m,s)

format shortEng
%对测试数据进行标准化
InputDimensions=size(testsamples,1);

for i=1:InputDimensions
    testsamples(i,:)=(testsamples(i,:) - m(i))./s(i);
end