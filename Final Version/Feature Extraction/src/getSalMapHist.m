function [histogram] = getSalMapHist(salMap)

    % Build histograms
    B = 50;
    [count1, x1] = imhist(salMap, B);
    
    % Normalize the histogram
    histogram = count1./sum(count1);
    
    % Compute the standard deviation
    histogram = std(histogram);
end