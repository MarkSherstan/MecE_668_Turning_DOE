clear all
close all
clc

for ii = 1:16
    str{ii} = strcat('run',num2str(ii),'.mat');
    load(str{ii})


if ii == 1
  fprintf('%0.0f\t\t\t',ii)
elseif ii == 8
  fprintf('%0.0f\t\t\t',ii)
elseif ii == 11
  fprintf('%0.0f\t\t\t',ii)
elseif ii == 15
  fprintf('%0.0f\t\t\t',ii)
else
  fprintf('%0.0f  ',ii)
end

[radiusOut,center,A,B,C,idxBoth,D,E] = circleFilter2000(pospos,scale,false);
out = plotter(pospos, radiusOut, aa, ww, tt, idxBoth);


%%%%%%% RADIUS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
idxLow = round(length(radiusOut)*0.05);
idxHigh = round(length(radiusOut)*0.25);
ttt = tt.seconds;

stdstd = std(radiusOut(idxLow:idxHigh));
meanmean = mean(radiusOut(idxLow:idxHigh));
scaleStd = 2;

  figure(1)

  hold on
    subplot(4,4,ii)
    plot(radiusOut)

    line([idxHigh idxHigh], [0 1]);

    line([1 length(radiusOut)], [meanmean meanmean])

    line([1 length(radiusOut)], [meanmean+stdstd*scaleStd meanmean+stdstd*scaleStd])
    line([1 length(radiusOut)], [meanmean-stdstd*scaleStd meanmean-stdstd*scaleStd])
  hold off
  title('Radius')


%%%%%%% Center %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  changeX = diff(center.x);
  changeY = diff(center.y);
  changeXY = [sqrt(changeX.^2 + changeY.^2) 0];

  stdstd = std(changeXY(idxLow:idxHigh));
  meanmean = mean(changeXY(idxLow:idxHigh));
  scaleStd = 2;


  figure(2)

  hold on
    subplot(4,4,ii)
    plot(changeXY(10:end-10))

    line([idxHigh idxHigh], [0 1]);

    line([1 length(changeXY)], [meanmean meanmean])

    line([1 length(changeXY)], [meanmean+stdstd*scaleStd meanmean+stdstd*scaleStd])
    line([1 length(changeXY)], [meanmean-stdstd*scaleStd meanmean-stdstd*scaleStd])
  hold off
  title('Center Point')



  % figure(3)
  % subplot(5,3,ii)
  % plot(pospos.x,pospos.y)
  % axis equal
  % title(strcat('Run: ',num2str(ii)))


Outout(ii,1) = ii;
Outout(ii,2) = out;

end

results = sortrows(Outout,2);

%clear str
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
