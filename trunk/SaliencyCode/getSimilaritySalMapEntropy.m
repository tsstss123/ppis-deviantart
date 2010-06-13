function [sim] = getSimilaritySalMapHist(img1_name, img2_name)

    img1 = getSaliencyMap(img1_name);
    img2 = getSaliencyMap(img2_name);
    
    sim = Entropy(img1) - Entropy(img2);
end