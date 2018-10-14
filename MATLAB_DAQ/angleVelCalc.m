function [angleDeltaRad, angleRad, p] = angleVelCalc(pos, lowerRange, upperRange, avgPoints)

  % Smooth the x and y data with a middle point average
  posx = pos.x(1:end);
  posy = pos.y(1:end);
  posx = movmean(posx(lowerRange:upperRange),avgPoints);
  posy = movmean(posy(lowerRange:upperRange),avgPoints);

  % Plot a circle to see how x and y data is fitting
  figure(1)
  plot(posx,posy)
  title('Position Plot')
  xlabel('x position')
  ylabel('y position')
  axis equal

  % Plot X and Y data
  figure(2)
  subplot(3,1,1)
  count = 1:length(posx);
  plot(count,posx,count,posy)
  title('X and Y Position')
  xlabel('time')
  ylabel('position')
  legend('x','y')

  % Calculate angles from x and y positions starting with centering data about 0
  centerX = mean(posx);
  centerY = mean(posy);
  positionX = posx - centerX;
  positionY = posy - centerY;

  % Convert to [0 2*pi]
  for i = 1:length(positionX)
    angleRad(i) = atan2(positionY(i),positionX(i));

    % Fix the data based off the atan2 conditions of being bounded between pi's
    if (angleRad(i) <= 0) && (angleRad(i) >= -pi)
      angleRad(i) = angleRad(i) + 2*pi;
    end
  end

  % Plot the angles
  subplot(3,1,2)
  plot(angleRad)
  xlabel('time')
  ylabel('angle (radians)')

  % Calculate change in angles
  for i = 1:length(angleRad) - 1
    angleDeltaRad(i) = angleRad(i+1) - angleRad(i);

    % Only true if counter clockwise rotation
    if angleDeltaRad(i) > 0
      angleDeltaRad(i) = angleDeltaRad(i) - 2*pi;
    end
  end

  % Fit data with a curve
  x = 1:length(angleDeltaRad);
  p = polyfit(x,angleDeltaRad,3);
  y = polyval(p,x);

  % Plot the change in angle with the fitted curve
  subplot(3,1,3)
  plot(x,angleDeltaRad,'o',x,y,'-k')
  xlabel('time')
  xlabel('time')
  ylabel('angular velocity')
