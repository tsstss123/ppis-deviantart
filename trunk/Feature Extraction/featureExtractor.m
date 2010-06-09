function features = featureExtractor(images, featurelist)
%FEATUREEXRACTOR extracts FEATURES from IMAGES
% FEATURES = |FEATURELIST|*m cell feature array
% IMAGES = 1*m array of images
% FEATURELIST = int list(vector) of features to be extracted
%
% Created by: bjbuter

features = cell(3, length(images));
featurelist = sort(featurelist);
for i = [1:length(images)]
    list = featurelist;
    im = rgb2gray(images{i});
    if (numel(list)~= 0) & (list(1) == 1) 
        disp(' ') 
        disp('Feature: Weibull Maximum Likelihood Estimation')
        list = list(2:end);
        [scale shape location] = weibullMle(im, 0, 0); % for raw data
        fprintf('scale = %g, shape = %g, location = %g for raw data\n', scale, shape, location);
        features(1,i) = {[scale, shape, location]};
    end
    if (numel(list)~= 0) & (list(1) == 2)
        disp(' ') 
        disp('Feature: integrated Weibull Makimum Likelihood Estimation')
        list = list(2:end);
        [scale shape location] = integWeibullMle(im, 'x', 1, 0); % for raw data
        fprintf('scale = %g, shape = %g, location = %g for raw data\n', scale, shape, location);
        features(2,i) = {[scale, shape, location]};
    end
    if (numel(list)~= 0) & (list(1) == 3)
        disp(' ') 
        disp('Feature: bla')
        list = list(2:end);
    end
end