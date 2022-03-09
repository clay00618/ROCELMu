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

% 设置参数
%v=[2^-10 2^-9 2^-8 2^-7 2^-6 2^-5 2^-4 2^-3 2^-2 2^-1 1];
v=[0.01 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
k=[2^-7 2^-6 2^-5 2^-4 2^-3 2^-2 2^-1 1 2 2^2 2^3 2^4 2^5 2^6 2^7];
params.kertype='rbf';
best_g7=0;
tic

load(fullfile(parentPath,'\crossvalidation\abalone_ind.mat'));
load(fullfile(parentPath,'\crossvalidation\abalone_noise_ind.mat'));

for l=1:length(v)
    params.v=v(l);
    for j=1:length(k)
        params.k=k(j);
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
            
            % 数据归一化处理
            [trainsamples,difference,t_min]=Train_normtwo(train_X,test_X);
            [testsamples]=Test_normtwo(test_X,t_min,difference);
            train_X=trainsamples;
            test_X=testsamples;
            
            % 数据标准化处理
%             [trainsamples,m,s]=Train_statwo(train_X);
%             [testsamples]=Test_statwo(test_X,m,s);
%             train_X=trainsamples;
%             test_X=testsamples;

            % training
            model = svmTrain(train_X,train_Y,params);
            % testing
            [testAcc,precision,recall,g_mean,F1,train_time,test_time,distance_test] = svmTest(model, test_X, test_Y, params);

            %[rho, X, Y] = OCSVM_decision(model,train_X,params);
            %OCSVM_visual(train_X, test_X, rho, X, Y, params);
            
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
            if mean(test_g)>best_g7
                best_g7=mean(test_g);
                std_g7=std(test_g);
                para_v7=params.v;
                para_k7=params.k;
                ave_traintime7=mean(train_times);
                ave_testtime7=mean(test_times);
                ave_acc7=mean(test_acc);
                ave_auc7=mean(test_auc);
                ave_F17 = mean(test_F1);
                std_acc7 = std(test_acc);
                std_auc7 = std(test_auc);
                std_F17 = std(test_F1);
                save('OCSVM_abalone_g.mat','best_g7','std_g7','para_v7','para_k7','ave_traintime7','ave_testtime7','ave_acc7','ave_auc7','ave_F17','std_acc7','std_auc7','std_F17');
            end
    end
end

toc






