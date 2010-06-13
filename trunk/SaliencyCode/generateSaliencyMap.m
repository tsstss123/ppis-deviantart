function generateSaliencyMap(image_name)
    % Generate saliency map
    img = initializeImage(image_name);

    % Default params
    params = defaultSaliencyParams(img.size,'dyadic');
    
    % Customize
    params.normtype = 'None'; 
    params.features = {'Color','Intensities','Orientations','Skin'};
    params.weights = [1 1 1 1];
    
    [salmap,salData] = makeSaliencyMap(img,params);
    
    % Write away
    output_name = [image_name '.salmap'];
    imwrite(salmap.data, output_name, 'jpg');
    
    for i=1:length(salData)
        output_name = [image_name '.' salData(i).label];
        imwrite(salData(i).CM.data, output_name, 'jpg');
    end
end