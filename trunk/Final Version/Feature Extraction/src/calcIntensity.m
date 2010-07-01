function [avgInt,medianInt,avgIntCells,medianIntCells]= calcIntensity(grayImage)
% function that takes a greyscale image as input and returns the avg and
% median intensity for the entire image (single values) as well as for each part of 
% the image (1x9 arrays: 1 value for each cell of a 3x3 grid)
%
% [avgIntensity,medianIntensity,avgIntensityGrid,medianIntensityGrid = calcIntensity(greyscale_image)
%
% Created by Bart van de Poel
    
    % number of rows and columns for the grid used to calcualte
    % compositional features
    cellRows = 3;
    cellColumns = 3;
    
    avgInt = mean(mean(grayImage));            
    medianInt = median(reshape(grayImage,1,size(grayImage,1)*size(grayImage,2)));

    % reshape the returned 3x3 matrices to 1x9 feature vectors
    medianIntCells = reshape(gridCellsMedian(grayImage,cellRows,cellColumns),1,cellRows*cellColumns);            
    avgIntCells = reshape(gridCellsAvg(grayImage,cellRows,cellColumns),1,cellRows*cellColumns);

end