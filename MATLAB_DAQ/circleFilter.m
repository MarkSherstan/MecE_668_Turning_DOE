function [] = circleFilter(pos,scale)
  close all

  % Average 10 points forward and backward
  posx = movmean(pos.x,20);
  posy = movmean(pos.y,20);

  figure(1)
  subplot(1,2,1)
  plot(pos.x,pos.y)
  title('Original Data')
  axis equal
  axis square

  subplot(1,2,2)
  plot(posx,posy)
  title('Smoothed Data')
  axis equal
  axis square

  for i = 1:length(posx)
    mag(i) = sqrt(posx(i)^2 + posy(i)^2);
  end

  localMin = islocalmin(mag,'MinProminence',100);
  localMax = islocalmax(mag,'MinProminence',100);

  minValues = mag(localMin);
  maxValues = mag(localMax);
  x = 1:length(posx);

  figure(2)
  subplot(3,1,1)
  plot(x,mag,'-k',x(localMin),mag(localMin),'r*',x(localMax),mag(localMax),'b*')
  title('Local Max and Min of Magnitude Data')

  subplot(3,1,2)
  plot(minValues,'r*')
  title('Local Min')

  subplot(3,1,3)
  plot(maxValues,'b*')
  title('Local Max')

  percentChangeMin = abs((diff(minValues) ./ minValues(1:end-1)) * 100);
  percentChangeMax = abs((diff(maxValues) ./ maxValues(1:end-1)) * 100);
  changePointMinMax = min([find(percentChangeMin > 2) find(percentChangeMax > 2)]);

  idx = min([find(mag == minValues(changePointMinMax)) find(mag == maxValues(changePointMinMax))]);

  figure(3)
  plot(posx(idx:end),posy(idx:end))
  axis equal
  axis square


% Convert to actual radius here using scale
end
