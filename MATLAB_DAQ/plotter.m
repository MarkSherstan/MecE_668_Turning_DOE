function [out] = plotter(pospos,aa,ww,tt,R)

r = resample(R.meters,length(tt.seconds),length(R.meters))';
slipIdx = round(min(find(R.idx))*(length(tt.seconds)/length(R.meters)));
instantV = r .* ww.z * 0.0174533;
out = instantV(slipIdx);




figure
plot(pospos.x,pospos.y)
title('Position Plot')
xlabel('x position [pixel]')
ylabel('y position [pixel]')
axis equal




figure
plot(tt.seconds,r)
title('Circle Radius as a function of Time')
xlabel('Time [s]')
ylabel('Radius of Circle [m]')




figure
title('Acceleration and Angular Velocity as a function of Time')
xlabel('Time [s]')

yyaxis left
leftA = plot(tt.seconds,aa.x,'--r',tt.seconds,aa.y,'--g',tt.seconds,aa.z,'--b');
ylabel('Acceleration [g]')

yyaxis right
rightW = plot(tt.seconds,ww.x,'-r',tt.seconds,ww.y,'-g',tt.seconds,ww.z,'-b');
ylabel('Angular Velocity [deg/s]')

Leg = legend([leftA; rightW], {'a_x','a_y','a_z','w_x','w_y','w_z'});




figure
hold on
  plot(tt.seconds,instantV,'-k')
  plot(tt.seconds(slipIdx),instantV(slipIdx),'or','MarkerSize',15,'LineWidth',4)

  title('Instantaneous velocity as a function of Time')
  xlabel('Time [s]')
  ylabel('Instantaneous Velocity [m/s]')

  legend('Instantaneous V','Slip Point','Location','SouthEast')
hold off




% figure
% plot(tt.seconds,aa.x,tt.seconds,aa.y,tt.seconds,aa.z)
% title('Acceleration as a function of Time')
% legend('a_x','a_y','a_z')
% xlabel('Time [s]')
% ylabel('Acceleration [g]')




% figure
% plot(tt.seconds,ww.x,tt.seconds,ww.y,tt.seconds,ww.z)
% title('Angular Velocity as a function of Time')
% legend('w_x','w_y','w_z')
% xlabel('Time [s]')
% ylabel('Angular Velocity [deg/s]')
