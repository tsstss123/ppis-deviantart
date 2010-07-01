function avgGrid = gridCellsAvg(matrix,X,Y)
% input: matrix,X,Y
% matrix is an NxMxC matrix. X is the amount of cells into which the matrix 
% needs to be split in the first dimension. Y is the amount of cells into which 
% the matrix needs to be split in the second dimension
% output: XxYxC matrix containing the avg of each grid cell for each channel
%
% gridAvg = gridCellsAvg(matrix,X,Y)
%
% Created by Bart van de Poel

    xSize = size(matrix,1);
    ySize = size(matrix,2);
    xCellSize = round(xSize / X);
    yCellSize = round(ySize / Y);
    channels = size(matrix,3);
    
    avgGrid = zeros(X,Y,channels);
    for i = 1:X
       for j = 1:Y
           startPixelX = ((i-1)*xCellSize)+1;
           startPixelY = ((j-1)*yCellSize)+1;                       
           
           % Because final row and column might nog have exactly the same
           % cellsize
           if(i == X)
               endPixelX = size(matrix,1);               
           else
               endPixelX = startPixelX+xCellSize;
           end
           if(j == Y)
               endPixelY = size(matrix,2);
           else
               endPixelY = startPixelY+yCellSize;
           end                      
           
           avgGrid(i,j,1:channels) = mean(mean(matrix(startPixelX:endPixelX,startPixelY:endPixelY,1:channels) ));
       end

    end            

end