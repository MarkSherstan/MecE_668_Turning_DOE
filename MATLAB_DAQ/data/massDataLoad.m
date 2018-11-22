clear all
close all
clc
% 
for ii = 1:16
    str{ii} = strcat('run',num2str(ii),'.mat');
    load(str{ii})

%     hold on
%     figure(1)
%     hold on
%     r = resample(radius.meters,length(tt.seconds),length(radius.meters));
%     plot(tt.seconds,r)
%     title('Circle Radius as a function of Time')
%     xlabel('Time [s]')
%     ylabel('Radius of Circle [m]')
%     legend(str')
%     hold off
% 
%     figure(2)
%     hold on
%     plot(tt.seconds,ww.z)
%     title('Angular velocity as a function of Time')
%     xlabel('Time [s]')
%     ylabel('Angular velocity [deg/s]')
%     legend(str')
%     hold off
% 
%     figure(3)
%     hold on
%     plot(posZerod.x,posZerod.y)
%     title('Position Plot with Circles Centered at Zero')
%     xlabel('x position [pixel]')
%     ylabel('y position [pixel]')
%     axis equal
%     legend(str')
%     hold off
% 
%     figure(4)
%     hold on
%     instantV = r.*ww.z*0.0174533;
%     plot(tt.seconds,instantV)
%     title('Instantaneous velocity as a function of Time')
%     xlabel('Time [s]')
%     ylabel('Instantaneous Velocity [m/s]')
%     legend(str')
%     hold off

[idxCenter,idxRadius,radiusOut, center] = circleFilter2000(pospos,scale,false);
out = plotter(pospos, posZerod, radiusOut, aa, ww, tt,idxCenter,idxRadius);

  radiusOut = movmean(radiusOut,50);
  
  figure(1)
  hold on
  subplot(4,4,ii)
  plot(radiusOut)
  %plot(radiusOut,'o')
  hold off

  figure(2)
  hold on 
  subplot(4,4,ii)
  plot(norm([center.x center.y]))
  hold off

A(ii,1) = ii;
A(ii,2) = out;

end

clear str
% 
% for ii = 1:3
%     str{ii} = strcat('midPoint',num2str(ii),'.mat');
%     load(str{ii})
% 
% %     hold on
% %     figure(5)
% %     hold on
% %     r = resample(radius.meters,length(tt.seconds),length(radius.meters));
% %     plot(tt.seconds,r)
% %     title('Circle Radius as a function of Time - Center Point')
% %     xlabel('Time [s]')
% %     ylabel('Radius of Circle [m]')
% %     legend(str')
% %     hold off
% % 
% %     figure(6)
% %     hold on
% %     plot(tt.seconds,ww.z)
% %     title('Angular velocity as a function of Time - Center Point')
% %     xlabel('Time [s]')
% %     ylabel('Angular velocity [deg/s]')
% %     legend(str')
% %     hold off
% % 
% %     figure(7)
% %     hold on
% %     plot(posZerod.x,posZerod.y)
% %     title('Position Plot with Circles Centered at Zero - Center Point')
% %     xlabel('x position [pixel]')
% %     ylabel('y position [pixel]')
% %     axis equal
% %     legend(str')
% %     hold off
% % 
% %     figure(8)
% %     hold on
% %     instantV = r.*ww.z*0.0174533;
% %     plot(tt.seconds,instantV)
% %     title('Instantaneous velocity as a function of Time - Center Point')
% %     xlabel('Time [s]')
% %     ylabel('Instantaneous Velocity [m/s]')
% %     legend(str')
% %     hold off
% 
% [idxCenter,idxRadius,radiusOut] = circleFilter2000(pospos,scale,true);
% out = plotter(pospos, posZerod, radiusOut, aa, ww, tt,idxCenter,idxRadius);
% 
% B(ii,1) = ii;
% B(ii,2) = out;
% end
