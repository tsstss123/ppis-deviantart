function [ observationmatrix ] = pseudotrainClassifier(directoryname)
    fprintf('Inside Directory: %s\n', directoryname);
    files = dir(directoryname);
    
    fileIndex = find(~[files.isdir]);
    
    observationmatrix = zeros(1, 3);
    
    for i=1:length(fileIndex)
           fileName = files(fileIndex(i)).name;
           path = strcat(directoryname, '\', fileName);
           fprintf('Processing file %s\n', fileName);
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
            avgh = sum(sum(uint16(h))) / numberofpixels;
            avgs = sum(sum(uint16(s))) / numberofpixels;
            avgv = sum(sum(uint16(v))) / numberofpixels;

            % Create featurevector
            featurevector = [avgh, avgs, avgv];
            observationmatrix = cat(1,observationmatrix, featurevector);
        catch ME
            fprintf('Unable to access file %s\n', fileName);
        end
    end
    observationmatrix(1,:) = [];


end

