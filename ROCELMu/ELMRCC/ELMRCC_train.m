function model=ELMRCC_train(train_X,train_Y,params,ActivationFunction)


parentPath = fileparts(fileparts(mfilename('fullpath')));
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
    OutputWeight0=(H*H'+(1/params.C)*eye(size(H,1)))\H*train_Y;
else
    OutputWeight0=H/(H'*H+eye(size(H,2))/params.C)*train_Y;
end

%% iterative reweighted algorithm
%MAR为中位数绝对残差
%epsilon为收敛参数,t为当前迭代次数
epsilon=10^-3;
t=1;
while true
    f = (H' * OutputWeight0);
    error = train_Y - f; 
    WN = eye(NumberofTrainingData);
    for j = 1:size(WN,1)
        WN(j,j) = (-2+error(j)^2/params.eta^2)*exp(-error(j)^2/(2*params.eta^2));
    end
    if NumberofTrainingData >= NumberofHiddenNeurons
        OutputWeight=(H*WN*H'+(1/params.C)*eye(size(H,1)))\H*WN*train_Y;
    else
        OutputWeight=H/((WN*H')*H+eye(size(H,2))/params.C)*WN*train_Y;
    end
    c=sqrt((OutputWeight - OutputWeight0)'*(OutputWeight - OutputWeight0));
    if t > params.tmax || c < epsilon
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

model.InputWeight = InputWeight;
model.BiasofHiddenNeurons = BiasofHiddenNeurons;
model.OutputWeight = OutputWeight;
model.ActivationFunction = ActivationFunction;
model.C = params.C;
model.L = NumberofHiddenNeurons;
model.eta = params.eta;
model.OutlierRate = params.mu;
model.critical_value = critical_value;
model.train_time = train_end;

save('ELMRCC_train.mat','-struct','model');
end