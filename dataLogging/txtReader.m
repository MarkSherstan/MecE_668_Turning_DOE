clear all
close all
clc

filename = 'DATA00.CSV';
M = csvread(filename);

loop_timer_micro = M(:,1);
loop_timer_seconds = loop_timer_micro * 1e-6;
accel_x = M(:,2);
accel_y = M(:,3);
accel_z = M(:,4);

for i = 1:length(loop_timer_micro)-1
  frequency(i) = loop_timer_micro(i+1) - loop_timer_micro(i);
end

frequencyAvg = 1e6 / mean(frequency);

plot(loop_timer_seconds,accel_x,loop_timer_seconds,accel_y,loop_timer_seconds,accel_z)
title('Acceleration as a function of Time')
legend('accel_x','accel_y','accel_z')
xlabel('Time (s)')
ylabel('Acceleration [g]')
