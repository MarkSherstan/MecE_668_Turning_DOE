clear all
close all
clc

for ii = 1:16
    str{ii} = strcat('run',num2str(ii),'.mat');
    load(str{ii})

%
% if ii == 1
%   fprintf('%0.0f\t\t\t',ii)
% elseif ii == 8
%   fprintf('%0.0f\t\t\t',ii)
% elseif ii == 11
%   fprintf('%0.0f\t\t\t',ii)
% elseif ii == 15
%   fprintf('%0.0f\t\t\t',ii)
% else
%   fprintf('%0.0f  ',ii)
% end
%
% [radiusOut,center,A,B,C,idxBoth,D,E] = circleFilter2000(pospos,scale,false);
% out = plotter(pospos, radiusOut, aa, ww, tt, idxBoth);

  R = circleFilter2000(pospos,scale);

  figure(1)
  x = 1:length(R.radius);

  subplot(4,4,ii)
  hold on
    line([1 length(R.radius)], [R.mean R.mean])
    line([1 length(R.radius)], [R.mean+R.std*R.devs R.mean+R.std*R.devs])
    line([1 length(R.radius)], [R.mean-R.std*R.devs R.mean-R.std*R.devs])

    plot(x,R.radius)
    plot(x(R.idx),R.radius(R.idx),'*r')
  hold off


  figure(2)
  subplot(4,4,ii)
  plot(pospos.x,pospos.y)
  axis equal
  title(strcat('Run: ',num2str(ii)))


% Outout(ii,1) = ii;
% Outout(ii,2) = out;

end

% results = sortrows(Outout,2);

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
