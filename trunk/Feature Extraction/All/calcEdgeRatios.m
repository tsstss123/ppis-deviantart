function [totalEdgeRatio,cellEdgeRatios] = calcEdgeRatios(image)
% Change default Parameters ????????
    cellRows = 3;
    cellColumns = 3;
    edgeImage = cvlib_mex('canny',image);
    totalEdgeRatio = sum(sum(edgeImage))/(size(edgeImage,1)*size(edgeImage,2));
    avgGridCells = gridCellsAvg(edgeImage,cellRows,cellColumns);
    
    %cell values are put row-wise into a feature vector. So [1,2;3,4] will
    %become [1,2,3,4]
    cellEdgeRatios = reshape(avgGridCells',1,cellRows*cellColumns);    
end

