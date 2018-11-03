clear all
close all
clc

% Constant values / variables
videoFileName = 'DATA00.mp4';
dataFileName = 'DATA00.csv';
initialCaptureRate = 240;

% Get scale
[scale, red, blue, green] = scale(videoFileName,false);

% Calculate positions
pos = positionLogger(videoFileName);

% Read in sensor data
[a,w,t,PWM] = fileReader(dataFileName);

% Clean up the data
[aa,ww] = cleanData(a,w,t)

% Match up data
[aa,ww,t,pos] = dataSlicer(aa,ww,t,pos);

% Calculate angles and velocitys
[angleDeltaRad, angleRad, y] = angleVelCalc(pos, 20, initialCaptureRate);

% Plot the results
close all
plotter(angleDeltaRad, angleRad, pos, aa, ww, t, y, initialCaptureRate)
