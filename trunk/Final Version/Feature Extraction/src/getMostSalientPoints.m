function [coordinates] = getMostSalientPoints(salmap, salData, params, n)
% Function used to find the n most saliency point of the saliency map
% It runs the winner-take-all (WTA) process (used also in a previous step to
% compute the saliency map) and at each step:
% - it finds the most salient point;
% - it stores it;
% - it inhibit it;
% - it runs again the process and compute the next most salienct points
% until it has retrieved n points.

% input value:  [salmap] =  structure used to store the saliency map and
%                           its information (such as. dimension, etc. etc.)

%               [salData] = structure used to store the four conspicuity maps and their
%                           information (such as. dimension, etc. etc.)

%               [params] =  parameters used in the saliency toolbox. For
%                           more information about those parameters look in
%                           function: set_parameters

%               [n] =       number of most salient points we want to
%                           retrieve

% Created by Davide Modolo 
   
    wta = initializeWTA(salmap,params);
    
   for i=1:n
       winner = [-1,-1];
       
       % evolve WTA until we have a winner
       while (winner(1) == -1)
            [wta,winner] = evolveWTA(wta);
       end
       
       shapeData = estimateShape(salmap,salData,winner,params);
       
       % trigger inhibition of return
       wta = applyIOR(wta,winner,params,shapeData);
       
       % convert the winner's location to image coordinates
       coordinates(i,:) = winnerToImgCoords(winner,params);
       
       % normalize to image dimension
       coordinates(i,:) = coordinates(i,:)./salmap.origImage.size([1:2]);
   end
    
    
end