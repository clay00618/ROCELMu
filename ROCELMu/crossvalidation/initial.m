InputWeight = rand(1000,60)*2-1;
BiasofHiddenNeurons = rand(1000,1);


% noise_ind = randperm(207, floor(207*0.2));
save('InputWeight.mat', 'InputWeight');
% save('arrhythmia_noise_ind.mat','noise_ind');
save('BiasofHiddenNeurons.mat','BiasofHiddenNeurons');

% r = zeros(10,245);
% for i=1:10
%     r(i,:) = randperm(245);
% end
% save('arrhythmia_ind.mat','r');




