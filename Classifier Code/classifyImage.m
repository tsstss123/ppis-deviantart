function [ output ] = classifyImage( typeofclassifier, trainedclassifier, imagepath)

    % Compute\Load Features for the image
    fprintf('Creating Feature vector\n');
    Featurevector = pseudoFeature(imagepath);
    
    % Choose the classifier
    if strcmp('SVM', typeofclassifier)
       fprintf('Using SVM\n\n');
       output = svmclassify(trainedclassifier, Featurevector);
       fprintf('Class %s: %s\n', output{1}, imagepath);
    end

end