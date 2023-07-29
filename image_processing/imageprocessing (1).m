% Read the image

 % I = imread('raw.jpg');
 % I = imread('ripe2.jpeg');


% Convert the image to HSV color space
Ihsv = rgb2hsv(I);

% Extract the Hue and Saturation channels
H = Ihsv(:,:,1);
S = Ihsv(:,:,2);

% Define the range of Hue and Saturation values for ripe custard apples
ripeHueRange = [0.05 0.2];
ripeSatRange = [0.4 1];

% Create a binary mask of the ripe areas of the image based on color
ripeMask = (H > ripeHueRange(1)) & (H < ripeHueRange(2)) & (S > ripeSatRange(1)) & (S < ripeSatRange(2));

% Apply median filter to remove noise
ripeMask = medfilt2(ripeMask, [3 3]);

% Apply edge detection using the Canny method to detect the edges of the custard apple
edgeBW = edge(Ihsv(:,:,3), 'canny');

% combine the edge detection result with the color detection result
combinedMask = ripeMask & edgeBW;

% Calculate the area of the object in the image
stats = regionprops(combinedMask, 'Area');
area = stats.Area;

% If the area is larger than a threshold value, the custard apple is likely ripe
if area > 3
    disp('The custard apple is likely ripe.');
else
    disp('The custard apple is likely not ripe.');
end

% Display the original image, the ripe color mask, the edge detection result, and the combined result
figure;
subplot(2,2,1);
imshow(I);
title('Original Image');
subplot(2,2,2);
imshow(ripeMask);
title('Ripe Color Mask');
subplot(2,2,3);
imshow(edgeBW);
title('Edge Detection Result');
subplot(2,2,4);
imshow(combinedMask);
title('Combined Result');
