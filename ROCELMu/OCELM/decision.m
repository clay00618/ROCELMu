function [rho, X, Y] = decision(model, train_data)

%% compute the range of grid 
r=0.5;
d=0.5;
x1_min = min(train_data(:,1));
x1_max = max(train_data(:,1));
x2_min = min(train_data(:,2));
x2_max = max(train_data(:,2));

if x1_min<0
    x1_min=x1_min*(1+r);
else
    x1_min=x1_min*(1-r);
end

if x2_min<0
    x2_min=x2_min*(1+r);
else
    x2_min=x2_min*(1-r);
end

if x1_max<0
    x1_max=x1_max*(1-r);
else
    x1_max=x1_max*(1+r);
end

if x2_max<0
    x2_max=x2_max*(1-r);
else
    x2_max=x2_max*(1+r);
end

x_range = x1_min:d:x1_max;  
y_range = x2_min:d:x2_max;

%% generate the grid data
[X, Y] = meshgrid(x_range, y_range);  
X_Grid = [X(:), Y(:)];                

%% the grid label is only for the input of the function 'OCELM_predict'
grid_label = ones(size(X_Grid, 1), 1);

% get the distance vector of each grid point
[~, ~, ~, ~, ~, ~, ~, rho_0] = OCELM_predict(X_Grid, grid_label, model);
rho = reshape(rho_0, size(X));

end
