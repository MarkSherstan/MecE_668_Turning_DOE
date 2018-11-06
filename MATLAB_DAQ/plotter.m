function [] = plotter(pos, a, w, t, y)

figure(1)
plot(pos.x,pos.y)
title('Position Plot')
xlabel('x position [cm]')
ylabel('y position [cm]')
axis equal



figure(2)
% This is where some plot will go with the center points



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
leftA = plot(t.seconds,a.x,'--r',t.seconds,a.y,'--g',t.seconds,a.z,'--b');
ylabel('Acceleration [g]')

yyaxis right
rightW = plot(t.seconds,w.x,'-r',t.seconds,w.y,'-g',t.seconds,w.z,'-b');
ylabel('Angular Velocity [deg/s]')

Leg = legend([leftA; rightW], {'a_x','a_y','a_z','w_x','w_y','w_z'});



figure(6)
yyaxis left
leftA = plot(t.seconds,a.x,'-r',t.seconds,a.y,'-g',t.seconds,a.z,'-b');
ylabel('Acceleration [g]')

yyaxis right
rightW = plot(y,'-k');
ylabel('Angular Velocity')

Leg = legend([leftA; rightW], {'a_x','a_y','a_z','w'});
xlabel('Time (s)')



figure(7)
hold on
  plot(t.seconds,w.x,'-r',t.seconds,w.y,'-g',t.seconds,w.z,'-b');
  plot(y,'-k')
hold off

xlabel('Time (s)')
ylabel('Angular Velocity Sensor [deg/s]')
legend('w_x','w_y','w_z')
