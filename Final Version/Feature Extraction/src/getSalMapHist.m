function [histogram] = getSalMapHist(salMap)
% File used to compute the standard deviation of the saliency distribution
% in the saliency map

% input values: [salmap] =  structure used to store the saliency map and
%                           its information (such as. dimension, etc. etc.)

% Created by Davide Modolo

    % Build histograms
    B = 50;
    [count1, x1] = imhist(salMap, B);
    
    % Normalize the histogram
    histogram = count1./sum(count1);
    
    % Compute the standard deviation
    histogram = std(histogram);
end