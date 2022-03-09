close
clc

n_all = [2 202 402 602 802 1002 1202 1402 1602 1802 2002 2202 2402 ...
    2602 2802 3002 3202 3402 3602 3802 4002 4202 4402 4602 4802];
times = zeros(size(n_all,2),2);

tic
for i=1:size(n_all,2)
    
    disp(i)
    number = n_all(1,i);
    matrix_1 = 10-rand(number,number)*20;
    matrix_2 = 10-rand(number,number)*20;

    train_start1 = tic;
    matrix_3 = matrix_1*matrix_2;
    train_end1 = toc(train_start1);
    times(i,1)=train_end1;
    
    train_start2 = tic;
    inv_matrix_1 = matrix_2/matrix_1*matrix_2';
    train_end2 = toc(train_start2);
    times(i,2)=train_end2;

end


figure
set(gcf, 'unit', 'centimeters', 'position', [0 0 25 12.5])
set(0,'defaultfigurecolor','w');

subplot(1,2,1);
plot(n_all.^3/10^9,times(:,1),'o-');
xlabel('n_all.^3/10^9');
ylabel('time');

subplot(1,2,2);
plot((n_all+1).^3/10^9,times(:,2),'o-');
xlabel('n_all.^3/10^9');
ylabel('time');

toc


