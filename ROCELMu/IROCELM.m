%IROCELM
%%%%  Author: CHENG-WEI ZHAN
%%%%  XI'AN SHIYOU UNIVERSITY, CHINA
%%%%  EMAIL:  weichengcclay@qq.com
%%%%  DATE:   AUGUST 2021
function model=IROCELM(train_X,train_Y,params,ActivationFunction)

format shortEng

parentPath = fileparts(mfilename('fullpath'));
load(fullfile(parentPath,'\crossvalidation\InputWeight.mat'), 'InputWeight')
load(fullfile(parentPath,'\crossvalidation\BiasofHiddenNeurons.mat'), 'BiasofHiddenNeurons')

%% numbers
NumberofTrainingData=size(train_X,1);


%% calculate weight and bias
train_start = tic;

NumberofHiddenNeurons=params.L;
tempH=InputWeight*train_X';
clear train_X;
ind=ones(1,NumberofTrainingData);
BiasMatrix=BiasofHiddenNeurons(:,ind);
tempH=tempH+BiasMatrix;

%% calculate hidden neuron output matrix H (t=1)
H = OutputMatrixH(tempH,ActivationFunction);

%% calculate the OutputWeight (t=1)
if NumberofTrainingData >= NumberofHiddenNeurons
    OutputWeight0=(H*H'+(params.lambda/params.C)*eye(size(H,1))+((1-params.lambda)/params.C)*eye(size(H,1)))\H*train_Y;
else
    OutputWeight0=(params.lambda*eye(size(H,1))+(1-params.lambda)*eye(size(H,1)))\H/(H'/(params.lambda*eye(size(H,1))+(1-params.lambda)*eye(size(H,1)))*H+eye(size(H,2))/params.C)*train_Y;
end

%% iterative reweighted algorithm
%MAR为中位数绝对残差
%epsilon为收敛参数,t为当前迭代次数
epsilon=10^-3;
t=1;
object_value = zeros(params.tmax,1);
while true
    f = (H' * OutputWeight0);
    error = train_Y - f; 
    %MAR = mad(error,1);
    %sigma = MAR/0.6745;
    %error = error ./ sigma;
    WN = eye(NumberofTrainingData);
    WL = eye(NumberofHiddenNeurons);
    for j = 1:size(WN,1)
        WN(j,j) = (params.eta/(1-exp(-params.eta)))*exp(-params.eta*error(j)^2);
    end
    
    for k = 1:size(WL,1)
        WL(k,k) = 1 ./ max(abs(OutputWeight0(k)),10^-6);
    end
    
    if NumberofTrainingData >= NumberofHiddenNeurons
        OutputWeight=(H*WN*H'+(params.lambda/params.C)*WL+((1-params.lambda)/params.C)*eye(size(H,1)))\H*WN*train_Y;
    else
        OutputWeight=(params.lambda*WL+(1-params.lambda)*eye(size(H,1)))\H/(WN*H'/(params.lambda*WL+(1-params.lambda)*eye(size(H,1)))*H+eye(size(H,2))/params.C)*WN*train_Y;
    end
    c=sqrt((OutputWeight - OutputWeight0)'*(OutputWeight - OutputWeight0));
    
    lossFun = zeros(NumberofTrainingData,1);
    for n=1:size(lossFun,1)
        lossFun(n) = (1/(1-exp(-params.eta)))*(1-exp(-params.eta*error(n).^2));
    end
    object_value(t) = params.lambda*sum(abs(OutputWeight)) + ((1-params.lambda)/2)*sum(OutputWeight'*OutputWeight) + (params.C/2)*sum(lossFun);
    
    if t >= params.tmax || c < epsilon
        break;
    end

    OutputWeight0=OutputWeight;
    t = t+1;
end

train_end = toc(train_start);


%% calculate the accuracy of training
train_result = H'*OutputWeight;

clear H
clear WN
clear WL
clear error

% define the distance function
distance=abs(train_result - 1);
%sort the distance of each sample
sorted_distance=sort(distance,'descend');
%get the maximum distance
index_m=floor(params.mu*NumberofTrainingData);
if index_m==0 || index_m==1
    critical_value=sorted_distance(1,1);
else
    critical_value=sorted_distance(index_m,1);
end

%{
% get the category vector based on the distance function
classifier=zeros(size(distance,1),1);
% discriminaint function
for j=1:size(distance,1)
    if distance(j,1)<=critical_value
        classifier(j,1)=1;
    else
        classifier(j,1)=-1;
    end
end
MissClassificationRate_Training=0;
for k=1:size(train_Y,1)
    if classifier(k,1)~=train_Y(k,1)
        MissClassificationRate_Training = MissClassificationRate_Training+1;
    end
end
TrainingAccuracy=1-MissClassificationRate_Training/size(train_Y,1);
disp('训练精度：')
disp(TrainingAccuracy)
%}

model.InputWeight = InputWeight;
model.BiasofHiddenNeurons = BiasofHiddenNeurons;
model.OutputWeight = OutputWeight;
model.ActivationFunction = ActivationFunction;
model.C = params.C;
model.L = NumberofHiddenNeurons;
model.lambda = params.lambda;
model.eta = params.eta;
model.OutlierRate = params.mu;
model.critical_value = critical_value;
model.train_time = train_end;
model.object_value = object_value;

save('IROCELM_train.mat','-struct','model');
%disp('Contents of IROCELM_train.mat:')
%whos('-file','IROCELM_train.mat')

end