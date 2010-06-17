function [E, Etot, H, P, Sk] = saliency()

    addpath(genpath('../SaliencyToolbox'));
    
    % number of most saliency points
    numberPoints = 3;
    
    
    
        path = {'../images/animals/','../images/famous/', ...
            '../images/carthoon/','../images/photo/','../images/paint/'} ;
        extension = '.jpg';
   
        for i=1:size(path,2)
            for j=1:5
                imagestr{i+(j-1)*5,1} = horzcat(path{j},int2str(i),extension);
            end
        end

        
    
    im = imread(imagestr{i});
    
    params = set_parameters(im);
    [salMap, salData] = generateSaliencyMap(im, params);
        
    % FEATURE EXTRACTION
        
    % 1 - Entropy of the saliency map
    E = entropy(salMap.data);
    
    % 2 - Entropy of the saliency map + color map + intensity map + skin map   
    [EC, EI, EO, EK] = getMapsEntropy(salData);
    Etot = E + EC + EI + EO + EK;
        
    % 3 - Standart deviation of the salient distribution
    H = getSalMapHist(salMap.data);
    
    % 4 - Coordinates of the 'numberPoints' most salient part of the image
    P = getMostSalientPoints(salMap, salData, params, numberPoints);
    
    % 5 - Amount of skin coming from the skin map
    Sk = getSkinAmount(salData(4));
        
end