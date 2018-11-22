function [out] = plotter(pos,posZerod,radius,a,w,t,idxCenter,idxRadius)

r = resample(radius,length(t.seconds),length(radius))';
idxCenter = round(idxCenter*(length(t.seconds)/length(radius)));
idxRadius = round(idxRadius*(length(t.seconds)/length(radius)));



% figure
% plot(pos.x,pos.y)
% title('Position Plot')
% xlabel('x position [pixel]')
% ylabel('y position [pixel]')
% axis equal
%
%
%
% figure
% plot(posZerod.x,posZerod.y)
% title('Position Plot with Circles Centered at Zero')
% xlabel('x position [pixel]')
% ylabel('y position [pixel]')
% axis equal

%
%
% figure
% plot(t.seconds,r)
% title('Circle Radius as a function of Time')
% xlabel('Time [s]')
% ylabel('Radius of Circle [m]')
%
%
%
% figure
% plot(t.seconds,a.x,t.seconds,a.y,t.seconds,a.z)
% title('Acceleration as a function of Time')
% legend('a_x','a_y','a_z')
% xlabel('Time [s]')
% ylabel('Acceleration [g]')
%
%
%
% figure
% plot(t.seconds,w.x,t.seconds,w.y,t.seconds,w.z)
% title('Angular Velocity as a function of Time')
% legend('w_x','w_y','w_z')
% xlabel('Time [s]')
% ylabel('Angular Velocity [deg/s]')
%
%
%
% figure
% title('Acceleration and Angular Velocity as a function of Time')
% xlabel('Time [s]')
%
% yyaxis left
% leftA = plot(t.seconds,a.x,'--r',t.seconds,a.y,'--g',t.seconds,a.z,'--b');
% ylabel('Acceleration [g]')
%
% yyaxis right
% rightW = plot(t.seconds,w.x,'-r',t.seconds,w.y,'-g',t.seconds,w.z,'-b');
% ylabel('Angular Velocity [deg/s]')
%
% Leg = legend([leftA; rightW], {'a_x','a_y','a_z','w_x','w_y','w_z'});
%

%
% figure
instantV = r.*w.z*0.0174533;
% hold on
% plot(t.seconds,instantV,'-k')
% plot(t.seconds(idxCenter),instantV(idxCenter),'or','MarkerSize',15,'LineWidth',4)
% plot(t.seconds(idxRadius),instantV(idxRadius),'ob','MarkerSize',15,'LineWidth',4)
% title('Instantaneous velocity as a function of Time')
% xlabel('Time [s]')
% ylabel('Instantaneous Velocity [m/s]')
% legend('Instantaneous V','Center Slip','Radius Slip','Location','SouthEast')
% hold off

out = min([instantV(idxCenter) instantV(idxRadius)]);
fprintf('Slip at %0.3f [m/s]\n',out)

end
