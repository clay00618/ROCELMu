function model=ORELM_train(train_X,train_Y,params,ActivationFunction)

format shortEng

parentPath = fileparts(fileparts(mfilename('fullpath')));
load(fullfile(parentPath,'\crossvalidation\InputWeight.mat'), 'InputWeight')
load(fullfile(parentPath,'\crossvalidation\BiasofHiddenNeurons.mat'), 'BiasofHiddenNeurons')

NumberofTrainingData=size(train_X,1);

train_start = tic;

NumberofHiddenNeurons=params.L;
tempH=InputWeight*train_X';
clear train_X;
ind=ones(1,NumberofTrainingData);
BiasMatrix=BiasofHiddenNeurons(:,ind);
tempH=tempH+BiasMatrix;

H = OutputMatrixH(tempH,ActivationFunction);

l1_y=0;
for j=1:NumberofTrainingData
    l1_y = l1_y + abs(train_Y(j));
end

parameter_mu = 2*NumberofTrainingData/l1_y;

P = (H*H'+(2/(params.C*parameter_mu))*eye(size(H,1)))\H;
e0 = zeros(NumberofTrainingData,1);
lambda0 = zeros(NumberofTrainingData,1);
k=1;
while true
    OutputWeight0 = P*(train_Y - e0 + lambda0/parameter_mu);
    e = max(abs(train_Y - H'*OutputWeight0+lambda0/parameter_mu)-1/parameter_mu,0).*sign(train_Y-H'*OutputWeight0+lambda0/parameter_mu);
    lambda = lambda0 + parameter_mu*(train_Y-H'*OutputWeight0-e);
    if k>=params.tmax
        break;
    end
    e0=e;
    lambda0=lambda;
    k=k+1;
end


train_end = toc(train_start);
train_result = H'*OutputWeight0;
clear H
clear error

% define the distance function
distance=abs(train_result - 1);
% sort the distance of each sample
sorted_distance=sort(distance,'descend');
% get the maximum distance
index_m=floor(params.mu*NumberofTrainingData);
if index_m==0 || index_m==1
    critical_value=sorted_distance(1,1);
else
    critical_value=sorted_distance(index_m,1);
end

model.InputWeight = InputWeight;
model.BiasofHiddenNeurons = BiasofHiddenNeurons;
model.OutputWeight = OutputWeight0;
model.ActivationFunction = ActivationFunction;
model.C = params.C;
model.L = NumberofHiddenNeurons;
model.OutlierRate = params.mu;
model.critical_value = critical_value;
model.train_time = train_end;

save('ORELM_train.mat','-struct','model');

end


    








