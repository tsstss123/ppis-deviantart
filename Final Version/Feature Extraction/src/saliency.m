function [E, Etot, H, P, Sk] = saliency(im,numberPoints)
% File used to extract all the saliency features    

% input values: [im] = image we want to extract the features
%               [numberPoints] = number of most saliency points we want to
%                                retrieve
% Created by Davide Modolo
        
    
    params = set_parameters(im);
    [salMap, salData] = generateSaliencyMap(im, params);
        
    % FEATURE EXTRACTION
        
    % 1 - Entropy of the saliency map
    E = entropy(salMap.data);
    
    % 2 - Entropy of the saliency map + color map + intensity map + skin map + orientation   
    [EC, EI, EO, EK] = getMapsEntropy(salData);
    Etot = E + EC + EI + EO + EK;
        
    % 3 - Standart deviation of the salient distribution
    H = getSalMapHist(salMap.data);
    
    % 4 - Coordinates of the 'numberPoints' most salient part of the image
    P = getMostSalientPoints(salMap, salData, params, numberPoints);
    
    % 5 - Amount of skin coming from the skin map
    Sk = getSkinAmount(salData(4));
        
end