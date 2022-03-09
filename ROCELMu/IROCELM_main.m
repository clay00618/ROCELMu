close all
clc
clear

format shortEng


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


% setting parameters
% 2^-10 2^-9 2^-8 2^-7 2^-6 2^-5 2^-4 2^-3 2^-2 2^-1 1 2 2^2 2^3 2^4 2^5 2^6 2^7 2^8 2^8 2^9 2^10 2^11 2^12 2^13 2^14 2^15 2^16 2^17 2^18 
C=[2^-10 2^-9 2^-8 2^-7 2^-6 2^-5 2^-4 2^-3 2^-2 2^-1 1 2 2^2 2^3 2^4 2^5 2^6 2^7 2^8 2^9 2^10 2^11 2^12 2^13 2^14 2^15 2^16 2^17 2^18 2^19 2^20];
lambda=[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1]; % 11
eta=[2^-7 2^-6 2^-5 2^-4 2^-3 2^-2 2^-1 1 2 2^2 2^3 2^4 2^5 2^6 2^7]; % 15
params.L=1000;
params.tmax=20;
params.mu=0;
% 最高的g-mean
best_g1=0;
% 最高的accuracy
best_acc1=0;
% 最高的F1
best_F11=0;
tic

parentPath = fileparts(mfilename('fullpath'));
load(fullfile(parentPath,'\crossvalidation\sonar_ind.mat'));
load(fullfile(parentPath,'\crossvalidation\sonar_noise_ind.mat'));

for l=1:1
    params.C=16;
    for j=1:1
        params.eta=0.125;
        for k=1:1
            params.lambda=0.1;
            for i=1:10   
                
                test_X0 = temp_test_X0;
                test_Y0 = temp_test_Y0;
                
                % 噪声数据比例
                % noise_r=0,0.25,0.5 分别对应0，10%，20%噪声比例
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

                % 数据标准化处理
%                 [trainsamples,m,s]=Train_sta(train_X);
%                 [testsamples]=Test_sta(test_X,m,s);
%                 train_X=trainsamples;
%                 test_X=testsamples;

                % 数据归一化处理
                [trainsamples,difference,t_min]=Train_norm(train_X,test_X);
                [testsamples]=Test_norm(test_X,t_min,difference);
                train_X=trainsamples;
                test_X=testsamples;


                % training and testing
                model = IROCELM(train_X,train_Y,params,'sigmoid');
                [testAcc,precision,recall,g_mean,F1,train_time,test_time,distance_test] = IROCELM_predict(model,test_X,test_Y);
                
              
                % decision boundary
                %[rho,X,Y] = IROCELM_decision(model, train_X);
                % visualization
                %IROCELM_visual(train_X, test_X, rho, X, Y, params);
                
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
            disp('平均g-mean值：')
            disp(mean(test_g))
            disp('C的值:')
            disp(params.C)    
            if mean(test_g)>best_g1
                best_g1=mean(test_g);
                std_g1=std(test_g);
                para_C1=params.C;
                para_lambda1=params.lambda;
                para_eta1=params.eta;
                para_L1 = params.L;
                ave_traintime1=mean(train_times);
                ave_testtime1=mean(test_times);
                ave_acc1 = mean(test_acc);
                ave_auc1 = mean(test_auc);
                ace_F1 = mean(test_F1);
                load('IROCELM_train.mat','OutputWeight','object_value');
                belta = OutputWeight;
                objectiveValue = object_value;
                save('IROCELM_sonar_g.mat','best_g1','std_g1','ave_acc1','ave_auc1','ace_F1','para_C1','para_lambda1','para_eta1','para_L1','ave_traintime1','ave_testtime1','belta','objectiveValue');
            end
%             if mean(test_F1)>best_F11
%                 best_F11 = mean(test_F1);
%                 std_F11 = std(test_F1);
%                 para_C1 = params.C;
%                 para_lambda1=params.lambda;
%                 para_eta1=params.eta;
%                 para_L1 = params.L;
%                 save('IROCELM_abalone_F1.mat','best_F11','std_F11','para_C1','para_lambda1','para_eta1','para_L1');
%             end
        end
    end
end
toc


