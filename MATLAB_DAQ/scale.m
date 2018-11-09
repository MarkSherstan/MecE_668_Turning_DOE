function [out, red, blue, green] = scale(filename,flag)

  % Filter out initial capture and get scale from advanced frame
  v = VideoReader(filename);
  for i = 1:60
    I = readFrame(v);
  end

  % Actual center to center distance of blobs
  red.c2c = 10/100;       % m
  green.c2c = 20/100;     % m
  blue.c2c = 15/100;      % m

  % Threshold images for blobs
  [red.BW, red.colorMask] = createRedMask(I);
  [green.BW, green.colorMask] = createGreenMask(I);
  [blue.BW, blue.colorMask] = createBlueMask(I);

  % Find blob centroids and scale
  red.scale = colorScale(red.BW, red.c2c);
  blue.scale = colorScale(blue.BW, blue.c2c);
  green.scale = colorScale(green.BW, green.c2c);

  % Average scale across red, green, and blue.
  out = (red.scale + blue.scale + green.scale)/3;

  % Display all images based on flag
  if flag == true
    figure(1)
    subplot(2,2,1), imshow(I)
    subplot(2,2,2), imshow(red.BW)
    subplot(2,2,3), imshow(green.BW)
    subplot(2,2,4), imshow(blue.BW)

    figure(2)
    subplot(2,2,1), imshow(I)
    subplot(2,2,2), imshow(red.colorMask)
    subplot(2,2,3), imshow(green.colorMask)
    subplot(2,2,4), imshow(blue.colorMask)
  end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sub Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [out] = colorScale(BW, c2c)
  stats = regionprops('table',BW,'Centroid');
  points = table2array(stats);

  x = points(1,1) - points(2,1);
  y = points(1,2) - points(2,2);
  dist = sqrt(x^2 + y^2);

  out = c2c / dist;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [BW,maskedRGBImage] = createRedMask(RGB)

% Convert RGB image to chosen color space
I = rgb2hsv(RGB);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.935;
channel1Max = 0.021;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.309;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.000;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
sliderBW = ( (I(:,:,1) >= channel1Min) | (I(:,:,1) <= channel1Max) ) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;
BW = bwpropfilt(BW,'Area',2);
BW = imfill(BW, 'holes');


% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [BW,maskedRGBImage] = createBlueMask(RGB)

% Convert RGB image to chosen color space
I = rgb2hsv(RGB);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.460;
channel1Max = 0.714;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.309;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.000;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;
BW = bwpropfilt(BW,'Area',2);
BW = imfill(BW, 'holes');

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [BW,maskedRGBImage] = createGreenMask(RGB)

% Convert RGB image to chosen color space
I = rgb2hsv(RGB);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.256;
channel1Max = 0.447;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.309;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.000;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;
BW = bwpropfilt(BW,'Area',2);
BW = imfill(BW, 'holes');

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

end
