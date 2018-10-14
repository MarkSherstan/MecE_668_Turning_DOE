function [a,w,t,pos] = dataSlicer(a,w,t,pos)

  % Calculate magnitudes and find slice locations
  magW = sqrt(w.x.^2 + w.y.^2 + w.z.^2);
  magPos = sqrt(pos.x.^2 + pos.y.^2);

  sliceLocationSensor = slicer(magW);
  sliceLocationVideo = slicer(magPos);

  % Get input from user if values are good
  x = 0;
  while (x ~= 1)
    close all
    figure(1)
    x1 = 1:length(magPos);
    x2 = 1:length(magW);

    subplot(2,1,1)
    hold on
    plot(x2,magW,'--m')
    plot([sliceLocationSensor(1) sliceLocationSensor(1)],ylim,'-k','LineWidth',2)
    plot([sliceLocationSensor(2) sliceLocationSensor(2)],ylim,'-k','LineWidth',2)
    title('Slice Position of Sensor Data')
    hold off

    subplot(2,1,2)
    hold on
    plot(x1,magPos,'--c')
    plot([sliceLocationVideo(1) sliceLocationVideo(1)],ylim,'-k','LineWidth',2)
    plot([sliceLocationVideo(2) sliceLocationVideo(2)],ylim,'-k','LineWidth',2)
    title('Slice Position of Video Data')
    hold off

    % Get information from the user
    x = input('Are cut locations good (1 0)? ');

    if x == 1
      break
    else
      fixSensorLow = input('Adjust sensor low by: ');
      fixSensorHigh = input('Adjust sensor high by: ');

      fixVideoLow = input('Adjust video low by: ');
      fixVideoHigh = input('Adjust video high by: ');
    end

    % Adjust the data as required
    sliceLocationSensor(1) = sliceLocationSensor(1) + fixSensorLow;
    sliceLocationSensor(2) = sliceLocationSensor(2) + fixSensorHigh;

    sliceLocationVideo(1) = sliceLocationVideo(1) + fixVideoLow;
    sliceLocationVideo(2) = sliceLocationVideo(2) + fixVideoHigh;
  end

  % Output sliced a w and t
  a.x = a.x(sliceLocationSensor(1):sliceLocationSensor(2));
  a.y = a.y(sliceLocationSensor(1):sliceLocationSensor(2));
  a.z = a.z(sliceLocationSensor(1):sliceLocationSensor(2));
  w.x = w.x(sliceLocationSensor(1):sliceLocationSensor(2));
  w.y = w.y(sliceLocationSensor(1):sliceLocationSensor(2));
  w.z = w.z(sliceLocationSensor(1):sliceLocationSensor(2));
  t.microSeconds = t.microSeconds(sliceLocationSensor(1):sliceLocationSensor(2));
  t.seconds = t.seconds(sliceLocationSensor(1):sliceLocationSensor(2));
  t.frequency = t.frequency(sliceLocationSensor(1):sliceLocationSensor(2));

  % Output sliced pos
  pos.x = pos.x(sliceLocationVideo(1):sliceLocationVideo(2));
  pos.y = pos.y(sliceLocationVideo(1):sliceLocationVideo(2));

end


function [sliceLocation] = slicer(mag)
  % Initialize variables
  countForward = 0;
  countBackward = 0;
  flatForward = mean(mag(1:100));
  flatBackward = mean(mag(end-100:end));

  % Find the front point to cut at
  for j = 1:length(mag)
    if abs( (mag(j) - flatForward) ) > 5
      break
    end
    countForward = countForward + 1;
  end

  % Find the rear point to cut at
  for j = length(mag):-1:1
    if abs( (mag(j) - flatBackward) ) > 5
      break
    end
    countBackward = countBackward + 1;
  end

  sliceLocation(1) = countForward;
  sliceLocation(2) = length(mag) - countBackward;
end
