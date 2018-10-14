clear all
close all
clc

% Constant values / variables
videoFileName = 'VID00-converted.mp4';
dataFileName = 'DATA00.csv';
extraPoints = 0;
initialCaptureRate = 240;

% Get scale
% [scale, red, blue, green] = scale(filename,false);
% 30 fps --> 0.029464206496742
% 240 fps --> 0.048056789348528
scale = 0.048056789348528;

% Calculate positions
pos = positionLogger(videoFileName);

% Read in sensor data and clean where required
[a,w,t] = fileReader(dataFileName);
a.y = cleanUpFreq(a.y,mean(t.frequency),4);

% Match up data
[a,w,t,pos] = dataSlicer(a,w,t,pos,extraPoints);

% Calculate angles and velocitys
[angleDeltaRad, angleRad, p] = angleVelCalc(pos, 1, 1400, 10, initialCaptureRate);
close all

% Cut off ends of data? --> Find where the car slipped


% Plot the results
plotter(angleDeltaRad, angleRad, pos, a, w, t, p, initialCaptureRate)
