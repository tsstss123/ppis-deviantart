function [sim] = getSimilaritySalMapDiff(img1_name, img2_name)

    img1 = getSaliencyMap(img1_name);
    img2 = getSaliencyMap(img2_name);
    
    % TODO: Use a better way to match the image dimensions?
    img1 = imresize(img1, [100 100]);
    img2 = imresize(img2, [100 100]);
    
    sim = (sum(sum(imabsdiff(img1,img2))));
end