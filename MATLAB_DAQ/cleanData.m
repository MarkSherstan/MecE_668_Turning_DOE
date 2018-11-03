function [dataOut] = cleanData(a,w,t)

  w = cleanW(w,t);
  a = cleanA(a,t);

end


function [dataOut] = cleanW(w,t)
  x = 0;
  w.xx = w.x;
  w.yy = w.y;
  w.zz = w.z;

  while (x ~= 1)
    close all
    figure(1)
    tt = 1:length(t.seconds);

    subplot(2,1,1)
    plot(tt,w.x,tt,w.y,tt,w.z)
    title('Original Data')
    legend('w_x','w_y','w_z')

    subplot(2,1,2)
    plot(tt,w.xx,tt,w.yy,tt,w.zz)
    title('Cleaned Data')
    legend('w_x','w_y','w_z')

    % Get information from the user
    x = input('Is data smoothed (1 0)? ');

    if x == 1
      break
    else
      smoothCoef = input('How many points to smooth data [25 normal]? ');
    end

    % Adjust the data as required
    w.xx = movmean(w.x,smoothCoef);
    w.yy = movmean(w.y,smoothCoef);
    w.zz = movmean(w.z,smoothCoef);

end
