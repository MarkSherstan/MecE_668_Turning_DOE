%% To do:
% Write to .txt file
% create plots
% test in a variety of videos

clear all
close all
clc

% Declare variables
oldPoints = [];

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
        vel = deltaTot * frameRate * scale;
        velx = deltaX * frameRate * scale;
        vely = deltaY * frameRate * scale;

        fprintf('Velocity: %0.2f [mm/s]\tVel x: %0.2f [mm/s]\tVel y: %0.2f [mm/s]\n',vel,velx,vely)
      else
        vel_pix = 0;
        vel = 0;
    end

    % Visualize the velocity and show a frame
    frameOut = insertObjectAnnotation(frame, 'circle',[points(1) points(2), 50], cellstr(num2str(vel,'%2.2f')));
    imshow(frameOut)

    % Save data for next frame
    oldPoints = points;
end
