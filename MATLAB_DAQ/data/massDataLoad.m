clear all
%close all
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
if ii == 1
  fprintf('%0.0f\t\t\t\t\t\t\t',ii)
elseif ii == 8
  fprintf('%0.0f\t\t\t\t\t\t\t',ii)
elseif ii == 11
  fprintf('%0.0f\t\t\t\t\t\t\t',ii)
elseif ii == 15
  fprintf('%0.0f\t\t\t\t\t\t\t',ii)
else
  fprintf('%0.0f  ',ii)
end
[idxCenter,idxRadius,radiusOut,center,perCentChangeSum,percentChangeR,A,B,C,idxBoth] = circleFilter2000(pospos,scale,false);
out = plotter(pospos, posZerod, radiusOut, aa, ww, tt,idxCenter,idxRadius,idxBoth);

%   radiusOut = movmean(radiusOut,1);
%
%   figure(1)
%
%   hold on
%   subplot(4,4,ii)
%   plot(radiusOut)
%   %plot(radiusOut,'o')
%   hold off
%   title('Radius')
%   figure(1)
%
%   subplot(4,4,ii)
%   hold on
%   plot(cumsum(perCentChangeSum,'omitnan'),'-k')
%   plot(cumsum(percentChangeR,'omitnan'),'-r')
%   ylim([0 2])
%   hold off
%   title(num2str(ii))
%
%
  % figure(2)
  %
  % subplot(4,4,ii)
  % hold on
  % plot(perCentChangeSum,'-k')
  % plot(percentChangeR,'-r')
  % ylim([0 0.2])
  % hold off
  % title(num2str(ii))

figure(4)

subplot(4,4,ii)
hold on
plot(2*A,'-r')
plot(B,'-b')
plot(C,'-k')
ylim([0 6])
hold off
title(num2str(ii))

  figure(3)
  subplot(4,4,ii)
  plot(pospos.x,pospos.y)
  axis equal
  title(num2str(ii))


Aa(ii,1) = ii;
Aa(ii,2) = out;

end

results = sortrows(Aa,2)
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
