function [out] = plotter(pospos,aa,ww,tt,R)

r = resample(R.meters,length(tt.seconds),length(R.meters))';
slipIdx = round(min(find(R.idx))*(length(tt.seconds)/length(R.meters)));
instantV = r .* ww.z * 0.0174533;
out = instantV(slipIdx);




figure
plot(pospos.x,pospos.y)
title('Position Plot','FontSize',16)
xlabel('x position [pixel]','FontSize',16)
ylabel('y position [pixel]','FontSize',16)
axis equal




figure
plot(tt.seconds,r)
title('Circle Radius as a function of Time','FontSize',16)
xlabel('Time [s]','FontSize',16)
ylabel('Radius of Circle [m]','FontSize',16)




figure
title('Acceleration and Angular Velocity as a function of Time','FontSize',16)
xlabel('Time [s]','FontSize',16)

yyaxis left
leftA = plot(tt.seconds,aa.x,'--r',tt.seconds,aa.y,'--g',tt.seconds,aa.z,'--b');
ylabel('Acceleration [g]','FontSize',16)

yyaxis right
rightW = plot(tt.seconds,ww.x,'-r',tt.seconds,ww.y,'-g',tt.seconds,ww.z,'-b');
ylabel('Angular Velocity [deg/s]','FontSize',16)

Leg = legend([leftA; rightW], {'a_x','a_y','a_z','w_x','w_y','w_z'});




figure
hold on
  plot(tt.seconds,instantV,'-k')
  plot(tt.seconds(slipIdx),instantV(slipIdx),'or','MarkerSize',15,'LineWidth',4)

  title('Instantaneous velocity as a function of Time','FontSize',16)
  xlabel('Time [s]','FontSize',16)
  ylabel('Instantaneous Velocity [m/s]','FontSize',16)

  legend('Instantaneous V','Slip Point','Location','SouthEast','FontSize',16)
hold off




% figure
% plot(tt.seconds,aa.x,tt.seconds,aa.y)
% title('Acceleration as a function of Time','FontSize',16)
% legend('a_x','a_y','FontSize',16)
% xlabel('Time [s]','FontSize',16)
% ylabel('Acceleration [g]','FontSize',16)
%
%
%
%
% figure
% plot(tt.seconds,ww.x,tt.seconds,ww.y,tt.seconds,ww.z)
% title('Angular Velocity as a function of Time','FontSize',16)
% legend('w_x','w_y','w_z','FontSize',16)
% xlabel('Time [s]','FontSize',16)
% ylabel('Angular Velocity [deg/s]','FontSize',16)
