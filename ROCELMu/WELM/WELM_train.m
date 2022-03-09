function model = WELM_train(train_X,train_Y,params,ActivationFunction)
 
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
    OutputWeight0 = H/(H'*H+(1/params.C)*eye(size(H,2)))*train_Y;
end

alpha = params.C*(train_Y - H'*OutputWeight0);
error = alpha./params.C;
error_sorted = sort(error);
if mod(NumberofTrainingData,4)==0
    s1 = error_sorted(NumberofTrainingData/4);
    s3 = error_sorted((3*NumberofTrainingData)/4);
    s = (s3 - s1)/1.3490;
else
    s1 = (error_sorted(floor(NumberofTrainingData/4))+error_sorted(floor(NumberofTrainingData/4)+1))/2;
    s3 = (error_sorted(floor(3*NumberofTrainingData/4))+error_sorted(floor(3*NumberofTrainingData/4)+1))/2;
    s = (s3 - s1)/1.3490;
end
    
D = eye(NumberofTrainingData);
for i=1:size(D,1)
    if abs(error(i)/s)<2.5
        D(i,i)=1;
    end
    if abs(error(i)/s)<=3 && abs(error(i)/s)>=2.5
        D(i,i)=(3-abs(error(i)/s))/0.5;
    else
        D(i,i)=10^-4;
    end
end
% update outputWeight

if NumberofTrainingData >= NumberofHiddenNeurons
    OutputWeight = (H*D*D*H'+(1/params.C)*eye(size(H,1)))\H*D*D*train_Y;
else
    OutputWeight = H/(D*D*(H')*H+(1/params.C)*eye(size(H,2)))*D*D*train_Y;
end

train_end = toc(train_start);

train_result = H'*OutputWeight;

clear H
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
model.OutlierRate = params.mu;
model.critical_value = critical_value;
model.train_time = train_end;

save('WELM_train.mat','-struct','model');

end