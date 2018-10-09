function [a,w,t] = txtReader(filename,flag)
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
    t.frequency(i) = 1e6 / (t.microSeconds(i+1) - t.microSeconds(i));
  end

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
