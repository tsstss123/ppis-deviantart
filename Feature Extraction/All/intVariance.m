function intVar = intVariance(greyImage)
%     if size(image,3) == 3
        intVar = variance(greyImage);
%     else
%         intVar = variance(image(:,:,1));
%     end
end