function [a,w,t,pos] = dataSlicer(a,w,t,pos,extraPoints)

  % Calculate magnitudes and find slice locations
  magW = sqrt(w.x.^2 + w.y.^2 + w.z.^2);
  magPos = sqrt(pos.x.^2 + pos.y.^2);

  sliceLocation(1) = sliceSensor(magW, extraPoints);
  sliceLocation(2) = sliceVideo(magPos, extraPoints);

  % Output sliced a w and t
  a.x(1:sliceLocation(1)) = [];
  a.y(1:sliceLocation(1)) = [];
  a.z(1:sliceLocation(1)) = [];
  w.x(1:sliceLocation(1)) = [];
  w.y(1:sliceLocation(1)) = [];
  w.z(1:sliceLocation(1)) = [];
  t.microSeconds(1:sliceLocation(1)) = [];
  t.seconds(1:sliceLocation(1)) = [];
  t.frequency(1:sliceLocation(1)) = [];

  % Output sliced pos
  pos.x(1:sliceLocation(2)) = [];
  pos.y(1:sliceLocation(2)) = [];

end


function [sliceLocation] = sliceSensor(mag, extraPoints)
  % Initialize variables
  counter = 0;
  forward = movmean(mag,[0, 2]);
  back = movmean(mag,[2, 0]);

  % Find the point to cut at
  for j = 1:length(mag)
    if abs((forward(j) - back(j)) / (back(j))) > 0.1
      break
    end
    counter = counter + 1;
  end

  sliceLocation = counter - extraPoints;
end


function [sliceLocation] = sliceVideo(mag, extraPoints)
  % Initialize variables
  counter = 0;
  flat = mean(mag(1:150));

  % Find the point to cut at
  for j = 1:length(mag)
    if abs((mag(j) - flat) / (flat)) > 0.005
      break
    end
    counter = counter + 1;
  end

  sliceLocation = counter - extraPoints;
end
