% This function should compute the intensity value of an entire set of
% images inside a directory for n x n-patches that an image is divided into.
function [observationmatrix] = HueFeature(directoryname)

    files = dir(directoryname);
    
    fileIndex = find(~[files.isdir]);
    
    observationmatrix = zeros(1, 2);
    
    for i=1:length(fileIndex)
       fileName = files(fileIndex(i)).name;
       path = strcat(directoryname, '\', fileName);
       try
           
           rgbimage = imread(path);
           image = rgb2hsv(rgbimage);
          

           % Extract Color Channels
           h = image(:,:,1);
           s = image(:,:,2);
           
           % Convert to uint16 to support numbers higher than 255 and
           % compute the Intensity value on the entire image.
           uint16h = uint16(h);
           uint16s = uint16(s);
           
           [height, width] = size(image);
           pixels = height * width;
           
           avghue = sum(sum(uint16h)) / pixels;
           avgsat = sum(sum(uint16s)) / pixels;

           % Create a feature vector
           imagevector = [avghue, avgsat];
          
           path
           
           %Add to the observation Matrix for SVM         
           observationmatrix(end+1,:) = imagevector;
      catch
         fileName
      end
    end
    observationmatrix(1,:) = [];
end
