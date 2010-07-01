function numFaces = detectFaces(imgGray,project_root)
% Function that takes a greyscale image as input together with the root of
% the project (to localize the haarcascades) and returns a scalar value denoting 
% the number of faces in the image that were detected using the opencv face detector

% Profile faces turned off for now. If turned on, some reasoning needs to
% be done so that faces are not detected as both profile as frontal faces.
%
% Created by Bart van de Poel
classifierFilename = 'haarcascade_frontalface_default.xml';
% classifierFilename = 'haarcascade_profileface.xml';
classifierFileFullPath = [project_root 'externalpackages' filesep 'openCV' filesep 'haarcascades' filesep classifierFilename];

minFaceSize = 25;

% no prints
shouldViewElapsedTime = 0;
% call opencv facedetector
rectangleMatrix = cvlib_mex('facedetect',imgGray,classifierFileFullPath, minFaceSize, shouldViewElapsedTime );
numFaces = size(rectangleMatrix,1)/4;

% Piece of code to display the image with a red rectangle drawn around the face
% imshow(imgGray);
% for i = 1:4:size(rectangleMatrix,1)
%     rectangle('Position',rectangleMatrix(i:i+3,:), 'EdgeColor', 'r')
% end 

end