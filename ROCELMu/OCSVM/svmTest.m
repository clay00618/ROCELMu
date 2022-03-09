function [testAcc,precision,recall,g_mean,F1,train_time,test_time,distance_test] = svmTest(model, Xt, Xy,params)

test_start = tic;
train_time = model.train_time;  
alpha = model.a;
Xsv = model.Xsv;
rou = model.rou;

distance_test = alpha'*kernel(Xsv,Xt,params.kertype,params.k);
f = sign(distance_test - rou);
f_test = zeros(1,size(f,2));
for i=1:size(f_test,2)
    if f(i)==1 || f(i)==0
        f_test(i)=1;
    else
        f_test(i)=-1;
    end
end



test_time = toc(test_start);

MissClassificationRate_Testing=0;
TP=0;
FN=0;
FP=0;
TN=0;

for k=1:size(Xy,2)
    if f_test(1,k)~=Xy(1,k)
        MissClassificationRate_Testing = MissClassificationRate_Testing+1;
        if f_test(1,k)==1
            FP=FP+1;
        else
            FN=FN+1;
        end
    else
        if f_test(1,k)==1
            TP=TP+1;
        else
            TN=TN+1;
        end
    end
end
        
testAcc=1-MissClassificationRate_Testing/size(Xy,2);
precision=TP/(TP+FP);
recall=TP/(TP+FN);
F1=(2*precision*recall)/(precision+recall);
g_mean=sqrt(recall*(TN/(FP+TN)));

end
