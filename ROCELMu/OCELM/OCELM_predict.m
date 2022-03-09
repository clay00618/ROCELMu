function [testAcc,precision,recall, g_mean, F1,train_time, test_time, distance_test] = OCELM_predict(test_X, test_Y, model)

format shortEng

%% load model of OCELM
InputWeight = model.InputWeight;
BiasofHiddenNeurons = model.BiasofHiddenNeurons;
OutputWeight = model.OutputWeight;
ActivationFunction = model.ActivationFunction;
critical_value = model.critical_value;
train_time = model.train_time;

%% calculate the output of testing input
start_time_test=cputime;

NumberofTestingData = size(test_X,1);
tempH_test=InputWeight*test_X';
clear test_X;
ind=ones(1,NumberofTestingData);
BiasMatrix=BiasofHiddenNeurons(:,ind);
tempH_test=tempH_test+BiasMatrix;

H_test=OutputMatrixH(tempH_test,ActivationFunction);

end_time_test=cputime;
test_time=end_time_test-start_time_test;

test_result=H_test'*OutputWeight;  %N×1

clear H_test

%% calculate the accuracy of testing
distance_test=abs(test_result - 1);
%get the category vector based on the distance function
classifier_test=sign(critical_value - distance_test);
classifier_test1 = zeros(size(classifier_test,1),1);
%discriminaint function
for j=1:size(classifier_test1,1)
    if classifier_test(j,1)==1 || classifier_test(j,1)==0
        classifier_test1(j,1)=1;
    else
        classifier_test1(j,1)=-1;
    end
end
MissClassificationRate_Testing=0;
TP=0;
FN=0;
FP=0;
TN=0;
for k=1:size(test_Y,1)
    if classifier_test1(k,1)~=test_Y(k,1)
        MissClassificationRate_Testing = MissClassificationRate_Testing+1;
        if classifier_test1(k,1)==1
            FP=FP+1;
        else
            FN=FN+1;
        end
    else
        if classifier_test1(k,1)==1
            TP=TP+1;
        else
            TN=TN+1;
        end
    end
end


testAcc=1-MissClassificationRate_Testing/NumberofTestingData;
precision=TP/(TP+FP);
recall=TP/(TP+FN);
F1=(2*precision*recall)/(precision+recall);
g_mean=sqrt(recall*(TN/(FP+TN)));

end
