function [params] = set_parameters(im);

    % Default params
    params = defaultSaliencyParams(size(im),'dyadic');
    
    % Customize
    params.normtype = 'None'; 
    params.features = {'Color','Intensities','Orientations','Skin'};
    params.weights = [1 1 1 1]; 
    
end