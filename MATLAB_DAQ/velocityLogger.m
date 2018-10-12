function [vel, pos] = velocityLogger(filename,extraPoints,scale)

  % Declare variables
  oldPoints = [];
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

      if isempty(points)
        points = oldPoints;
      end

      if ~isempty(oldPoints)
          deltaX = points(1) - oldPoints(1);
          deltaY = points(2) - oldPoints(2);
          deltaTot = sqrt(deltaX^2 + deltaY^2);

          % pixels/frame * frame/seconds * cm/pixel
          vel.mag(i) = deltaTot * frameRate * scale;
          vel.x(i) = deltaX * frameRate * scale;
          vel.y(i) = deltaY * frameRate * scale;

          %fprintf('vel.mag: %0.2f\tVel x: %5.2f\tVel y: %5.2f\n',vel.mag(i),vel.x(i),vel.y(i))
          %frameOut = insertObjectAnnotation(frame, 'circle',[points(1) points(2), 50], cellstr(num2str(vel.mag(i),'%2.2f')));
        else
          vel_pix = 0;
          vel.mag = 0;
          frameOut = frame;
      end

      %figure(10)
      %imshow(frameOut)
      %imshow(BW)

      % Save data for next frame
      pos.x(i) = points(1) * scale;
      pos.y(i) = points(2) * scale;
      oldPoints = points;
      i = i + 1;
      fprintf('%d\n',i)
  end

  sliceLocation = dataSlicer(vel.mag,extraPoints);
  vel.mag(1:sliceLocation) = [];
  vel.x(1:sliceLocation) = [];
  vel.y(1:sliceLocation) = [];
  pos.x(1:sliceLocation) = [];
  pos.y(1:sliceLocation) = [];

end


function [sliceLocation] = dataSlicer(mag,extraPoints)
  counter = 0;

  for i = 1:length(mag)
    if mag(i) > 1.5
      break
    end

    counter = counter + 1;
  end

  sliceLocation = counter - extraPoints;
end
