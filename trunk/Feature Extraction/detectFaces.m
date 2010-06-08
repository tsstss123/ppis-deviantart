

classifierFilename = 'haarcascade_frontalface_default.xml';

% currentPath = [fileparts([mfilename('fullpath') '.m']) filesep];

classifierFileFullPath = ['haarcascades' filesep classifierFilename];

minFaceSize = 25;


shouldViewElapsedTime = 1;


img = imread('deviant/10_Xanxus_x_Squalo_by_LALAax.jpg'); %use your own jpg here

imgGray = rgb2gray(img);

rectangleMatrix = cvlib_mex('facedetect',imgGray,classifierFileFullPath, minFaceSize, shouldViewElapsedTime );

imshow(img);

for iRectangle = 1:size(rectangleMatrix,1)

    rectangle('Position',rectangleMatrix, 'EdgeColor', 'r')

end