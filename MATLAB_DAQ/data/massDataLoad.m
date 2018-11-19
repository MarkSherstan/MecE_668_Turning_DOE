clear all
close all
clc

figure(1)
str = cell(3,1);

for ii = 1:3
    str{ii} = strcat('run',num2str(ii),'.mat');
    load(str{ii})
    
    
    hold on 
    r = resample(radius.meters,length(t.seconds),length(radius.meters));
    plot(t.seconds,r)
end

legend(str')
hold off