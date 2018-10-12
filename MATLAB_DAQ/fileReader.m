function [a,w,t] = fileReader(filename,flag,extraPoints)
% Feed in filename string and true/false for displaying plots
% Receive accleration, angular velocity, and time/frequency

  M = csvread(filename);

  t.microSeconds = M(:,1);
  t.seconds = t.microSeconds * 1e-6;
  a.x = M(:,2);
  a.y = M(:,3);
  a.z = M(:,4);
  w.x = M(:,5);
  w.y = M(:,6);
  w.z = M(:,7);

  for i = 1:length(t.microSeconds)-1
    t.frequency(i,1) = 1e6 / (t.microSeconds(i+1) - t.microSeconds(i));
  end

  mag = sqrt(a.x.^2 + a.y.^2 + a.z.^2);
  sliceLocation = dataSlicer(mag,extraPoints);

  t.microSeconds(1:sliceLocation) = [];
  t.seconds(1:sliceLocation) = [];
  t.frequency(1:sliceLocation) = [];

  a.x(1:sliceLocation) = [];
  a.y(1:sliceLocation) = [];
  a.z(1:sliceLocation) = [];
  w.x(1:sliceLocation) = [];
  w.y(1:sliceLocation) = [];
  w.z(1:sliceLocation) = [];

  if flag == true
    figure(1)
    plot(t.seconds,a.x,t.seconds,a.y,t.seconds,a.z)
    title('Acceleration as a function of Time')
    legend('a_x','a_y','a_z')
    xlabel('Time (s)')
    ylabel('Acceleration [g]')


    figure(2)
    plot(t.seconds,w.x,t.seconds,w.y,t.seconds,w.z)
    title('Angular Velocity as a function of Time')
    legend('w_x','w_y','w_z')
    xlabel('Time (s)')
    ylabel('Angular Velocity [deg/s]')


    figure(3)
    title('Acceleration and Angular Velocity as a function of Time')
    xlabel('Time (s)')

    yyaxis left
    a = plot(t.seconds,a.x,'-r',t.seconds,a.y,'-g',t.seconds,a.z,'-b');
    ylabel('Acceleration [g]')

    yyaxis right
    b = plot(t.seconds,w.x,'--r',t.seconds,w.y,'--g',t.seconds,w.z,'--b');
    ylabel('Angular Velocity [deg/s]')

    Leg = legend([a; b], {'a_x','a_y','a_z','w_x','w_y','w_z'});
  end

end

function [sliceLocation] = dataSlicer(mag,extraPoints)
  M2 = movmean(mag,2);
  M4 = movmean(mag,4);

  counter = 0;

  for i = 1:length(mag)
    if abs((M2(i) - M4(i)) / (M4(i))) > 0.1
      break
    end
    counter = counter + 1;
  end

  sliceLocation = counter - extraPoints;
end
