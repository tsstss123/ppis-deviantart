function [totalEdgeRatio,cellEdgeRatios] = calcEdgeRatios(image)
% function that takes a greyscale image as input and returns the edge to pixel
% ratio for the entire image (single value) as well as for each part of 
% the image (1x9 array: 1 value for each cell of a 3x3 grid). The edges
% are detected using the opencv canny edge detector.
%
% [edgeToPixelRatio,edgeToPixelRatioGrid = calcEdgeRatios(greyscale_image)
%
% Created by Bart van de Poel

    % number of rows and columns for the grid used to calcualte
    % compositional features
    cellRows = 3;
    cellColumns = 3;

    % call opencv canny edge detector, which returns a binary image of edges
    edgeImage = cvlib_mex('canny',image);
    totalEdgeRatio = sum(sum(edgeImage))/(size(edgeImage,1)*size(edgeImage,2));
    avgGridCells = gridCellsAvg(edgeImage,cellRows,cellColumns);
    
    %reshape the returned 3x3 matrix row-wise into a 1x9 feature vector.
    cellEdgeRatios = reshape(avgGridCells',1,cellRows*cellColumns);    
end

