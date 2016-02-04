# Introduction #

download http://ismailari.com/wp-content/uploads/2008/06/Using_OpenCV_in_MATLAB.zip

open matlab

go to the folder where you extracted the files

compile cvlib\_mex.mexw32 (or cvlib\_mex.mexw64, or cvlib\_mex.dll) with the make\_cvlib code
(you can edit this)

now you can use opencv functions.

cvlib\_mex in matlab gives you a list of functions

cvlib\_mex('resize') for instance, will do the resize operation

face detection with adaboosted haar classifier (viola-jones) is like this:



```
clear, 

clc
 
classifierFilename = 'haarcascade_frontalface_default.xml';

currentPath = [fileparts([mfilename('fullpath') '.m']) filesep];

classifierFileFullPath = [currentPath 'haarcascades' filesep classifierFilename];
 
minFaceSize = 25;
 

shouldViewElapsedTime = 1;
 

img = imread('1.jpg'); %use your own jpg here

imgGray = rgb2gray(img);
 
rectangleMatrix = face_detect( imgGray, classifierFileFullPath, minFaceSize, shouldViewElapsedTime );

imshow(img);

for iRectangle = 1:size(rectangleMatrix,1)

rectangle('Position',rectangleMatrix(iRectangle,:), 'EdgeColor', 'r')

end
```