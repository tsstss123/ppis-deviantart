function intEnt = intEntropy(greyImage)
%     if size(image,3) == 3
%        greyImage = rgb2gray(image);
       intEnt = entropy(greyImage);
%     else
%        intEnt = entropy(image(:,:,1)); 
%     end
end