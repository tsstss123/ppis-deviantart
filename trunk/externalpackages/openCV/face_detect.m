function rectangleMatrix = face_detect( img, classifierFileFullPath, minFaceSize, shouldViewElapsedTime )
% Gateway function to OpenCV's face detection
% Inputs:
%  img -> can be an RGB or Grayscale image. 
%  classifierFileFullPath -> Full path of the haar xml file
%  minFaceSize -> Minimum face area accepted as valid face (default is 100)
%  shouldViewElapsedTime -> 1 or 0 (default is 0)
% Outputs:
%  rectangleMatrix -> the found faces where each row of the rectangleMatrix
%  is a found face's rectangle
% 
% by Ismail Ari
% http://ismailari.com

if nargin < 3
    minFaceSize = 100;
end
if nargin < 4
    shouldViewElapsedTime = 0;
end

[rectanglesArray] = cvlib_mex('facedetect', im2uint8(img), ...
                              classifierFileFullPath, minFaceSize, ...
                              shouldViewElapsedTime);
nRectangles = length(rectanglesArray)/4;
rectangleMatrix = zeros(nRectangles,4);
for iRectangle = 1:nRectangles
    rectangleMatrix(iRectangle,:) = ...
        rectanglesArray(4*(iRectangle-1)+1:4*iRectangle);
end
