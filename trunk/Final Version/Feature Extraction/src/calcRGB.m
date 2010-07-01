function [medianR,medianG,medianB,avgR,avgG,avgB,medRCells,medGCells,medBCells,avgRCells,avgGCells,avgBCells] = calcRGB(image)
% Function that takes an RGB image as input and
% returns the median and average R,G and B values for the entire
% image (single values) as well as for each part of the image (1x9 arrays: 1
% value for each cell of a 3x3 grid)
%
% [medianRed,medianGreen,medianBlue,avgRed,avgGreen,avgBlue,medianRedGrid,
% medianGreenGrid,medianBlueGrid,avgRedGrid,avgGreenGrid,avgBlueGrid] = calcRGB(RGB_image)
%
% Created by Bart van de Poel

    % number of rows and columns for the grid used to calcualte
    % compositional features
    cellRows = 3;
    cellColumns = 3;
    
    meanRGB = mean(mean(image));
    avgR = meanRGB(1);
    avgG = meanRGB(2);
    avgB = meanRGB(3);        
    
    medianR = median(reshape(image(:,:,1),1,size(image,1)*size(image,2)));
    medianG = median(reshape(image(:,:,2),1,size(image,1)*size(image,2)));
    medianB = median(reshape(image(:,:,3),1,size(image,1)*size(image,2)));
    
    medRGBCells = gridCellsMedian(image,cellRows,cellColumns);
    avgRGBCells = gridCellsAvg(image,cellRows,cellColumns);
    % reshape the returned 3x3 matrices to 1x9 feature vectors
    medRCells = reshape(medRGBCells(:,:,1),1,cellRows*cellColumns);
    medGCells = reshape(medRGBCells(:,:,2),1,cellRows*cellColumns);
    medBCells = reshape(medRGBCells(:,:,3),1,cellRows*cellColumns);    
    avgRCells = reshape(avgRGBCells(:,:,1),1,cellRows*cellColumns);
    avgGCells = reshape(avgRGBCells(:,:,2),1,cellRows*cellColumns);
    avgBCells = reshape(avgRGBCells(:,:,3),1,cellRows*cellColumns);    
    
end