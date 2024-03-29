% Maximum likelihood estimation of parameters for Weibull data.
% Function fits a Weibull distribution to a Gaussian gradient with 
% sigma equals 3 of gray-scale image or patch of image.
% Scale and shape parameters are fitted with the maximum likelihood framework,
% and location parameter is approximated with median value of data
% As inputs the following variables have to be transferred:
% data        : 2-dimensional matrix with gray-scale image,
%               can be obtained as
%               data = im2double(rgb2gray(imread(image_file_name)));
% useHist     : boolean variable to set of using histogram of input
%               data for MLE of parameters or raw data. Possible values
%               are 0 - raw data; 1 - histogram of data. In a histogram
%               case number of bins equals to 1001.
% doPlot      : boolean variable to visualize the results
% Return values are scale, shape and location parametes of fitted
% Weibull distribution.
% Example of use:
% [scale shape location] = weibullMle(data, 1, 1);
function [scale shape location] = weibullMle(im, useHist, doPlot)

sigma = 3; % sigma value for Gaussian gradient
gaussDerivative = gaussianFilter(im, 'grad', sigma);
data = gaussDerivative(:)';
location = median(data);

if (useHist)
    %   build histogram for increasing calculation speed
    nBins = 1001; % number of bins in histogram
    [ax h] = createHist(data, nBins);
    [scale shape] = weibullMleHist(ax, h);
else
    [scale shape] = weibullMleRaw(data);
end

% plotting *******************************************
if (doPlot)
    % build histogram if it doesn't exist yet
    figure;
    % build histogram for visualization, here number of bins is
    % independent on nBins

    numBins = 1000;
    delta = (max(data) - min(data))/numBins;
    range = (min(data) : delta : max(data));
    visualizationHist = hist(data, range); % now we allow zero bins in histogram
    % histogram normalization
    visualizationHist = visualizationHist./sum(visualizationHist.*delta);

    % calculate pdf with estimated parameters
    wpdf = weibullPdf(scale, shape, range);
    
    subplot(2,2,[1 2])
    colormap(gray);
    imagesc(im);
    title('Input image');

    subplot(2,2,3)
    colormap(gray);
    imagesc(gaussDerivative);
    title('Gaussian derivative of input image');

    subplot(2,2,4)
    plot(range, visualizationHist, 'r', range, wpdf, 'k')
    title('Normalized histogram (red) and PDF with estimated params (black)');
 
end
% plotting *******************************************

function [ax h] = createHist(data, hBins)

iBin = [1:hBins];
h = hist(data, hBins);
% value of the difference between bins
delta = (max(data) - min(data))/(hBins);
ax = ((min(data) + iBin.*delta) + (min(data) + (iBin-1).*delta))/2;

%skip all values, which are not presented in histogram
ind = find(h);
h = h(ind);
ax = ax(ind);