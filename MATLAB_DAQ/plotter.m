function [] = plotter(vel, pos, a, w, t)

figure(1)
tt = 1:length(vel.mag);
plot(tt,vel.mag,tt,vel.x,tt,vel.y)
title('Velocity vs Frame Number')
legend('Velocity','Vel_x','Vel_y')
xlabel('Frame')
ylabel('Velocity [cm/s]')


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
a = plot(t.seconds,a.x,'-r',t.seconds,a.y,'-g',t.seconds,a.z,'-b');
ylabel('Acceleration [g]')

yyaxis right
b = plot(t.seconds,w.x,'--r',t.seconds,w.y,'--g',t.seconds,w.z,'--b');
ylabel('Angular Velocity [deg/s]')

Leg = legend([a; b], {'a_x','a_y','a_z','w_x','w_y','w_z'});
