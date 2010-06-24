function [cornerRatio,cornerRatioGrid] = detectCorners(image)
    cellRows = 3;
    cellColumns = 3;
    
    corners = cvlib_mex('goodfeatures',image);
%     imshow(image);
%     hold on;
%     scatter(corners(:,1),corners(:,2));
%     hold off;
    cornerRatio = size(corners,1)/(size(image,1)*size(image,2));
    
    cornerRatioGrid = gridCorners(size(image),corners,cellRows,cellColumns);
    cornerRatioGrid = reshape(cornerRatioGrid',1,cellRows*cellColumns);
    
    
    
    
    
end

function ratioGrid = gridCorners(imageSize, corners,X,Y)
    xSize = imageSize(1);
    ySize = imageSize(2);
    xCellSize = round(xSize / X);
    yCellSize = round(ySize / Y);
    
    ratioGrid = zeros(X,Y);
    for i = 1:X
       for j = 1:Y
           startPixelX = ((i-1)*xCellSize)+1;
           startPixelY = ((j-1)*yCellSize)+1;                       
           
           % Because final row and column might nog have exactly the same
           % cellsize
           if(i == X)
               endPixelX = xSize;               
           else
               endPixelX = startPixelX+xCellSize;
           end
           if(j == Y)
               endPixelY = ySize;
           else
               endPixelY = startPixelY+yCellSize;
           end
           
           %Dimensions in the corner matrix returned by openCV are flipped.
           cellCorners = sum((corners(:,2) >= startPixelX) & (corners(:,2) < endPixelX) ...
               & (corners(:,1) >= startPixelY) & (corners(:,1) < endPixelY));
           ratioGrid(i,j) = cellCorners / (xCellSize*yCellSize);
           
%            avgGrid(i,j) = mean(mean(matrix(startPixelX:endPixelX,startPixelY:endPixelY) ));
       end

    end   
    
    
    


end