function [data] = getSaliencyMap(image_path)

    img = initializeImage(image_path);

    params = defaultSaliencyParams(img.size,'dyadic');
    
    params.features = {'Color','Intensities','Orientations','Skin'};
    params.weights = [1 1 1 1];
    
    %params.features = {'Skin'};
    %params.weights = [1];

    [salmap,salData] = makeSaliencyMap(img,params);
    
    %data = salmap.data;
    
    % initialize the winner-take-all network
    wta = initializeWTA(salmap,params);
    %wtaMap = emptyMap(img.size(1:2),'Winner Take All');
    %wtaMap.data = imresize(wta.sm.V,img.size(1:2),'bilinear');
    
    winner = [-1,-1];

    % evolve WTA until we have a winner
    while (winner(1) == -1)
        [wta,winner] = evolveWTA(wta);
    end
      
    wtaMap = emptyMap(img.size(1:2),'Winner Take All');
    wtaMap.data = imresize(wta.sm.V,img.size(1:2),'bilinear');      

    data = wtaMap.data;
end