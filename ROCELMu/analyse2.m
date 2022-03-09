parentPath = fileparts(mfilename('fullpath'));
load(fullfile(parentPath,'l1ELM\l1OCELM_sonar_g.mat'),'belta');
figure
sign = 10^-5;
count=0;
for i=1:size(belta,1)
    if belta(i,1)<=sign
        count = count+1;
    end
end
h = histogram(belta);
% h.NumBins = 20;
set(0,'defaultfigurecolor','w');
set(gca,'GridLineStyle','--','LineWidth',1,'FontSize',13);
title('Weights distribution');
xlabel('Weights value');
ylabel('Number of weights');
disp(count)
disp(sign)

