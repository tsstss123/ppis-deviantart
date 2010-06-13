function [data] = getSaliencyMap(image_path)
    salmap_name = [image_path '.salmap'];
    data = imread(salmap_name);
end