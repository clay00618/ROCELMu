function auc = calculate_auc(distance_test, test_Y)

% the number of positive samples
pos_num = sum(test_Y == 1);
% the number of negative samples
neg_num = sum(test_Y == -1);

N = length(test_Y);

[~, ind] = sort(distance_test,'descend');
test_Y = test_Y(ind);

PX=zeros(N+1,1);
PY=zeros(N+1,1);
auc=0;
PX(1)=1;
PY(1)=1;

for i=2:N
    T = sum(test_Y(i:N)==1);
    F = sum(test_Y(i:N)==-1);
    PX(i) = F/neg_num;
    PY(i) = T/pos_num;
    auc = auc + (PY(i)+PY(i-1))*(PX(i-1)-PX(i))/2;
end

PX(N+1) = 0;
PY(N+1) = 0;
auc = auc + PY(N)*PX(N)/2;

%{
figure(1);
set(0,'defaultfigurecolor','w');
plot(PX,PY);
title('IROCELM','FontSize',12,'FontWeight','normal','FontName','Arial');    
xlabel('False positive rate');
ylabel('True positive rate');
%}

end



