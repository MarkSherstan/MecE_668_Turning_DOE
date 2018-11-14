clear all
close all
clc

% Constant values / variables
videoFileName = 'Trial#.mp4';
dataFileName = 'Trial#.csv';

% Get scale
scale = scale(videoFileName,true);

% Calculate positions
pos = positionLogger(videoFileName);

% Read in sensor data
[a,w,t,PWM] = fileReader(dataFileName);

% Clean up the data
[aa,ww] = cleanData(a,w,t);

% Match up sensor data and video data
[aa,ww,tt,pospos,posResample] = dataSlicer(aa,ww,t,pos);

% Find the circle radius for slip detection and instantaneous velocity
[posZerod,radius] = circleFilter(pospos,scale,false);

% Plot the results
close all
plotter(pos, posZerod, radius, aa, ww, tt)
