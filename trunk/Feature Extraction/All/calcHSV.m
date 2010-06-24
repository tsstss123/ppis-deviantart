function [medianHue,medianSat,medianVal,avgHue,avgSat,avgVal,medHueCells,medSatCells,medValCells,avgHueCells,avgSatCells,avgValCells] = calcHSV(vsh)
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
            medianVal = median(reshape(vsh(:,:,1),1,size(vsh,1)*size(vsh,2)));
            
%             avgHue = means(3);                        
            avgHue = meanVSH(3);
            avgSat = meanVSH(2);
            avgVal = meanVSH(1);
                        
            medHueSatValCells = gridCellsMedian(vsh(:,:,1:3),cellRows,cellColumns);
            medHueCells = reshape(medHueSatValCells(:,:,3),1,cellRows*cellColumns);
            medSatCells = reshape(medHueSatValCells(:,:,2),1,cellRows*cellColumns);
            medValCells = reshape(medHueSatValCells(:,:,1),1,cellRows*cellColumns);            
            avgValSatHueCells = gridCellsAvg(vsh(:,:,1:3),cellRows,cellColumns);
            avgValCells = reshape(avgValSatHueCells(:,:,1),1,cellRows*cellColumns);
            avgSatCells = reshape(avgValSatHueCells(:,:,2),1,cellRows*cellColumns);
            avgHueCells = reshape(avgValSatHueCells(:,:,3),1,cellRows*cellColumns);    
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