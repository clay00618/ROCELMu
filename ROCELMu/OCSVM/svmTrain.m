function model = svmTrain(X,Y,params)

options = optimset;
options.LargeScale = 'off';
options.Display = 'off';

train_start = tic;
n=length(Y);
H=kernel(X,X,params.kertype,params.k);
% 拉格朗日乘子是n×1的列向量
f = zeros(n,1);
A = [];
b = [];
Aeq = ones(1,n);
beq = 1;
lb = zeros(n,1);
ub = (1/(params.v*n)).*ones(n,1);
a0 = zeros(n,1);

[a, fval, exitflag, ~, lambda] = quadprog(H,f,A,b,Aeq,beq,lb,ub,a0,options);

%{
disp('问题的解alpha：')
disp(a)
disp('目标函数在解a处的值:')
disp(fval)
disp('解a处的拉格朗日乘子的值：')
disp(lambda)
disp('退出的状态值:')
disp(exitflag)
%}

epsilon = 10^-8;
sv_label = find(a>epsilon);

temp = a(sv_label)'*kernel(X(:,sv_label),X(:,sv_label),params.kertype,params.k);
rou = mean(temp);

train_end = toc(train_start);


model.a = a(sv_label);
model.Xsv = X(:,sv_label);
model.Ysv = Y(sv_label);
model.svnum = length(sv_label);
model.rou = rou;
model.train_time = train_end;

save('svm_train.mat','-struct','model');

end


