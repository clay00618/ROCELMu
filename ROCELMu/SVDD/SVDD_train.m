function model = SVDD_train(X,Y,params)


options = optimset;
options.LargeScale = 'off';
options.Display = 'off';

train_start = tic;
n=length(Y);
H=0.5*kernel(X,X,params.kertype,params.k);

f = zeros(n,1);
for i=1:n
    f(i)=-kernel(X(:,i),X(:,i),params.kertype,params.k);
end

A=[];
b=[];
Aeq = ones(1,n);
beq = 1;
lb = zeros(n,1);
ub = params.C*ones(n,1);
a0 = zeros(n,1);

[a, fval, exitflag, ~, lambda] = quadprog(H,f,A,b,Aeq,beq,lb,ub,a0,options);
epsilon = 10^-8;
%支持向量
sv_label = find(a>epsilon);
X_temp = X(:,sv_label);
a_temp = a(sv_label,:);

l2_X = sum(X(:,sv_label).*X(:,sv_label),1);
l2_a = repelem(a_temp'*kernel(X_temp,X_temp,params.kertype,params.k)*a_temp,length(sv_label));
radius = mean(l2_X+l2_a - 2.*a_temp'*kernel(X_temp,X_temp,params.kertype,params.k));

train_end = toc(train_start);

model.a = a_temp;
model.Xsv = X_temp;
model.Ysv = Y(sv_label);
model.svnum = length(sv_label);
model.radius = radius;
model.train_time = train_end;

save('svdd_train.mat','-struct','model');
end

