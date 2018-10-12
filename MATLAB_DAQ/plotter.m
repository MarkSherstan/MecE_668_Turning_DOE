function [] = plotter(angularV, instantV, pos, a, w, t, angularVResample)

figure(1)
tt = 1:length(angularV);
plot(tt,angularV) %tt,instantV
title('Angular Velocity vs Frame Number') % and Instantaneous
%legend('Vel_x','Vel_y')
xlabel('Frame')
ylabel('Angular Velocity [rad/s]')


figure(2)
plot(pos.x,pos.y)
title('Position Plot')
xlabel('x position [cm]')
ylabel('y position [cm]')
axis equal


figure(3)
plot(t.seconds,a.x,t.seconds,a.y,t.seconds,a.z)
title('Acceleration as a function of Time')
legend('a_x','a_y','a_z')
xlabel('Time (s)')
ylabel('Acceleration [g]')


figure(4)
plot(t.seconds,w.x,t.seconds,w.y,t.seconds,w.z)
title('Angular Velocity as a function of Time')
legend('w_x','w_y','w_z')
xlabel('Time (s)')
ylabel('Angular Velocity [deg/s]')


figure(5)
title('Acceleration and Angular Velocity as a function of Time')
xlabel('Time (s)')

yyaxis left
leftA = plot(t.seconds,a.x,'-r',t.seconds,a.y,'-g',t.seconds,a.z,'-b');
ylabel('Acceleration [g]')

yyaxis right
rightW = plot(t.seconds,w.x,'--r',t.seconds,w.y,'--g',t.seconds,w.z,'--b');
ylabel('Angular Velocity [deg/s]')

Leg = legend([leftA; rightW], {'a_x','a_y','a_z','w_x','w_y','w_z'});



figure(6)
xaxis = 1:length(a.x);

yyaxis left
a = plot(xaxis,a.x,'-r',xaxis,a.y,'-g',xaxis,a.z,'-b');
ylabel('Acceleration [g]')

yyaxis right
b = plot(xaxis,angularVResample,'--k');
ylabel('Angular Velocity')
