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
[vel, pos] = velocityLogger(videoFileName,extraPoints,scale);
toc


tic
[a,w,t] = fileReader(dataFileName,extraPoints);
toc


tic
plotter(vel, pos, a, w, t)
toc


%% This is just some stuff
% v = wr
centerX = mean(pos.x);
centerY = mean(pos.y);

sortX = sort(pos.x);
sortY = sort(pos.y);

radiusX = centerX - mean(sortX(1:10));
radiusY = centerY - mean(sortY(1:10));

radius = (radiusX + radiusY)/2;

w = mean(vel.mag./radius);

rpm = w*60;
