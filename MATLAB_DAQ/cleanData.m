function [a,w] = cleanData(a,w,t)

  a = cleanA(a,t);
  w = cleanW(w,t);

end



function [dataOut] = cleanA(a,t)

  % Set up starting variables
  Fs = mean(t.frequency);
  T = 1/Fs;
  L = length(t.seconds);
  t = (0:L-1)*T;

  % Plot original data in time domain
  figure(1)
  title('Time Domain Plot')
  xlabel('time (s)')
  ylabel('magnitude')
  tt = 1:L;

  subplot(3,1,1)
  plot(tt,a.x)

  subplot(3,1,2)
  plot(tt,a.y)

  subplot(3,1,3)
  plot(tt,a.z)

  % Perfom FFT
  Y.x = fft(a.x);
  P2.x = abs(Y.x/L);
  P1.x = P2.x(1:L/2+1);
  P1.x(2:end-1) = 2*P1.x(2:end-1);
  f.x = Fs*(0:(L/2))/L;

  Y.y = fft(a.y);
  P2.y = abs(Y.y/L);
  P1.y = P2.y(1:L/2+1);
  P1.y(2:end-1) = 2*P1.y(2:end-1);
  f.y = Fs*(0:(L/2))/L;

  Y.z = fft(a.z);
  P2.z = abs(Y.z/L);
  P1.z = P2.z(1:L/2+1);
  P1.z(2:end-1) = 2*P1.z(2:end-1);
  f.z = Fs*(0:(L/2))/L;

  % Plot frequency domain
  figure(2)
  title('Frequency Domain Plot')
  xlabel('f (Hz)')
  ylabel('|P1(f)|')

  subplot(3,1,1)
  plot(f.x,P1.x)

  subplot(3,1,2)
  plot(f.y,P1.y)

  subplot(3,1,3)
  plot(f.z,P1.z)

  x = 0;
  while (x ~= 1)

    if x == 1
      break
    else
      cutOffFreq.x = input('Cut off frequency x: ');
      cutOffFreq.y = input('Cut off frequency y: ');
      cutOffFreq.z = input('Cut off frequency z: ');
    end

    % Design a 6th order butterworth filter based off the frequnecy domain plot
    fc.x = cutOffFreq.x;
    fc.y = cutOffFreq.y;
    fc.z = cutOffFreq.z;

    fs = Fs;

    [B,A] = butter(6,fc.x/(fs/2));
    dataOut.x = filter(B,A,a.x);

    [B,A] = butter(6,fc.y/(fs/2));
    dataOut.y = filter(B,A,a.y);

    [B,A] = butter(6,fc.z/(fs/2));
    dataOut.z = filter(B,A,a.z);

    % Plot the filtered data back in the time domain
    figure(3)
    title('Time Domain Plot - Filtered')
    xlabel('time (s)')
    ylabel('magnitude')

    subplot(3,1,1)
    plot(tt,dataOut.x)

    subplot(3,1,2)
    plot(tt,dataOut.y)

    subplot(3,1,3)
    plot(tt,dataOut.z)

    % Get information from the user
    x = input('Happy with the accelerometer data? (1 0)? ');
  end

end



function [dataOut] = cleanW(w,t)
  x = 0;
  while (x ~= 1)

    if x == 1
      break
    else
      smoothCoef = input('How many points to smooth data [25 normal]? ');
    end

    % Adjust the data as required
    dataOut.x = movmean(w.x,smoothCoef);
    dataOut.y = movmean(w.y,smoothCoef);
    dataOut.z = movmean(w.z,smoothCoef);

    % Display results
    close all
    figure(1)
    tt = 1:length(t.seconds);

    subplot(2,1,1)
    plot(tt,w.x,tt,w.y,tt,w.z)
    title('Original Data')
    legend('w_x','w_y','w_z')

    subplot(2,1,2)
    plot(tt,dataOut.x,tt,dataOut.y,tt,dataOut.z)
    title('Cleaned Data')
    legend('w_x','w_y','w_z')

    % Get information from the user
    x = input('Happy with gyro data (1 0)? ');
  end
end
