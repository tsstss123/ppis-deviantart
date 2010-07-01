function [salmap, salData] = generateSaliencyMap(img, params)
% Function used to create the saliency map of an image.
% The map is created using the saliency toolbok found in:
% http://www.saliencytoolbox.net/

% inpute values:    [img] = image
%                   [params] = parameters used in the saliency toolbox. For
%                   more information about those parameters look in
%                   function: set_parameters
%
% Created by Davide Modolo 

    Img.data = img;
    Img.size = size(img);
    Img.dims = length(Img.size);
    
    [salmap,salData] = makeSaliencyMap(Img,params);
    
end