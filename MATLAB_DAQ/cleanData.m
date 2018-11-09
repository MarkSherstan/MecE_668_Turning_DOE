function [a,w] = cleanData(a,w,t)

  a = cleanA(a,t);
  w = cleanW(w,t);

end



function [dataOut] = cleanA(a,t)
  x = 0;
  while (x ~= 1)

    if x == 1
      break
    else
      n = input('Window size of zero phase filter [10 normal]? ');
    end

    % Filter data with a zero phase average filter
    wwfilter = struct();
    dataOut.x = filtfilt(ones(1,n)/n,1,a.x);
    dataOut.y = filtfilt(ones(1,n)/n,1,a.y);
    dataOut.z = filtfilt(ones(1,n)/n,1,a.z);

    % Display results
    close all
    figure(1), hold on

    plot(t.seconds,a.x,'-r',t.seconds,a.y,'-g',t.seconds,a.z,'-b')
    plot(t.seconds,dataOut.x,'-r','LineWidth',2.5)
    plot(t.seconds,dataOut.y,'-g','LineWidth',2.5)
    plot(t.seconds,dataOut.z,'-b','LineWidth',2.5)

    title('Original Data and Filtered Data')
    ylabel('Acceleration [g]')
    xlabel('Time [s]')
    legend('a_x original','a_y original','a_z original','a_x','a_y','a_z')

    % Get information from the user
    x = input('Happy with accelerometer data (1 0)? ');
  end
end



function [dataOut] = cleanW(w,t)
  x = 0;
  while (x ~= 1)

    if x == 1
      break
    else
      n = input('How many points to smooth data [25 normal]? ');
    end

    % Adjust the data as required with a moving middle average
    dataOut.x = movmean(w.x,n);
    dataOut.y = movmean(w.y,n);
    dataOut.z = movmean(w.z,n);

    % Display results
    close all
    figure(1), hold on

    plot(t.seconds,w.x,'-r',t.seconds,w.y,'-g',t.seconds,w.z,'-b')
    plot(t.seconds,dataOut.x,'-r','LineWidth',2.5)
    plot(t.seconds,dataOut.y,'-g','LineWidth',2.5)
    plot(t.seconds,dataOut.z,'-b','LineWidth',2.5)

    title('Original Data and Filtered Data')
    ylabel('Angular Velocity [deg/s]')
    xlabel('Time [s]')
    legend('w_x original','w_y original','w_z original','w_x','w_y','w_z')

    % Get information from the user
    x = input('Happy with gyro data (1 0)? ');
  end
end
