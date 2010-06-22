function pseudoFeatureperArtist( directoryname )
    fprintf('Inside Directory: %s\n', directoryname);
    
    outputfilename = strcat(directoryname, '.txt');
    outputfile = fopen(outputfilename,'w');
    
    files = dir(directoryname);
    
    fileIndex = find(~[files.isdir]);
    
    for i=1:length(fileIndex)
           fileName = files(fileIndex(i)).name;
           path = strcat(directoryname, '\', fileName);
           fprintf('Image: %s\n', path);
        try
            % Read in an image
            rgbimage = imread(path);
            image = rgb2hsv(rgbimage);

            % Extract Color Channels
            h = image(:,:,1);
            s = image(:,:,2);
            v = image(:,:,3);

            % Determine number of pixels
            imagesize = size(image);
            numberofpixels = imagesize(1) * imagesize(2);

            % Compute average hsv
            avgh = sum(sum(h)) / numberofpixels;
            avgs = sum(sum(s)) / numberofpixels;
            avgv = sum(sum(v)) / numberofpixels;

            % Create featurevector in image
            fprintf(outputfile, '%s\t%s\t%f\t%f\t%f\n', fileName, directoryname, avgh, avgs, avgv);
        catch ME
        end
    end
    fclose(outputfile);
end
