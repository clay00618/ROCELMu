function H = OutputMatrixH(tempH,ActivationFunction)

switch lower(ActivationFunction) %激活函数、计算隐含层输出H
    case{'sig','sigmoid'}
        H=1./(1+exp(-tempH));
    case{'sin','sine'}
        H=sin(tempH);
    case{'hardlim'}
        H=double(hardlim(tempH));
    case{'tribas'}
        % Triangular basis function
        H=tribas(tempH);
    case{'radbas'}
        % Radial basis function
        H=radbas(tempH);
        % more activation functions can be added here
end
end
