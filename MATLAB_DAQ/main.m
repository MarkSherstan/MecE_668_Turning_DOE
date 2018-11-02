clear all
close all
clc

% Constant values / variables
videoFileName = 'DATA00.mp4';
dataFileName = 'DATA00.csv';
extraPoints = 0;
initialCaptureRate = 240;

% Get scale
[scale, red, blue, green] = scale(videoFileName,false);

% Calculate positions
pos = positionLogger(videoFileName);

% Read in sensor data
[a,w,t,PWM] = fileReader(dataFileName);

% Clean up the data
a.xx = cleanUpFreq(a.x,mean(t.frequency),0.5);
a.yy = cleanUpFreq(a.y,mean(t.frequency),0.5);
a.zz = cleanUpFreq(a.z,mean(t.frequency),0.5);
w.xx = movmean(w.x,25);
w.yy = movmean(w.y,25);
w.zz = movmean(w.z,25);

% Match up data
[a,w,t,pos] = dataSlicer(a,w,t,pos);

% Calculate angles and velocitys
[angleDeltaRad, angleRad, y] = angleVelCalc(pos, 20, initialCaptureRate);

% Plot the results
close all
plotter(angleDeltaRad, angleRad, pos, a, w, t, y, initialCaptureRate)
