function [] = plotter(angleDeltaRad, angleRad, pos, a, w, t, y, initialCaptureRate)

figure(1)
tt = (1:length(angleDeltaRad))/initialCaptureRate;
hold on
plot(tt,angleDeltaRad,'o')
plot(y,'-k')
title('Angular Velocity vs Time')
xlabel('Time (s)')
ylabel('Angular Velocity [rad/s]')
hold off

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
ttt = linspace(1,length(tt),length(a.x))/initialCaptureRate;

yyaxis left
leftA = plot(ttt,a.x,'-r',ttt,a.y,'-g',ttt,a.z,'-b');
ylabel('Acceleration [g]')

yyaxis right
rightW = plot(y,'-k');
ylabel('Angular Velocity')

Leg = legend([leftA; rightW], {'a_x','a_y','a_z','w'});
xlabel('Time (s)')


figure(7)

yyaxis left
leftA = plot(ttt,w.x,'-r',ttt,w.y,'-g',ttt,w.z,'-b');
ylabel('Angular Velocity Sensor [deg/s]')

yyaxis right
rightW = plot(y,'-k');
ylabel('Angular Velocity Vehicle')

title('Angular Velocity Vehicle and Sensor')
Leg = legend([leftA; rightW], {'w_x','w_y','w_z','w'});
xlabel('Time (s)')
