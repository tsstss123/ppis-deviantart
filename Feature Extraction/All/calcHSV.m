function [medianHue,avgSat,avgInt,medHueCells,avgSatCells,avgIntCells] = calcHSV(image)
cellRows = 3;
cellColumns = 3;
        if size(image,3) == 3
            % the usage string of the cvlib mex calls it rgb2hsv, but
            % opencv calls it bgr2hsv. Maybe need to convert image to BGR
            % before passing to opencv
            
            % opencv seems to return vsh
            vsh = cvlib_mex('color',image,'rgb2hsv');
            meanVS = mean(mean(vsh(:,:,1:2)));            
            medianHue = median(reshape(vsh(:,:,3),1,size(vsh,1)*size(vsh,2)));
%             avgHue = means(3);                        
            avgSat = meanVS(2);
            avgInt = meanVS(1);
                        
            medHueCells = reshape(gridCellsMedian(vsh(:,:,3),cellRows,cellColumns),1,cellRows*cellColumns);
            avgIntSatCells = gridCellsAvg(vsh(:,:,1:2),cellRows,cellColumns);
            avgIntCells = reshape(avgIntSatCells(:,:,1),1,cellRows*cellColumns);
            avgSatCells = reshape(avgIntSatCells(:,:,2),1,cellRows*cellColumns);    
%             avgSatCells = reshape(gridCellsAvg(vsh(:,:,2),cellRows,cellColumns),1,cellRows*cellColumns);
%             avgIntCells = reshape(gridCellsAvg(vsh(:,:,1),cellRows,cellColumns),1,cellRows*cellColumns);
            
        elseif size(image,3) == 1
            medianHue = 0;
            avgSat = 0;
            avgInt = mean(mean(image(:,:,1)));
            medHueCells = zeros(1,cellRows*cellColumns);
            avgSatCells = zeros(1,cellRows*cellColumns);
            avgIntCells = reshape(gridCellsAvg(image(:,:,1),cellRows,cellColumns),1,cellRows*cellColumns);
            
        else
            % OR SOMETHING ELSE?
            medianHue = 0;
            avgSat = 0;
            avgInt = 0;
            medHueCells = zeros(1,cellRows*cellColumns);
            avgSatCells = zeros(1,cellRows*cellColumns);
            avgIntCells = zeros(1,cellRows*cellColumns);            
        end
end