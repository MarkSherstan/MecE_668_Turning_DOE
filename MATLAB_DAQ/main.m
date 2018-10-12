clear all
close all
clc


videoFileName = '01.mp4';
dataFileName = 'DATA01.csv';
extraPoints = 50;

tic
% [scale, red, blue, green] = scale(filename,false);
% 30 fps --> 0.029464206496742
% 240 fps --> 0.048056789348528
scale = 0.048056789348528;
toc


tic
[vel, pos] = velocityLogger(videoFileName,extraPoints);
toc


tic
[a,w,t] = fileReader(dataFileName,extraPoints);
toc


tic
plotter(vel, pos, a, w, t)
toc
