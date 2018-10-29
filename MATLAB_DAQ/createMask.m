function [BW] = createMask(RGB)

% Convert RGB image to chosen color space
I = rgb2hsv(RGB);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.014;
channel1Max = 0.103;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.600;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.495;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
BW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

% Further BW filtering
% BW = bwpropfilt(BW, 'Area', [7000, inf]);
BW = bwpropfilt(BW,'Area',1);
BW = imfill(BW, 'holes');

end
