function [avgR,avgG,avgB,avgRCells,avgGCells,avgBCells] = calcRGB(image)
cellRows = 3;
cellColumns = 3;
if size(image,3) == 3
    
    meanRGB = mean(mean(image));
    avgR = meanRGB(1);
    avgG = meanRGB(2);
    avgB = meanRGB(3);        
    
    avgRGBCells = gridCellsAvg(image,cellRows,cellColumns);
    avgRCells = reshape(avgRGBCells(:,:,1),1,cellRows*cellColumns);
    avgGCells = reshape(avgRGBCells(:,:,2),1,cellRows*cellColumns);
    avgBCells = reshape(avgRGBCells(:,:,3),1,cellRows*cellColumns);    
%     avgSatCells = reshape(gridCellsAvg(vsh(:,:,2),cellRows,cellColumns),1,cellRows*cellColumns);
%     avgIntCells = reshape(gridCellsAvg(vsh(:,:,1),cellRows,cellColumns),1,cellRows*cellColumns);

elseif size(image,3) == 1
    meanRGB = mean(mean(image));
    avgR = meanRGB(1);
    avgG = meanRGB(1);
    avgB = meanRGB(1);
                
    avgRCells = reshape(gridCellsAvg(image(:,:,1),cellRows,cellColumns),1,cellRows*cellColumns);
    avgGCells = avgRCells;
    avgBCells = avgRCells;    
else
    % OR SOMETHING ELSE?
    meanRGB = mean(mean(image));
    avgR = meanRGB(1);
    avgG = meanRGB(1);
    avgB = meanRGB(1);
                
    avgRCells = reshape(gridCellsAvg(image(:,:,1),cellRows,cellColumns),1,cellRows*cellColumns);
    avgGCells = avgRCells;
    avgBCells = avgRCells;  
end


end