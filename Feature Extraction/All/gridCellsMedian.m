% input: 
% matrix is an NxM matrix.
% X is the amount of cells into which the matrix needs to be split in the
% first
% dimension. Y is the amount of cells into which the matrix needs to be
% split in the second dimension
% output: matrix containing the median value of each grid cell
function medianGrid = gridCellsMedian(matrix,X,Y)
    xSize = size(matrix,1);
    ySize = size(matrix,2);
    xCellSize = round(xSize / X);
    yCellSize = round(ySize / Y);
    channels = size(matrix,3);
    
    medianGrid = zeros(X,Y,channels);
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
           % turn matrix into one large vector and take median. If you take median(median(matrix)) you get 
           % other values
           subMatrix = matrix(startPixelX:endPixelX,startPixelY:endPixelY,:);
%            reshape(subMatrix,1,size(subMatrix,1)*size(subMatrix,2),channels) 
%            median(reshape(subMatrix,1,size(subMatrix,1)*size(subMatrix,2),channels) )
           medianGrid(i,j,1:channels) = median(reshape(subMatrix,1,size(subMatrix,1)*size(subMatrix,2),channels) );
       end

    end            

end