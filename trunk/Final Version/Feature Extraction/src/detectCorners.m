function [cornerRatio,cornerRatioGrid] = detectCorners(image)
% function that takes an RGB image as input and returns the corner to pixel
% ratio for the entire image (single value) as well as for each part of 
% the image (1x9 array: 1 value for each cell of a 3x3 grid). The corners
% are detected using the opencv goodFeaturesToTrack function that performs
% cornerdetection.
%
% [cornerToPixelRatio,cornerToPixelRatioGrid = detectCorners(RGB_image)
%
% Created by Bart van de Poel

    % number of rows and columns for the grid used to calcualte
    % compositional features
    cellRows = 3;
    cellColumns = 3;
    
    % opencv function that returns an Nx2 matrix with the corner coordinates
    % on each row, with N being the number of corners.  
    corners = cvlib_mex('goodfeatures',image);

    % Piece of code to plot the image together with the detected corners
    % (corners plotted as circles)
    % imshow(image);
    % hold on;
    % scatter(corners(:,1),corners(:,2));
    % hold off;
    
    cornerRatio = size(corners,1)/(size(image,1)*size(image,2));    
    cornerRatioGrid = gridCorners(size(image),corners,cellRows,cellColumns);
    % reshape the returned 3x3 matrix to a 1x9 feature vector
    cornerRatioGrid = reshape(cornerRatioGrid',1,cellRows*cellColumns);
        
end

function ratioGrid = gridCorners(imageSize, corners,X,Y)
% helper function that determines the corner to pixel ratio in each part of
% the image by dividing it into an XxY grid of subimages.
% It takes the detected corners as input, together with the image size and
% the number of rows and columns that will be used for the grid. It returns
% and XxY matrix containing the ratios for each part of the image.


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
           % cellsize due to rounding
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
       end

    end   
    
    
    


end