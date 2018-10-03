clear all
close all
clc

% Declare variables
oldPoints = [];
i = 1;

% Read in video and process
v = VideoReader('test.mp4');
frameRate = v.FrameRate;

% Get scale from first frame
frame = readFrame(v);
[scale] = scale(frame,false);

% Loop through video frame by frame
while hasFrame(v)
    frame = readFrame(v);
    BW = createMask(frame);

    stats = regionprops('table',BW,'Centroid');
    points = table2array(stats);

    if ~isempty(oldPoints)
        deltaX = points(1) - oldPoints(1);
        deltaY = points(2) - oldPoints(2);
        deltaTot = sqrt(deltaX^2 + deltaY^2);

        % pixels/frame * frame/seconds * cm/pixel
        vel(i) = deltaTot * frameRate * scale;
        velx(i) = deltaX * frameRate * scale;
        vely(i) = deltaY * frameRate * scale;

        fprintf('Velocity: %0.2f [cm/s]\tVel x: %0.2f [cm/s]\tVel y: %0.2f [cm/s]\n',vel(i),velx(i),vely(i))
        frameOut = insertObjectAnnotation(frame, 'circle',[points(1) points(2), 50], cellstr(num2str(vel(i),'%2.2f')));
      else
        vel_pix = 0;
        vel = 0;
        frameOut = frame;
    end

    imshow(frameOut)

    % Save data for next frame
    oldPoints = points;
    i = i + 1;
end

t = 1:i-1;
plot(t,vel,t,velx,t,vely)
title('Velocity vs Frame Number')
legend('Velocity','Vel_x','Vel_y')
xlabel('Frame')
ylabel('Velocity [cm/s]')
