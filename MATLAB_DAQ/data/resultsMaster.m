clear all
close all
clc

for ii = 1:16
  % Get a .mat file
  str{ii} = strcat('run',num2str(ii),'.mat');
  load(str{ii})

  % Calculate the new R and find instant V, save the results
  R = circleFilter(pospos,scale);
  out = plotter(pospos,aa,ww,tt,R);

  Outout(ii,1) = ii;
  Outout(ii,2) = out;

  % Make plots for each trial and the changing radius and the mean and std
  figure(1)
  x = 1:length(R.radius);

  subplot(4,4,ii)
  hold on
    line([1 length(R.radius)], [R.mean R.mean])
    line([1 length(R.radius)], [R.mean+R.std*R.devs R.mean+R.std*R.devs])
    line([1 length(R.radius)], [R.mean-R.std*R.devs R.mean-R.std*R.devs])

    plot(x,R.radius)
    plot(x(R.idx),R.radius(R.idx),'*r')
  hold off

  % Plot all the circles
  figure(2)
  subplot(4,4,ii)
  plot(pospos.x,pospos.y)
  axis equal
  title(strcat('Run: ',num2str(ii)))

end



% Sort the results and output. Clear str and then repeat for midpoint
results = sortrows(Outout,2)
clear str



for ii = 1:3
  str{ii} = strcat('midPoint',num2str(ii),'.mat');
  load(str{ii})

  % Calculate the new R and find instant V, save the results
  R = circleFilter(pospos,scale);
  out = plotter(pospos,aa,ww,tt,R);

  Outout2(ii,1) = ii;
  Outout2(ii,2) = out;

  % Make plots for each trial and the changing radius and the mean and std
  figure(3)
  x = 1:length(R.radius);

  subplot(1,3,ii)
  hold on
    line([1 length(R.radius)], [R.mean R.mean])
    line([1 length(R.radius)], [R.mean+R.std*R.devs R.mean+R.std*R.devs])
    line([1 length(R.radius)], [R.mean-R.std*R.devs R.mean-R.std*R.devs])

    plot(x,R.radius)
    plot(x(R.idx),R.radius(R.idx),'*r')
  hold off

  % Plot all the circles
  figure(4)
  subplot(1,3,ii)
  plot(pospos.x,pospos.y)
  axis equal
  title(strcat('Run: ',num2str(ii)))

end

results2 = Outout2
