function [a,w,t,PWM] = fileReader(filename)
  M = csvread(filename);

  t.microSeconds = M(:,1);
  t.seconds = t.microSeconds * 1e-6;
  a.x = M(:,2);
  a.y = M(:,3);
  a.z = M(:,4);
  w.x = M(:,5);
  w.y = M(:,6);
  w.z = M(:,7);
  PWM = M(:,8);

  for i = 1:length(t.microSeconds)-1
    t.frequency(i,1) = 1e6 / (t.microSeconds(i+1) - t.microSeconds(i));
  end

end
