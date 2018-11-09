function [posZeroX,posZeroY,radius] = circleFilter(pos,scale,flag)

  % Average 10 points forward and backward
  posx = movmean(pos.x,20);
  posy = movmean(pos.y,20);

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

  % Find the center points for each circle
  for i = 1:length(idx)-1;
    posxRange = posx(idx(i):idx(i+1));
    posyRange = posy(idx(i):idx(i+1));

    centerX(i) = mean(posxRange);
    centerY(i) = mean(posyRange);
  end

  % Create two column vectors for each circle centered about its zero point
  k = 1;
  posZeroX = zeros(length(posx),1);
  posZeroY = zeros(length(posy),1);

  for i = 1:length(idx)-1;
    startPoint = idx(i);
    for j = 0:length(posx(idx(i):idx(i+1)))
      posZeroX(k,1) = posx(startPoint+j) - centerX(i);
      posZeroY(k,1) = posy(startPoint+j) - centerY(i);
      k = k + 1;
    end
  end

  % Find the radius in pixels and convert to actual measurment, output of function
  r = sqrt(posZeroX.^2 + posZeroY.^2);
  radius.pixel = r;
  radius.meters = r * scale;

  % Display all figures based on flag input
  if flag == true

    % Plot the original and averaged circles
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

    % Plot the local minimums (start of a circle)
    figure(2)
    plot(x,angleRad,'-k',x(localMin),angleRad(localMin),'r*')
    title('Local Min of Angle')
    xlabel('Iteration')
    ylabel('Angle [rads]')

    % Plot circles with center points at zero and zero
    figure(3)
    plot(posZeroX,posZeroY)
    title('Circles centered at Zero')
    axis equal
    axis square

    % Plot the radius as a function of frame
    figure(4)
    plot(radius.meters)
    title('Circle Radius as a function of Frame Number')
    xlabel('Frame number')
    ylabel('Radius of Circle [cm]')

  end

end
