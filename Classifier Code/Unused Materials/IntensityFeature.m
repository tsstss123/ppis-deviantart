% This function should compute the intensity value of an entire set of
% images inside a directory for n x n-patches that an image is divided into.
function [output] = IntensityFeature(directoryname)

    rgbimage = imread(path);
    image = rgb2hsv(rgbimage);
           
    % Extract Color Channels
    r = image(:,:,1);
    g = image(:,:,2);
    b = image(:,:,3);
    
end

