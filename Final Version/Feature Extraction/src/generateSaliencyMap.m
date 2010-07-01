function [salmap, salData] = generateSaliencyMap(img, params)
    
    Img.data = img;
    Img.size = size(img);
    Img.dims = length(Img.size);
    
    [salmap,salData] = makeSaliencyMap(Img,params);
    
end