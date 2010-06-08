function edgeRatio = calcEdgeRatio(image)
% Change default Parameters ????????
    edgeImage = cvlib_mex('canny',image);
    edgeRatio = sum(sum(edgeImage))/(size(edgeImage,1)*size(edgeImage,2));
end

