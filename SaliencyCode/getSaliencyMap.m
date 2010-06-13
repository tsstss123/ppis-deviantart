function [data] = getSaliencyMap(image_path)
    salmap_name = [image_path '.salmap.jpg'];
    data = imread(salmap_name);
end