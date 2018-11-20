function [pos] = positionLogger(filename)
  tic
  % Read in video and process and initialize counter
  v = VideoReader(filename);
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
  toc
end


function [BW] = createMask(RGB)

  % Convert RGB image to chosen color space
  I = rgb2hsv(RGB);

  % Define thresholds for channel 1 based on histogram settings
  channel1Min = 0.039;
  channel1Max = 0.156;

  % Define thresholds for channel 2 based on histogram settings
  channel2Min = 0.470;
  channel2Max = 1.000;

  % Define thresholds for channel 3 based on histogram settings
  channel3Min = 0.696;
  channel3Max = 1.000;

  % Create mask based on chosen histogram thresholds
  BW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
      (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
      (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

  % Further BW filtering
  BW = bwpropfilt(BW,'Area',1);
  BW = imfill(BW, 'holes');

end
