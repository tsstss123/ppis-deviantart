function numCorners = detectCorners(image)
    corners = cvlib_mex('goodfeatures',image);
    numCorners = size(corners,1);
end