% A sample program to use OpenCV's face detector 
%
% by Ismail Ari
% http://ismailari.com


clear, clc

% The preferences (You can modify them)

% The classifier xml files. They can be found in 
% "OpenCV folder"\data\haarcascades and you can copy them to your working
% folder if you like
classifierFilename = 'haarcascade_frontalface_default.xml';
currentPath = [fileparts([mfilename('fullpath') '.m']) filesep];
classifierFileFullPath = [currentPath 'haarcascades' filesep classifierFilename];

% Minimum face size (area) to detect
minFaceSize = 15;

% Should the OpenCV face detector print the elapsed time?
shouldViewElapsedTime = 1;

% Read an image and convert it to grayscale
img = imread('1.jpg');
imgGray = rgb2gray(img);

% Find the faces and draw them
rectangleMatrix = face_detect( imgGray, classifierFileFullPath, minFaceSize, shouldViewElapsedTime );
imshow(img);
for iRectangle = 1:size(rectangleMatrix,1)
    rectangle('Position',rectangleMatrix(iRectangle,:), 'EdgeColor', 'r')
end
