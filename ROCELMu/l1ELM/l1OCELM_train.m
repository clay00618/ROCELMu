function model=l1OCELM_train(train_X,train_Y,params,ActivationFunction)

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

if NumberofTrainingData >= NumberofHiddenNeurons
    OutputWeight0 = (H*H'+(1/params.C)*eye(size(H,1)))\H*train_Y;
else
    OutputWeight0 = H/((H')*H + (1./params.C)*eye(size(H,2)))*train_Y;
end

epsilon=10^-3;
t=1;

while true 
    %f = (H' * OutputWeight0);
    %error = train_Y - f; 
    %MAR = mad(error,1);
    %sigma = MAR/0.6745;
    %error = error ./ sigma;
    %WN = eye(NumberofTrainingData);
    WL = eye(NumberofHiddenNeurons);
    %for k=1:size(WN,1)
        %WN(k,k) = min(1,1.345/abs(error(k)));
    %end
    
    if NumberofTrainingData >= NumberofHiddenNeurons
        for j=1:size(WL)
            WL(j,j) = 1 ./ max(abs(OutputWeight0(j)),10^-6);
        end
        OutputWeight = (H*H'+(1./params.C)*WL)\H*train_Y;
    else
        for j=1:size(WL)
            WL(j,j) = abs(OutputWeight0(j));
        end
        OutputWeight = WL*H/(H'*WL*H + (1./params.C)*eye(size(H,2)))*train_Y;
    end
    c=sqrt((OutputWeight - OutputWeight0)'*(OutputWeight - OutputWeight0));
    if t > params.tmax || c < epsilon
        break;
    end
    OutputWeight0=OutputWeight;
    t=t+1;
end

train_end = toc(train_start);

train_result = H'*OutputWeight;
clear H
clear WL
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
model.OutputWeight = OutputWeight;
model.ActivationFunction = ActivationFunction;
model.C = params.C;
model.L = NumberofHiddenNeurons;
model.OutlierRate = params.mu;
model.critical_value = critical_value;
model.train_time = train_end;

save('l1OCELM_train.mat','-struct','model');

end