function [medianR,medianG,medianB,avgR,avgG,avgB,medRCells,medGCells,medBCells,avgRCells,avgGCells,avgBCells] = calcRGB(image)
cellRows = 3;
cellColumns = 3;
% if size(image,3) == 3
    
    meanRGB = mean(mean(image));
    avgR = meanRGB(1);
    avgG = meanRGB(2);
    avgB = meanRGB(3);        
    
    medianR = median(reshape(image(:,:,1),1,size(image,1)*size(image,2)));
    medianG = median(reshape(image(:,:,2),1,size(image,1)*size(image,2)));
    medianB = median(reshape(image(:,:,3),1,size(image,1)*size(image,2)));
    
    medRGBCells = gridCellsMedian(image,cellRows,cellColumns);
    medRCells = reshape(medRGBCells(:,:,1),1,cellRows*cellColumns);
    medGCells = reshape(medRGBCells(:,:,2),1,cellRows*cellColumns);
    medBCells = reshape(medRGBCells(:,:,3),1,cellRows*cellColumns);
    
    avgRGBCells = gridCellsAvg(image,cellRows,cellColumns);
    avgRCells = reshape(avgRGBCells(:,:,1),1,cellRows*cellColumns);
    avgGCells = reshape(avgRGBCells(:,:,2),1,cellRows*cellColumns);
    avgBCells = reshape(avgRGBCells(:,:,3),1,cellRows*cellColumns);    
%     avgSatCells = reshape(gridCellsAvg(vsh(:,:,2),cellRows,cellColumns),1,cellRows*cellColumns);
%     avgIntCells = reshape(gridCellsAvg(vsh(:,:,1),cellRows,cellColumns),1,cellRows*cellColumns);

% elseif size(image,3) == 1
%     meanRGB = mean(mean(image));
%     avgR = meanRGB(1);
%     avgG = meanRGB(1);
%     avgB = meanRGB(1);
%                 
%     avgRCells = reshape(gridCellsAvg(image(:,:,1),cellRows,cellColumns),1,cellRows*cellColumns);
%     avgGCells = avgRCells;
%     avgBCells = avgRCells;    
% else
%     % OR SOMETHING ELSE?
%     meanRGB = mean(mean(image));
%     avgR = meanRGB(1);
%     avgG = meanRGB(1);
%     avgB = meanRGB(1);
%                 
%     avgRCells = reshape(gridCellsAvg(image(:,:,1),cellRows,cellColumns),1,cellRows*cellColumns);
%     avgGCells = avgRCells;
%     avgBCells = avgRCells;  
% end


end