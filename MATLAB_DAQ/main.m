clear all
close all
clc

% Constant values / variables
videoFileName = 'Vehicle_Test_1.mp4';
dataFileName = 'Vehicle_Test_1.csv';
extraPoints = 0;
initialCaptureRate = 240;

% Get scale
[scale, red, blue, green] = scale(videoFileName,false);

% Calculate positions
pos = positionLogger(videoFileName);

% Read in sensor data and clean where required
[a,w,t,PWM] = fileReader(dataFileName);
a.y = cleanUpFreq(a.y,mean(t.frequency),4);

% Match up data
[a,w,t,pos] = dataSlicer(a,w,t,pos);

% Calculate angles and velocitys
[angleDeltaRad, angleRad, y] = angleVelCalc(pos, 20, initialCaptureRate);

% Plot the results
close all
plotter(angleDeltaRad, angleRad, pos, a, w, t, y, initialCaptureRate)
