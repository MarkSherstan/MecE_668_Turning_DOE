function [angularV, instantV, pos] = velocityLogger(filename,extraPoints,scale)

  % Declare variables
  i = 1;

  % Read in video and process
  v = VideoReader(filename);
  frameRate = v.FrameRate;

  % Loop through video frame by frame
  while hasFrame(v)
      frame = readFrame(v);
      BW = createMask(frame);

      stats = regionprops('table',BW,'Centroid');
      points = table2array(stats);

      % Save centroid position data
      pos.x(i) = points(1);
      pos.y(i) = points(2);

      % Display video if required
      %figure(10)
      %imshow(frame)
      %imshow(BW)

      % Counter
      i = i + 1;
      fprintf('%d\n',i)
  end

  % Calculate angular and instantaneous velocity
  [angularV, instantV] = variousVCalc(pos,frameRate,scale);

  % Get rid of usless data
  sliceLocation = dataSlicer(angularV,extraPoints);
  angularV(1:sliceLocation) = [];
  instantV(1:sliceLocation) = [];
  pos.x(1:sliceLocation) = [];
  pos.y(1:sliceLocation) = [];

end


function [angularV, instantV] = variousVCalc(pos,frameRate,scale)
  % Center data at 0
  centerX = mean(pos.x);
  centerY = mean(pos.y);
  positionX = pos.x - centerX;
  positionY = pos.y - centerY;

  for i = 1:length(positionX)-1
    % angle/frame * frame/seconds * cm/pixel --> Is this correct???
    angularV(i) = (tan(positionY(i+1)/positionX(i+1)) - tan(positionY(i)/positionX(i)))/frameRate;

    % pixels/frame * frame/seconds * cm/pixel --> Is this correct???
    instantV(i) = angularV(i) * sqrt(positionX(i)^2 + positionY(i)^2);
  end

end


function [sliceLocation] = dataSlicer(angularV,extraPoints)
  counter = 0;

  for i = 1:length(angularV)
    if angularV(i) > 1.5
      break
    end

    counter = counter + 1;
  end

  sliceLocation = counter - extraPoints;
end
