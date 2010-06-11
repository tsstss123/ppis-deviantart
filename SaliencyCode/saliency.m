%function saliency()
    addpath(genpath('../SaliencyToolbox'));
    
    path = {'images/animals/','images/famous/', ...
        'images/carthoon/','images/photo/','images/paint/'} ;
    extension = '.jpg';
   
    for i=1:size(path,2)
        for j=1:5
            imagestr{i+(j-1)*5,1} = horzcat(path{j},int2str(i),extension);
        end
    end
    
    
    matrix = zeros(size(imagestr,1),size(imagestr,1));
    for i=1:size(imagestr,1)
        for j=1:size(imagestr,1)
            if ~((j<i)||(i==j)) 
                matrix(i,j) = getSimilaritySalMapDiff(imagestr{i}, imagestr{j});
                fprintf('\nSIMILARITY BETWEEN IMAGE %d AND IMAGE %d HAS BEEN COMPUTED', i,j)
            end
        end
    end
%end