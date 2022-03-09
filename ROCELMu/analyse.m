%算法分析  Abalone
x=[500,1000,1500,2000];
% EROCELM 蓝色
y1=[0.5358,0.5772,0.5982,0.6064];
% ELMRCC 青色
y2=[0.4312,0.4584,0.4518,0.4776];
% ORELM 红色
y3=[0.5474,0.5643,0.5322,0.5842];
% L1-OCELM 粉色
y4=[0.5264,0.4790,0.4960,0.4847];
% WELM 黑色
y5=[0.4280,0.5075,0.5114,0.5568];
% OCELM 绿色
y6=[0.4112,0.4877,0.4598,0.4783];
figure 
set(0,'defaultfigurecolor','w');
set(gcf,'position',[200,300,400,400]);
% set(gca,'LineWidth',20);
plot(x,y1,'-ob','MarkerSize',8,'MarkerFaceColor','b');
hold on
plot(x,y2,'-squarec','MarkerSize',8,'MarkerFaceColor','c');
plot(x,y3,'-diamondr','MarkerSize',8,'MarkerFaceColor','r');
plot(x,y4,'-pentagramm','MarkerSize',8,'MarkerFaceColor','m');
plot(x,y5,'->k','MarkerSize',8,'MarkerFaceColor','k');
plot(x,y6,'-<g','MarkerSize',8,'MarkerFaceColor','g');
grid on
set(gca,'GridLineStyle','--','LineWidth',1,'FontSize',13);
xlabel('L');
ylabel('g-mean');
legend('ER-OCELM','ELM-RCC','ORELM','L1-ELM','WELM','OC-ELM');


% EROCELM
y1=[0.3209,0.3562,0.3634,0.3969];
% ELMRCC
y2=[0.2036,0.2246,0.2583,0.2607];
% ORELM
y3=[0.3193,0.3273,0.3448,0.3589];
% L1-OCELM
y4=[0.3257,0.2794,0.2947,0.2985];
% WELM
y5=[0.2916,0.2936,0.3084,0.3083];
% OCELM
y6=[0.1849,0.1908,0.2053,0.2764];

figure 
set(0,'defaultfigurecolor','w');
set(gcf,'position',[200,300,400,400]);
% set(gca,'LineWidth',20);
plot(x,y1,'-ob','MarkerSize',8,'MarkerFaceColor','b');
hold on
plot(x,y2,'-squarec','MarkerSize',8,'MarkerFaceColor','c');
plot(x,y3,'-diamondr','MarkerSize',8,'MarkerFaceColor','r');
plot(x,y4,'-pentagramm','MarkerSize',8,'MarkerFaceColor','m');
plot(x,y5,'->k','MarkerSize',8,'MarkerFaceColor','k');
plot(x,y6,'-<g','MarkerSize',8,'MarkerFaceColor','g');
grid on
set(gca,'GridLineStyle','--','LineWidth',1,'FontSize',13);
xlabel('L');
ylabel('g-mean');


% EROCELM
y1=[0.2881,0.2676,0.2959,0.3185];
% ELMRCC
y2=[0.1661,0.1756,0.1918,0.1996];
% ORELM
y3=[0.2121,0.2523,0.2582,0.3044];
% L1-OCELM
y4=[0.2826,0.2575,0.2402,0.2576];
% WELM
y5=[0.2510,0.2716,0.2441,0.2544];
% OCELM
y6=[0.1519,0.1455,0.1555,0.2049];


figure 
set(0,'defaultfigurecolor','w');
set(gcf,'position',[200,300,400,400]);
plot(x,y1,'-ob','MarkerSize',8,'MarkerFaceColor','b');
hold on
plot(x,y2,'-squarec','MarkerSize',8,'MarkerFaceColor','c');
plot(x,y3,'-diamondr','MarkerSize',8,'MarkerFaceColor','r');
plot(x,y4,'-pentagramm','MarkerSize',8,'MarkerFaceColor','m');
plot(x,y5,'->k','MarkerSize',8,'MarkerFaceColor','k');
plot(x,y6,'-<g','MarkerSize',8,'MarkerFaceColor','g');
grid on
set(gca,'GridLineStyle','--','LineWidth',1,'FontSize',13);
xlabel('L');
ylabel('g-mean');

% parentPath = fileparts(mfilename('fullpath'));
% load(fullfile(parentPath,'IROCELM_glass_g.mat'),'objectiveValue');
% figure
% set(0,'defaultfigurecolor','w');
% set(gcf,'position',[700,300,400,400]);
% x = 1:50;
% plot(x,objectiveValue,'linewidth',3);
% set(gca,'GridLineStyle','--','LineWidth',1,'FontSize',13);
% xlabel('Iterations');
% ylabel('Objective value');