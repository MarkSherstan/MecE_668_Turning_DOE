function [] = cleanUpFreq(acc,freq)
% fileName = 'DATA01.CSV';
% [a,w,t] = fileReader(fileName,-50);
% acc = a.y(1:800);
% freq = mean(t.frequency);
% cleanUp(acc,freq)

Fs = freq;            % Sampling frequency
T = 1/Fs;             % Sampling period
L = length(acc);      % Length of signal
t = (0:L-1)*T;        % Time vector
figure(1)
plot(freq*t,acc)

Y = fft(acc);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
figure(2)
plot(f,P1)
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')


%%%

fc = 0.5; % Change this value
fs = freq;

[b,a] = butter(6,fc/(fs/2));

dataOut = filter(b,a,acc);
figure(4)
plot(dataOut)


return
