function [angleRad, angleDeltaRad, pos] = velocityLogger(filename,extraPoints,scale)

  % Read in video and process and initialize counter
  v = VideoReader(filename);
  frameRate = v.FrameRate;
  i = 1;

  % Loop through video frame by frame
  while hasFrame(v)
      frame = readFrame(v);
      BW = createMask(frame);

      % Find centroid x y coords
      stats = regionprops('table',BW,'Centroid');
      points = table2array(stats);

      % Save centroid position data
      pos.x(i) = points(1);
      pos.y(i) = points(2);

      % Counter and print
      i = i + 1;
      fprintf('%d\n',i)
  end

  % Calculate angular and instantaneous velocity
  [angleRad, angleDeltaRad] = variousVCalc(pos,frameRate,scale);

  % Get rid of usless data
  % sliceLocation = dataSlicer(angularV,extraPoints);
  % angularV(1:sliceLocation) = [];
  % instantV(1:sliceLocation) = [];
  % pos.x(1:sliceLocation) = [];
  % pos.y(1:sliceLocation) = [];

end


function [angleRad, angleDeltaRad] = variousVCalc(pos,frameRate,scale)
  % Center data at 0
  centerX = mean(pos.x);
  centerY = mean(pos.y);
  positionX = pos.x - centerX;
  positionY = pos.y - centerY;

  % Convert to [0 2*pi]
  for i = 1:length(positionX)
    angleRad(i) = atan2(positionY(i),positionX(i));

    if (angleRad(i) <= 0) && (angleRad(i) >= -pi)
      angleRad(i) = angleRad(i) + 2*pi;
    end
  end

  % Calculate change in angle
  for i = 1:length(angleRad) - 1
    angleDeltaRad(i) = angleRad(i+1) - angleRad(i);

    % if clockwise
    % if angleDeltaRad(i) < 0
    %   angleDeltaRad(i) = angleDeltaRad(i) + 2*pi;
    % end

    % if counter clockwise
    if angleDeltaRad(i) > 0
      angleDeltaRad(i) = angleDeltaRad(i) - 2*pi;
    end

  end

end


function [sliceLocation] = dataSlicer(angularV,extraPoints)
  counter = 0;

  for i = 1:length(angularV)
    if angularV(i) > 0.01
      break
    end

    counter = counter + 1;
  end

  sliceLocation = counter - extraPoints;
end
