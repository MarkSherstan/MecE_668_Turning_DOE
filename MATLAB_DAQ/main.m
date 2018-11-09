clear all
close all
clc

% Constant values / variables
videoFileName = 'DATA00.mp4';
dataFileName = 'DATA00.csv';

% Get scale
[scale, red, blue, green] = scale(videoFileName,false);

% Calculate positions
pos = positionLogger(videoFileName);

% Read in sensor data
[a,w,t,PWM] = fileReader(dataFileName);

% Clean up the data
[aa,ww] = cleanData(a,w,t)

% Match up data
[aa,ww,tt,pospos] = dataSlicer(aa,ww,t,pos);

% Find the function for vehicles angular velocity
y = createFit(tt.seconds, ww.z);

% Find the circle radius for slip detection and instantaneous velocity
[posZeroX, posZeroY, radius] = circleFilter(pos,scale,false);

% Plot the results
close all
plotter(pos, aa, ww, t, y)
