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
