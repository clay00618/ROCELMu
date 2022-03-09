x=-10:10;
y = x.^2;
figure
set(0,'defaultfigurecolor','w');
plot(x,y);
ylabel('Square loss');
xlabel('Error \xi');

y0 = 1/(1-exp(-0.3))*(1-exp(-0.3.*x.^2));
figure
set(0,'defaultfigurecolor','w');
plot(x,y0);
text(3,3.599,'\it \eta=0.3','HorizontalAlignment','left');
ylabel('Correntropy loss');
xlabel('Error \xi');
hold on
y1 = 1/(1-exp(-1))*(1-exp(-1.*x.^2));
plot(x,y1,'--r');
text(1,1,'\it \eta=1','HorizontalAlignment','left');
hold on
y2 = 1/(1-exp(-0.5))*(1-exp(-0.5.*x.^2));
plot(x,y2,':g');
text(2,2.19754,'\it \eta=0.5','HorizontalAlignment','left');
hold on
y3 = 1/(1-exp(-0.2))*(1-exp(-0.2.*x.^2));
plot(x,y3,'-.m');
text(4,5.29178,'\it \eta=0.2','HorizontalAlignment','left');







