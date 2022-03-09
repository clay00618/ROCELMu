function model = LSOCSVM_train(X,Y,params)

train_start = tic;
n=length(Y);

temp = ((1/params.C)*eye(n)+kernel(X,X,params.kertype,params.k))\ones(n,1);

critical = 1/(ones(1,n)/((1/params.C)*eye(n)+kernel(X,X,params.kertype,params.k))*ones(n,1));


alpha = temp.*critical;

train_end = toc(train_start);

distance_train = (abs(alpha'*kernel(X,X,params.kertype,params.k) - critical))/sqrt(alpha'*alpha);

distance_train_sorted = sort(distance_train,'descend');
index_m = floor(params.mu*n);

if index_m == 0 || index_m==1
    theta = distance_train_sorted(1,1);
else
    theta = distance_train_sorted(1,index_m);
end

model.alpha = alpha;
model.critical = critical;
model.train_time = train_end;
model.X = X;
model.theta = theta;

save('lsocsvm_train.mat','-struct','model');

end



