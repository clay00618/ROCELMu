function ORELM_visual(train_data, test_data, rho, X, Y, params)

%% figure setting
figure
% set attributes of figure
set(gcf, 'unit', 'centimeters', 'position', [0 0 25 12.5])
set(0,'defaultfigurecolor','w');
% asix settings
t_gca = 10;     % font size
t_font = 'Arial'; % font type
set(gca, 'FontSize', t_gca, 'FontName', t_font)
% legend setting
t_legend = t_gca*0.9;
% label setting
t_label = t_gca*1.1;
% size of scatter
sz = 24;
% line width
l_width = 1.2;


%% contour line setting
subplot(1,2,1);

[~, ax1] = contourf(X, Y, rho, 'ShowText', 'on');
colormap(jet);
ax1.LineWidth=1;
str_1 = ['C=',num2str(params.C),', L=', num2str(params.L)];
title(str_1,...
        'FontSize', t_label,...
        'FontWeight', 'normal',...
        'FontName', t_font)
legend(ax1, 'contour',...
      'FontSize', t_legend,...
      'FontWeight', 'normal',...
      'FontName', t_font)
set(gca, 'linewidth', l_width, 'fontsize', t_label, 'fontname', t_font )

%% Prediction accuracy of testing data
subplot(1,2,2);
cmap = [1,1,1];
[~, ax1] = contourf(X, Y, rho, [0.00005,0.00005]);
colormap(gca(),cmap);
ax1.LineWidth = 1;
ax1.LineColor = [0,0,0];

hold on

% training data
ax2 = scatter(train_data(1:70,1), train_data(1:70,2), sz,'MarkerEdgeColor', 'k',...
    'MarkerFaceColor', [0 1 0]);

% testing data
ax3 = scatter(test_data(:,1), test_data(:,2), sz,'+');

% noise data
ax4 = scatter(train_data(71:80,1), train_data(71:80,2), sz, '*');

% legend settings
legend([ax1, ax2, ax3, ax4],...
        {'Decision boundary', 'Training data', 'Testing data','Noise data'},...
        'FontSize', t_legend, 'FontWeight', 'normal', 'FontName', t_font,...
        'Location', 'northwest', 'NumColumns', 1)
    
set(gca, 'linewidth', l_width, 'fontsize', t_label, 'fontname', t_font ) 

end
