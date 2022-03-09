close all
clc
clear

parentPath = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(parentPath))

% output arrays
test_acc=zeros(10,1);
test_precision=zeros(10,1);
test_recall=zeros(10,1);
test_F1=zeros(10,1);
test_g=zeros(10,1);
test_auc=zeros(10,1);
train_times=zeros(10,1);
test_times=zeros(10,1);


% data preparation
[train_X0,train_Y0,test_X0, test_Y0] = Preprocessing_sonar;

temp_test_X0 = test_X0;
temp_test_Y0 = test_Y0;

% setting the trade-off parameter and the number of hidden neurons
C=[2^-10 2^-9 2^-8 2^-7 2^-6 2^-5 2^-4 2^-3 2^-2 2^-1 1 2 2^2 2^3 ...
    2^4 2^5 2^6 2^7 2^8 2^9 2^10 2^11 2^12 2^13 2^14 2^15 2^16 2^17 2^18 2^19 2^20];
params.mu=0;
params.L=1000;
best_F15=0;
best_g5 = 0;
best_acc5 = 0;
tic

load(fullfile(parentPath,'\crossvalidation\sonar_ind.mat'));
load(fullfile(parentPath,'\crossvalidation\sonar_noise_ind.mat'));

for j=1:length(C)
    params.C=C(j);
    for i=1:10

        
        test_X0 = temp_test_X0;
        test_Y0 = temp_test_Y0;

       
        % 噪声数据比例
        noise_r = 0.5;
        noise = noise_ind(:,1:floor(size(noise_ind,2)*noise_r));
        noise_X = test_X0(noise,:);
        number_X = floor(0.8*size(r,2));
        train_X=[train_X0(r(i,1:number_X),:);noise_X];
        train_Y=[train_Y0(r(i,1:number_X),:);ones(size(noise_X,1),1)];
        test_X0(noise_ind,:)=[];
        test_Y0(noise_ind,:)=[];
        test_X=[train_X0(r(i,number_X+1:end),:);test_X0];
        test_Y=[train_Y0(r(i,number_X+1:end),:);test_Y0];  
        
        % 数据归一化处理
        [trainsamples,difference,t_min]=Train_norm(train_X,test_X);
        [testsamples]=Test_norm(test_X,t_min,difference);
        train_X=trainsamples;
        test_X=testsamples;
        
        % 数据标准化处理
%         [trainsamples,m,s]=Train_sta(train_X);
%         [testsamples]=Test_sta(test_X,m,s);
%         train_X=trainsamples;
%         test_X=testsamples;

        % train
        model = OCELM(train_X, train_Y, params, 'sigmoid');

        % predict
        [testAcc,precision,recall, g_mean, F1, train_time, test_time, distance_test] = OCELM_predict(test_X, test_Y, model);

        %decision boundary
        %[rho, X, Y] = decision(model, train_X);
        %visualization
        %visualization(train_X, test_X, rho, X, Y, params);
        
        % draw ROC and calculate AUC
        auc = calculate_auc(distance_test, test_Y);
        
        test_acc(i,1)=testAcc;
        test_precision(i,1)=precision;
        test_recall(i,1)=recall;
        test_F1(i,1)=F1;
        test_g(i,1)=g_mean;
        test_auc(i,1)=auc;
        train_times(i,1)=train_time;
        test_times(i,1)=test_time;

    end
        disp('C:')
        disp(params.C)
        if mean(test_g)>best_g5
            best_g5=mean(test_g);
            std_g5=std(test_g);
            para_C5=params.C;
            para_L5 = params.L;
            ave_traintime5=mean(train_times);
            ave_testtime5=mean(test_times);
            load('OCELM_train.mat','OutputWeight');
            belta = OutputWeight;
            save('OCELM_sonar_g.mat','best_g5','std_g5','para_C5','para_L5','ave_traintime5','ave_testtime5','belta');
        end
%             if mean(test_F1)>best_F15
%                 best_F15 = mean(test_F1);
%                 std_F15 = std(test_F1);
%                 para_C5 = params.C;
%                 para_L5 = params.L;
%                 save('OCELM_ecoli_F1.mat','best_F15','std_F15','para_C5','para_L5');
%             end
end


toc
