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
rot_x = M(:,5);
rot_y = M(:,6);
rot_z = M(:,7);

for i = 1:length(loop_timer_micro)-1
  frequency(i) = loop_timer_micro(i+1) - loop_timer_micro(i);
end

frequencyAvg = 1e6 / mean(frequency);

figure(1)
plot(loop_timer_seconds,accel_x,loop_timer_seconds,accel_y,loop_timer_seconds,accel_z)
title('Acceleration as a function of Time')
legend('a_x','a_y','a_z')
xlabel('Time (s)')
ylabel('Acceleration [g]')


figure(2)
plot(loop_timer_seconds,rot_x,loop_timer_seconds,rot_y,loop_timer_seconds,rot_z)
title('Angular Velocity as a function of Time')
legend('w_x','w_y','w_z')
xlabel('Time (s)')
ylabel('Angular Velocity [deg/s]')


figure(3)
title('Acceleration and Angular Velocity as a function of Time')
xlabel('Time (s)')

yyaxis left
a = plot(loop_timer_seconds,accel_x,'-r',loop_timer_seconds,accel_y,'-g',loop_timer_seconds,accel_z,'-b');
ylabel('Acceleration [g]')

yyaxis right
b = plot(loop_timer_seconds,rot_x,'--r',loop_timer_seconds,rot_y,'--g',loop_timer_seconds,rot_z,'--b');
ylabel('Angular Velocity [deg/s]')

Leg = legend([a; b], {'a_x','a_y','a_z','w_x','w_y','w_z'});
