clear all
close all
clc


videoFileName = '01.mp4';
dataFileName = 'DATA01.csv';
extraPoints = 50;

tic
[vel, pos] = velocityLogger(videoFileName,extraPoints);
toc


tic
[a,w,t] = fileReader(dataFileName,extraPoints);
toc


tic
plotter(vel, pos, a, w, t)
toc
