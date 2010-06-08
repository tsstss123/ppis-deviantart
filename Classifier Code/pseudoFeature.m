% This function needs to be replaced with a function that can compute the
% wanted features for an image.
function [ featurevector ] = pseudoFeature( imagepath )

    % Read in an image
    fprintf('Converting Image to HSV: %s\n', imagepath);
    rgbimage = imread(imagepath);
    image = rgb2hsv(rgbimage);
           
    % Extract Color Channels
    h = image(:,:,1);
    s = image(:,:,2);
    v = image(:,:,3);
    
    % Determine number of pixels
    imagesize = size(image);
    numberofpixels = imagesize(1) * imagesize(2);
    
    fprintf('Computing average h,s,v\n');
    % Compute average hsv
    avgh = sum(sum(h)) / numberofpixels;
    avgs = sum(sum(s)) / numberofpixels;
    avgv = sum(sum(v)) / numberofpixels;
    
    % Create featurevector
    featurevector = [avgh, avgs, avgv];

end

