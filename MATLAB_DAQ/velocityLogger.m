function [vel, pos] = velocityLogger(filename,flag,extraPoints)

  % Declare variables
  oldPoints = [];
  i = 1;

  % Read in video and process
  v = VideoReader(filename);  % '00.265.mp4'
  frameRate = v.FrameRate;

  % Filter out initial capture and get scale from advanced frame
  % for i = 1:15
  %   frame = readFrame(v);
  % end
  % scale = scale(frame,false);
  % 30 fps --> 0.029464206496742
  % 240 fps --> 0.048056789348528
  scale = 0.048056789348528;

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

      %figure(3)
      %imshow(frameOut)
      %imshow(BW)

      % Save data for next frame
      pos.x(i) = points(1) * scale;
      pos.y(i) = points(2) * scale;
      oldPoints = points;
      i = i + 1;
      disp(i)   % Show just i to speed up processing time
  end

  sliceLocation = dataSlicer(vel.mag,extraPoints); % 50 Extra points
  vel.mag(1:sliceLocation) = [];
  vel.x(1:sliceLocation) = [];
  vel.y(1:sliceLocation) = [];
  pos.x(1:sliceLocation) = [];
  pos.y(1:sliceLocation) = [];

  if flag == true
    figure(4)
    t = 1:length(vel.mag);
    plot(t,vel.mag,t,vel.x,t,vel.y)
    title('Velocity vs Frame Number')
    legend('Velocity','Vel_x','Vel_y')
    xlabel('Frame')
    ylabel('Velocity [cm/s]')

    figure(5)
    plot(pos.x,pos.y)
    title('Position Plot')
    xlabel('x position [cm]')
    ylabel('y position [cm]')
    axis equal
  end

end


function [sliceLocation] = dataSlicer(mag,extraPoints)
  counter = 0;

  for i = 1:length(mag)
    if mag(i) > 5
      break
    end

    counter = counter + 1;
  end

  sliceLocation = counter - extraPoints;
end
