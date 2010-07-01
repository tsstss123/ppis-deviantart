function [medianHue,medianSat,medianVal,avgHue,avgSat,avgVal,medHueCells,medSatCells,medValCells,avgHueCells,avgSatCells,avgValCells] = calcHSV(vsh)
% Function that takes an VSH (Value,Saturation,Hue) image as input and
% returns the median and average Hue,Saturation and Value for the entire
% image (single values) as well as for each part of the image (1x9 arrays: 1
% value for each cell of a 3x3 grid)
%
% [medianHue,medianSat,medianValue,avgHue,avgSat,avgValue,medianHueGrid,
% medianSatGrid,medianValGrid,avgHueGrid,avgSatGrid,avgValueGrid] = calcHSV(VSH_image)
%
% Created by Bart van de Poel

    % number of rows and columns for the grid used to calcualte
    % compositional features
    cellRows = 3;
    cellColumns = 3;
        
    meanVSH = mean(mean(vsh(:,:,1:3)));            
    medianHue = median(reshape(vsh(:,:,3),1,size(vsh,1)*size(vsh,2)));
    medianSat = median(reshape(vsh(:,:,2),1,size(vsh,1)*size(vsh,2)));
    medianVal = median(reshape(vsh(:,:,1),1,size(vsh,1)*size(vsh,2)));

    avgHue = meanVSH(3);
    avgSat = meanVSH(2);
    avgVal = meanVSH(1);

    medHueSatValCells = gridCellsMedian(vsh(:,:,1:3),cellRows,cellColumns);
    avgValSatHueCells = gridCellsAvg(vsh(:,:,1:3),cellRows,cellColumns);
    
    % reshape the returned 3x3 matrices to 1x9 feature vectors    
    medHueCells = reshape(medHueSatValCells(:,:,3),1,cellRows*cellColumns);
    medSatCells = reshape(medHueSatValCells(:,:,2),1,cellRows*cellColumns);
    medValCells = reshape(medHueSatValCells(:,:,1),1,cellRows*cellColumns);                
    avgValCells = reshape(avgValSatHueCells(:,:,1),1,cellRows*cellColumns);
    avgSatCells = reshape(avgValSatHueCells(:,:,2),1,cellRows*cellColumns);
    avgHueCells = reshape(avgValSatHueCells(:,:,3),1,cellRows*cellColumns);    
end