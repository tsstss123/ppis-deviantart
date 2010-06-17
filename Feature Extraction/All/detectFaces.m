function numFaces = detectFaces(imgGray,project_root)

classifierFilename = 'haarcascade_frontalface_default.xml';
% classifierFilename = 'haarcascade_profileface.xml';
classifierFileFullPath = [project_root 'externalpackages' filesep 'openCV' filesep 'haarcascades' filesep classifierFilename];

% Bigger?
minFaceSize = 25;

% What is this?
shouldViewElapsedTime = 0;

% if size(img,3) < 3
%     imgGray = img(:,:,1);
% else
%     imgGray = rgb2gray(img);
% end
% compiled cvlib_mex with parameter min_neighbors=6 (default is 3)
rectangleMatrix = cvlib_mex('facedetect',imgGray,classifierFileFullPath, minFaceSize, shouldViewElapsedTime );

% imshow(img);
numFaces = size(rectangleMatrix,1)/4;
% for i = 1:4:size(rectangleMatrix,1)
%     rectangle('Position',rectangleMatrix(i:i+3,:), 'EdgeColor', 'r')
% end 

end