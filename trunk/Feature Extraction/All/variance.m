function variance = variance(image)
    means = mean(mean(image));
    meansMat = repmat(means,size(image,1),size(image,2));
%     imgSub = zeros(size(image));
%     doubleImage = double(image);
%     for i = 1:size(means,3)
%         imgSub(:,:,i) = doubleImage(:,:,i)-means(i);
%     end
    double(image) - meansMat;
    imgSub = double(image)-meansMat;
    variance = mean(mean(imgSub.*imgSub));    
end