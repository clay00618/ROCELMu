% 将所有训练结果保存到excel表格中

parentPath = fileparts(mfilename('fullpath'));


noise = 0;
load('IROCELM_abalone_g.mat')
load(fullfile(parentPath,'\WELM\WELM_abalone_g.mat'))
load(fullfile(parentPath,'\ORELM\ORELM_abalone_g.mat'))
load(fullfile(parentPath,'\OCELM\OCELM_abalone_g.mat'))
load(fullfile(parentPath,'\l1ELM\l1OCELM_abalone_g.mat'))
load(fullfile(parentPath,'\ELMRCC\ELMRCC_abalone_g.mat'))
parameters = {'noise';'ave_g';'std_g';'C';'L';'eta';'lambda'};
IROCELM = [noise;best_g1;std_g1;para_C1;para_L1;para_eta1;para_lambda1];
WELM = [noise;best_g4;std_g4;para_C4;para_L4;NaN;NaN;];
ORELM = [noise;best_g2;std_g2;para_C2;para_L2;NaN;NaN;];
OCELM = [noise;best_g5;std_g5;para_C5;para_L5;NaN;NaN];
l1OCELM = [noise;best_g3;std_g3;para_C3;para_L3;NaN;NaN];
ELMRCC = [noise;best_g9;std_g9;para_C9;para_L9;para_eta9;NaN];
Ecoli = table(IROCELM,ORELM,l1OCELM,WELM,OCELM,ELMRCC,'RowNames',parameters);
writetable(Ecoli,[parentPath,'\Performance\abalone.dat'],'WriteRowNames',true);


%{
load(fullfile(parentPath,'\WELM\WELM_ecoli_g.mat'))
parameters = {'noise';'g_mean';'std_g';'train_time';'test_time';'auc';'std_auc';'C';'L';'eta';'lambda';'k';'v'};
WELM = [0;best_g;std_g;ave_traintime;ave_testtime;ave_auc;std_auc;para_C;para_L;NaN;NaN;NaN;NaN];
Ecoli = table(WELM,'RowNames',parameters);
writetable(Ecoli,[parentPath,'\Performance\Ecoli.dat'],'WriteRowNames',true);
%}


%{
load(fullfile(parentPath,'\SVDD\SVDD_ecoli_g.mat'))
parameters = {'noise';'g_mean';'std_g';'train_time';'test_time';'auc';'std_auc';'C';'L';'eta';'lambda';'k';'v'};
SVDD = [0.1;best_g;std_g;ave_traintime;ave_testtime;ave_auc;std_auc;para_C;NaN;NaN;NaN;para_k;NaN];
Ecoli = table(SVDD,'RowNames',parameters);
writetable(Ecoli,[parentPath,'\Performance\Ecoli.dat'],'WriteRowNames',true);
%}

%{
load(fullfile(parentPath,'\ORELM\ORELM_ecoli_g.mat'))
parameters = {'noise';'g_mean';'std_g';'train_time';'test_time';'auc';'std_auc';'C';'L';'eta';'lambda';'k';'v'};
ORELM = [0.1;best_g;std_g;ave_traintime;ave_testtime;ave_auc;std_auc;para_C;para_L;NaN;NaN;NaN;NaN];
Ecoli = table(ORELM,'RowNames',parameters);
writetable(Ecoli,[parentPath,'\Performance\Ecoli.dat'],'WriteRowNames',true);
%}

%{
load(fullfile(parentPath,'\OCSVM\OCSVM_ecoli_g.mat'))
parameters = {'noise';'g_mean';'std_g';'train_time';'test_time';'auc';'std_auc';'C';'L';'eta';'lambda';'k';'v'};
OCSVM = [0.1;best_g;std_g;ave_traintime;ave_testtime;ave_auc;std_auc;NaN;NaN;NaN;NaN;para_k;para_v];
Ecoli = table(OCSVM,'RowNames',parameters);
writetable(Ecoli,[parentPath,'\Performance\Ecoli.dat'],'WriteRowNames',true);
%}


%{
load(fullfile(parentPath,'\OCELM\OCELM_ecoli_g.mat'))
parameters = {'noise';'g_mean';'std_g';'train_time';'test_time';'auc';'std_auc';'C';'L';'eta';'lambda';'k';'v'};
OCELM = [0.1;best_g;std_g;ave_traintime;ave_testtime;ave_auc;std_auc;para_C;para_L;NaN;NaN;NaN;NaN];
Ecoli = table(OCELM,'RowNames',parameters);
writetable(Ecoli,[parentPath,'\Performance\Ecoli.dat'],'WriteRowNames',true);
%}

%{
load(fullfile(parentPath,'\LSOCSVM\LSOCSVM_ecoli_g.mat'))
parameters = {'noise';'g_mean';'std_g';'train_time';'test_time';'auc';'std_auc';'C';'L';'eta';'lambda';'k';'v'};
LSOCSVM = [0;best_g;std_g;ave_traintime;ave_testtime;ave_auc;std_auc;para_C;NaN;NaN;NaN;para_k;NaN];
Ecoli = table(LSOCSVM,'RowNames',parameters);
writetable(Ecoli,[parentPath,'\Performance\Ecoli.dat'],'WriteRowNames',true);
%}

%{
load(fullfile(parentPath,'\l1ELM\l1OCELM_ecoli_g.mat'))
parameters = {'noise';'g_mean';'std_g';'train_time';'test_time';'auc';'std_auc';'C';'L';'eta';'lambda';'k';'v'};
l1OCELM = [0;best_g;std_g;ave_traintime;ave_testtime;ave_auc;std_auc;para_C;para_L;NaN;NaN;NaN;NaN];
Ecoli = table(l1OCELM,'RowNames',parameters);
writetable(Ecoli,[parentPath,'\Performance\Ecoli.dat'],'WriteRowNames',true);
%}

