function intVar = intVariance(image)
% function that takes a greyscale image as input and returns the variance
% of the intensity (single value)
%
% Created by Bart van de Poel

    intVar = var(reshape(double(image),1,size(image,1)*size(image,2)));
end