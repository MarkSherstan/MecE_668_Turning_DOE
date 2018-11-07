function [dataX dataY] = circleFilter(pos,scale)
  close all

  % Average 10 points forward and backward
  posx = movmean(pos.x,20);
  posy = movmean(pos.y,20);

  % Plot the original and filtered data
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

  % Find the angle between two subsequent points and convert to range [0 2*pi]
  for i = 1:length(posx)-1
    angleRad(i) = atan2(posy(i+1)-posy(i),posx(i+1)-posx(i));

    % Fix the data based off the atan2 conditions of being bounded between pi's
    if (angleRad(i) <= 0) && (angleRad(i) >= -pi)
      angleRad(i) = angleRad(i) + 2*pi;
    end

  end

  % Find the min angle values and use them as a reference starting point
  localMin = islocalmin(angleRad,'MinProminence',pi/4);
  x = 1:length(angleRad);
  idx = find(localMin);

  % Plot the results
  figure(2)
  plot(x,angleRad,'-k',x(localMin),angleRad(localMin),'r*')
  title('Local Min of Angle')
  xlabel('Iteration')
  ylabel('Angle [rads]')

  % Find the center points for each circle
  for i = 1:length(idx)-1;
    posxRange = posx(idx(i):idx(i+1));
    posyRange = posy(idx(i):idx(i+1));

    centerX(i) = mean(posxRange);
    centerY(i) = mean(posyRange);
  end

  % Create two column vectors for each circle centered about its zero point
  k = 1;
  dataX = zeros(length(posx),1);
  dataY = zeros(length(posy),1);

  for i = 1:length(idx)-1;
    startPoint = idx(i);
    for j = 0:length(posx(idx(i):idx(i+1)))
      dataX(k,1) = posx(startPoint+j) - centerX(i);
      dataY(k,1) = posy(startPoint+j) - centerY(i);
      k = k + 1;
    end

  end

  % Plot circles with center points at zero and zero
  figure(3)
  plot(dataX,dataY)
  title('Circles centered at Zero')
  axis equal
  axis square

  % Find the radius for each point based on the center and plot
  test = sqrt(dataX.^2 + dataY.^2);
  figure(4)
  plot(test)

end
