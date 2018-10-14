function [dataOut] = cleanUpFreq(acc,freq,cutOffFreq)

% Set up starting variables
Fs = freq;
T = 1/Fs;
L = length(acc);
t = (0:L-1)*T;

% Plot original data in time domain
figure(1)
plot(freq*t,acc)

% Perfom FFT
Y = fft(acc);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

% Plot frequency domain
figure(2)
plot(f,P1)
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

% Design a 6th order butterworth filter based off the frequnecy domain plot
fc = cutOffFreq; %                                <----              Change this value
fs = freq;
[b,a] = butter(6,fc/(fs/2));

dataOut = filter(b,a,acc);

% Plot the filtered data back in the time domain
figure(3)
plot(dataOut)
