function [params] = set_parameters(im)
% Function used to set the parameters to pass to the toolbox that will be
% used to create the saliency map. The toolbox used is the one available
% in: http://www.saliencytoolbox.net/

% input values: [im] = image we want to create the saliency map

% Created by Davide Modolo

    % Default params
    params = defaultSaliencyParams(size(im),'dyadic');
    
    % Customize
    
    % Type of normalization
    params.normtype = 'None'; 
    
    % List of conspicuity maps we want to use to compute the saliency map
    params.features = {'Color','Intensities','Orientations','Skin'};
    
    % Waight we give to the 4 conspicuity maps
    params.weights = [1 1 1 1]; 
    
end