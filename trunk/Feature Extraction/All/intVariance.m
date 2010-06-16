function intVar = intVariance(image)
    if size(image,3) == 3
        intVar = variance(rgb2gray(image));
    else
        intVar = variance(image(:,:,1));
    end
end