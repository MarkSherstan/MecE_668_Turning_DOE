clear all
close all
clc

% Load in presaved Data
load('./data/MidPoint1.mat')

% Clean up the data
[aa,ww] = cleanData(a,w,t);

% Match up sensor data and video data
[aa,ww,tt,pospos,posResample] = dataSlicer(aa,ww,t,pos);

% Find the circle radius for slip detection and instantaneous velocity
R = circleFilter(pospos,scale);

% Plot the results
close all
slipInstantV = plotter(pospos,aa,ww,tt,R)
