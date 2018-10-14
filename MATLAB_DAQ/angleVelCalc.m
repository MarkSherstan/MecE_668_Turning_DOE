function [angleDeltaRad, angleRad, y] = angleVelCalc(pos, avgPoints, initialCaptureRate)

  % Smooth the x and y data with a middle point average
  posx = movmean(pos.x,avgPoints);
  posy = movmean(pos.y,avgPoints);

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

  % Calculate change in angles
  for i = 1:length(angleRad) - 1
    angleDeltaRad(i) = angleRad(i+1) - angleRad(i);

    % Only true if counter clockwise rotation
    if angleDeltaRad(i) > 0
      angleDeltaRad(i) = angleDeltaRad(i) - 2*pi;
    end
  end

  angleDeltaRad = angleDeltaRad*initialCaptureRate;

  % Fit data with a curve (used curve fitting toolbox)
  x = (1:length(angleDeltaRad))/initialCaptureRate;
  y = createFit(x, angleDeltaRad);

  % Plot data or comment out
  %showData(posx, posy, angleRad, angleDeltaRad, x, y, initialCaptureRate)
end


function [fitresult] = createFit(x, angleDeltaRad)
%  Auto-generated by MATLAB on 14-Oct-2018 16:31:13

%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( x, angleDeltaRad );

% Set up fittype and options.
ft = fittype( 'gauss5' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0];
opts.StartPoint = [-0.813956390153709 4.75972222222222 4.75555555555556 -0.813956390153709 9.51527777777778 4.75555555555556 -0.813956390153709 14.2708333333333 4.75555555555556 -0.813956390153709 19.0263888888889 4.75555555555556 -0.813956390153709 23.7819444444444 4.75555555555556];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

end


function [] = showData(posx, posy, angleRad, angleDeltaRad, x, y, initialCaptureRate)
  % Plot a circle to see how x and y data is fitting
  figure(1)
  plot(posx,posy)
  title('Position Plot')
  xlabel('x position')
  ylabel('y position')
  axis equal

  % Prepare x axis
  count = 1:length(posx);
  t = count/initialCaptureRate;

  % Plot X and Y data
  figure(2)
  subplot(3,1,1)
  plot(t,posx,t,posy)
  title('X and Y Position')
  xlabel('time')
  ylabel('position')
  legend('x','y')

  % Plot the angles
  subplot(3,1,2)
  plot(t,angleRad)
  xlabel('time')
  ylabel('angle (radians)')

  % Plot the change in angle with the fitted curve
  subplot(3,1,3)
  hold on
  plot(x,angleDeltaRad,'o')
  plot(y,'-k')
  xlabel('time')
  ylabel('angular velocity')
  hold off

end
