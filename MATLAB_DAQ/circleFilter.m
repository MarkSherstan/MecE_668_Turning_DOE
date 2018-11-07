function [test] = circleFilter(pos,scale)
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
  plot(posx(idx:end),posy(idx:end),'k*')
  axis equal
  axis square

  % Convert to [0 2*pi]
  for i = 1:length(posx)-1
    angleRad(i) = atan2(posy(i+1)-posy(i),posx(i+1)-posx(i));

    % Fix the data based off the atan2 conditions of being bounded between pi's
    if (angleRad(i) <= 0) && (angleRad(i) >= -pi)
      angleRad(i) = angleRad(i) + 2*pi;
    end

    radius(i) = abs((posy(i+1) - posy(i)) / sin(angleRad(i)));
  end

  localMin = islocalmin(angleRad,'MinProminence',pi/4);

  x = 1:length(angleRad);

  figure(5)
  plot(x,angleRad,'-k',x(localMin),angleRad(localMin),'r*')
  title('Local Min of Angle')
  xlabel('Iteration')
  ylabel('Angle [rads]')

  idx = find(localMin);

  for i = 1:length(idx)-1;
    posxRange = posx(idx(i):idx(i+1));
    posyRange = posy(idx(i):idx(i+1));

    centerX(i) = mean(posxRange);
    centerY(i) = mean(posyRange);

    largeX = mean(maxk(posxRange,5));
    smallX = mean(mink(posxRange,5));

    largeY = mean(maxk(posyRange,5));
    smallY = mean(mink(posyRange,5));

    radius2(i) = ((largeX - smallX) + (largeY - smallY)) / 4;
  end

  dataX = zeros(max(diff(idx)),length(idx));
  dataY = zeros(max(diff(idx)),length(idx));

  k = 0;

  % Create matrix of each circle in a column centered about its zero point
  for i = 1:length(idx)-1;
    startPoint = idx(i);
    for j = 1:length(posx(idx(i):idx(i+1)))-1
      dataX(j,i) = posx(startPoint+k) - centerX(i);
      dataY(j,i) = posy(startPoint+k) - centerY(i);
      k = k+1;
    end
    k = 0;
  end

figure(7)
plot(dataX,dataY)
axis equal
axis square

radius3 = zeros(length(posx),1);

test = dataX.^2 + dataY.^2;
test = reshape(test,[],1);
%test(test==0) = [];
figure(8)
plot(test)
