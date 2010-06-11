function [sim] = getSimilaritySalMapHist(img1_name, img2_name)

    img1 = getSaliencyMap(img1_name);
    img2 = getSaliencyMap(img2_name);
    
    % Build histograms
    [count1, x1] = imhist(img1);
    [count2, x2] = imhist(img2);
    
    % Normalize
    count1 = count1/sum(count1);
    count2 = count2/sum(count2);
   
    % Sim based on count difference
    sim = sum(abs(count1-count2));
end