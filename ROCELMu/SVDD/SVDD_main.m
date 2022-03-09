close all
clc
clear

parentPath = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(parentPath))


test_acc=zeros(10,1);
test_precision=zeros(10,1);
test_recall=zeros(10,1);
test_F1=zeros(10,1);
test_g=zeros(10,1);
test_auc=zeros(10,1);
train_times=zeros(10,1);
test_times=zeros(10,1);

% data preparation
[train_X0,train_Y0,test_X0, test_Y0] = Preprocessing;

temp_test_X0 = test_X0;
temp_test_Y0 = test_Y0;

% SVDD
C=[2^-4 2^-3 2^-2 2^-1 1 2 2^2 2^3 2^4 2^5 2^6 2^7 2^8 2^9 2^10]; 
k=[2^-7 2^-6 2^-5 2^-4 2^-3 2^-2 2^-1 1 2 2^2 2^3 2^4 2^5 2^6 2^7]; %15
params.kertype='rbf';
best_g8=0;
tic

load(fullfile(parentPath,'\crossvalidation\abalone_ind.mat'));
load(fullfile(parentPath,'\crossvalidation\abalone_noise_ind.mat'));

for l=1:length(C)
    params.C=C(l);
    for j=1:length(k)
        params.k = k(j);
        for i=1:10
            
            test_X0 = temp_test_X0;
            test_Y0 = temp_test_Y0;

            % 交叉验证
            % 噪声数据比例
            % noise_r=0,0.25,0.5,0.75,1 分别对应0，10%，20%，30%，40%噪声比例
            noise_r = 0;
            noise = noise_ind(:,1:floor(size(noise_ind,2)*noise_r));
            noise_X = test_X0(noise,:);
            number_X = floor(0.8*size(r,2));
            train_X=[train_X0(r(i,1:number_X),:);noise_X]';
            train_Y=[train_Y0(r(i,1:number_X),:);ones(size(noise_X,1),1)]';
            test_X0(noise_ind,:)=[];
            test_Y0(noise_ind,:)=[];
            test_X=[train_X0(r(i,number_X+1:end),:);test_X0]';
            test_Y=[train_Y0(r(i,number_X+1:end),:);test_Y0]';     
            
            
            % 数据标准化处理
%             [trainsamples,m,s]=Train_statwo(train_X);
%             [testsamples]=Test_statwo(test_X,m,s);
%             train_X=trainsamples;
%             test_X=testsamples;
            
            % 数据归一化处理
            [trainsamples,difference,t_min]=Train_normtwo(train_X,test_X);
            [testsamples]=Test_normtwo(test_X,t_min,difference);
            train_X=trainsamples;
            test_X=testsamples;

            % training
            model = SVDD_train(train_X,train_Y,params);
            % testing
            [testAcc,precision,recall,g_mean,F1,train_time,test_time,distance_test] = SVDD_predict(model, test_X, test_Y, params);
            
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
            disp('平均g_mean值：')
            disp(mean(test_g))
            disp('g_mean偏差：')
            disp(std(test_g))
            if mean(test_g)>best_g8
                best_g8=mean(test_g);
                std_g8=std(test_g);
                para_C8=params.C;
                para_k8=params.k;
                ave_traintime8=mean(train_times);
                ave_testtime8=mean(test_times);
                ave_acc8=mean(test_acc);
                ave_auc8=mean(test_auc);
                ave_F18 = mean(test_F1);
                std_acc8 = std(test_acc);
                std_auc8 = std(test_auc);
                std_F18 = std(test_F1);
                save('SVDD_abalone_g.mat','best_g8','std_g8','para_C8','para_k8','ave_traintime8','ave_testtime8','ave_acc8','ave_auc8','ave_F18','std_acc8','std_auc8','std_F18');
            end
    end
end

toc


