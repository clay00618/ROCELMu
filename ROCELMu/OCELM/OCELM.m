%OCELM
%%%%  Author: CHENG-WEI ZHAN
%%%%  XI'AN SHIYOU UNIVERSITY, CHINA
%%%%  EMAIL:  weichengcclay@qq.com
%%%%  DATE:   AUGUST 2021
function model = OCELM(train_X,train_Y,params,ActivationFunction)

format shortEng

parentPath = fileparts(fileparts(mfilename('fullpath')));
load(fullfile(parentPath,'\crossvalidation\InputWeight.mat'), 'InputWeight')
load(fullfile(parentPath,'\crossvalidation\BiasofHiddenNeurons.mat'), 'BiasofHiddenNeurons')

%% numbers
NumberofTrainingData=size(train_X,1);        %the number of training data

%% calculate weights and bias
train_start = tic;

NumberofHiddenNeurons=params.L;
tempH=InputWeight*train_X';
clear train_X;
ind=ones(1,NumberofTrainingData);
BiasMatrix=BiasofHiddenNeurons(:,ind);
tempH=tempH+BiasMatrix;

%% calculate hidden neuron output matrix H
H = OutputMatrixH(tempH,ActivationFunction);

%% calculate the OutputWeight
if NumberofTrainingData > NumberofHiddenNeurons
    OutputWeight=(eye(size(H,1))/params.C+H*H')\H*train_Y;
else
    OutputWeight=H/(H'*H+eye(size(H,2))/params.C)*train_Y;
end

train_end = toc(train_start);


%% calculate the accuracy of training
train_result=H'*OutputWeight;

clear H

%define the distance function
distance=abs(train_result - 1);
%sort the distance of each sample
sorted_distance=sort(distance,'descend');
%get the maximum distance
index_m=floor(params.mu*size(train_Y,1));
if index_m==0 || index_m==1
    critical_value=sorted_distance(1,1);
else
    critical_value=sorted_distance(index_m,1);
end

%{
%get the category vector based on the distance function
classifier=zeros(size(distance,1),1);
%discriminaint function
for j=1:size(distance,1)
    if distance(j,1)<=critical_value
        classifier(j,1)=1;
    else
        classifier(j,1)=-1;
    end
end
MissClassificationRate_Training=0;
for k=1:size(train_T,2)
    if classifier(k,1)~=train_T(1,k)
        MissClassificationRate_Training = MissClassificationRate_Training+1;
    end
end
TrainingAccuracy=1-MissClassificationRate_Training/size(train_T,2);
disp('训练精度：')
disp(TrainingAccuracy)
%}

model.InputWeight = InputWeight;
model.BiasofHiddenNeurons = BiasofHiddenNeurons;
model.OutputWeight = OutputWeight;
model.ActivationFunction = ActivationFunction;
model.C = params.C;
model.L = NumberofHiddenNeurons;
model.OutlierRate = params.mu;
model.critical_value = critical_value;
model.train_time = train_end;

save('OCELM_train.mat','-struct','model');

end

