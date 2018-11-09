function [] = plotter(pos,posZerod,radius,a,w,t)

figure
plot(pos.x,pos.y)
title('Position Plot')
xlabel('x position [pixel]')
ylabel('y position [pixel]')
axis equal



figure
plot(posZerod.x,posZerod.y)
title('Position Plot with Circles Centered at Zero')
xlabel('x position [pixel]')
ylabel('y position [pixel]')
axis equal



figure
r = resample(radius.meters,length(t.seconds),length(radius.meters));
plot(t.seconds,r)
title('Circle Radius as a function of Frame Number')
xlabel('Time [s]')
ylabel('Radius of Circle [m]')



figure
plot(t.seconds,a.x,t.seconds,a.y,t.seconds,a.z)
title('Acceleration as a function of Time')
legend('a_x','a_y','a_z')
xlabel('Time [s]')
ylabel('Acceleration [g]')



figure
plot(t.seconds,w.x,t.seconds,w.y,t.seconds,w.z)
title('Angular Velocity as a function of Time')
legend('w_x','w_y','w_z')
xlabel('Time [s]')
ylabel('Angular Velocity [deg/s]')



figure
title('Acceleration and Angular Velocity as a function of Time')
xlabel('Time [s]')

yyaxis left
leftA = plot(t.seconds,a.x,'--r',t.seconds,a.y,'--g',t.seconds,a.z,'--b');
ylabel('Acceleration [g]')

yyaxis right
rightW = plot(t.seconds,w.x,'-r',t.seconds,w.y,'-g',t.seconds,w.z,'-b');
ylabel('Angular Velocity [deg/s]')

Leg = legend([leftA; rightW], {'a_x','a_y','a_z','w_x','w_y','w_z'});



figure
instantV = r.*w.z;
plot(t.seconds,instantV)
title('Instantaneous velocity as a function of Time')
xlabel('Time [s]')
ylabel('Instantaneous Velocity [m/s]')
