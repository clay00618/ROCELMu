function K = kernel(X,Y,type, parameter)

switch type
    case{'linear'}
        K = X'*Y;
    case{'rbf'}
        XX = sum(X'.*X',2);  % N×1
        YY = sum(Y'.*Y',2);
        XY = X'*Y;   % N×N
        K = abs(repmat(XX,[1 size(YY,1)])+repmat(YY',[size(XX,1) 1]) - 2*XY);
        K = exp(-K./parameter);
end
end