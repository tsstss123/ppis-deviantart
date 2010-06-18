function [medianHue,medianSat,medianInt,avgHue,avgSat,avgInt,medHueCells,medSatCells,medIntCells,avgHueCells,avgSatCells,avgIntCells] = calcHSV(vsh)
cellRows = 3;
cellColumns = 3;
%         if size(image,3) == 3
            % the usage string of the cvlib mex calls it rgb2hsv, but
            % opencv calls it bgr2hsv. Maybe need to convert image to BGR
            % before passing to opencv
            
            % opencv seems to return vsh
%             vsh = cvlib_mex('color',image,'rgb2hsv');
            meanVSH = mean(mean(vsh(:,:,1:3)));            
            medianHue = median(reshape(vsh(:,:,3),1,size(vsh,1)*size(vsh,2)));
            medianSat = median(reshape(vsh(:,:,2),1,size(vsh,1)*size(vsh,2)));
            medianInt = median(reshape(vsh(:,:,1),1,size(vsh,1)*size(vsh,2)));
            
%             avgHue = means(3);                        
            avgHue = meanVSH(3);
            avgSat = meanVSH(2);
            avgInt = meanVSH(1);
                        
            medHueSatIntCells = gridCellsMedian(vsh(:,:,1:3),cellRows,cellColumns);
            medHueCells = reshape(medHueSatIntCells(:,:,3),1,cellRows*cellColumns);
            medSatCells = reshape(medHueSatIntCells(:,:,2),1,cellRows*cellColumns);
            medIntCells = reshape(medHueSatIntCells(:,:,1),1,cellRows*cellColumns);            
            avgIntSatHueCells = gridCellsAvg(vsh(:,:,1:3),cellRows,cellColumns);
            avgIntCells = reshape(avgIntSatHueCells(:,:,1),1,cellRows*cellColumns);
            avgSatCells = reshape(avgIntSatHueCells(:,:,2),1,cellRows*cellColumns);
            avgHueCells = reshape(avgIntSatHueCells(:,:,3),1,cellRows*cellColumns);    
%             avgSatCells = reshape(gridCellsAvg(vsh(:,:,2),cellRows,cellColumns),1,cellRows*cellColumns);
%             avgIntCells = reshape(gridCellsAvg(vsh(:,:,1),cellRows,cellColumns),1,cellRows*cellColumns);
            
%         elseif size(image,3) == 1
%             medianHue = 0;
%             avgSat = 0;
%             avgInt = mean(mean(image(:,:,1)));
%             medHueCells = zeros(1,cellRows*cellColumns);
%             avgSatCells = zeros(1,cellRows*cellColumns);
%             avgIntCells = reshape(gridCellsAvg(image(:,:,1),cellRows,cellColumns),1,cellRows*cellColumns);
%             
%         else
%             % OR SOMETHING ELSE?
%             medianHue = 0;
%             avgSat = 0;
%             avgInt = 0;
%             medHueCells = zeros(1,cellRows*cellColumns);
%             avgSatCells = zeros(1,cellRows*cellColumns);
%             avgIntCells = zeros(1,cellRows*cellColumns);            
%         end
end