clear all
close all
clc


videoFileName = 'testMe.mov';
dataFileName = 'DATA01.csv';
extraPoints = 50;

tic
% [scale, red, blue, green] = scale(filename,false);
% 30 fps --> 0.029464206496742
% 240 fps --> 0.048056789348528
scale = 0.048056789348528;
toc


tic
[angularV, instantV, pos] = velocityLogger(videoFileName,extraPoints,scale);
toc


tic
[a,w,t] = fileReader(dataFileName,extraPoints);
toc


angularVResample = resample(angularV,length(a.y),length(angularV));


tic
plotter(angularV, instantV, pos, a, w, t, angularVResample)
toc
