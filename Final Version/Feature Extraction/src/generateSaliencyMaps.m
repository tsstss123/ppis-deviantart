function generateSaliencyMaps(folder)
    listing = dir(folder);
    
    for i = 1:numel(listing)
        [pathstr, name, ext, versn] = fileparts(listing(i).name);
        fullpath = [folder '/' name ext];
        if listing(i).isdir == 1 || (strcmp(ext, '.jpg') == false && strcmp(ext, '.png') == false && strcmp(ext, '.bmp') == false)
            continue
        end
        generateSaliencyMap(fullpath);
    end
end