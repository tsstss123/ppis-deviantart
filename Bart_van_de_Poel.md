# Research Log #

## 30/06 ##
  * Cleaning up code

## 29/06 ##
  * Finalized report
  * Reviewed and fixed the report with the whole group (lot of hours :P)

## 26/06-28/06 ##
  * Work on report

## 25/06 ##
  * recomputed the intensity and corner ratio features, and added the HSV value feature as "avgVal", "medVal" etc so that nick can use the updated features in his visualization screenshots. (Features added under downloads)
  * worked on report

## 24/06 ##
  * Fixed two bugs in the feature extraction code: corner feature was still the absolute number of corners instead of the corner-pixel ratio. And also found out that the third channel in HSV is not exactly the same as the intensity (but very similar). Added the real intensity channel as a feature, and renamed the third channel of HSV to "value"
  * Had meeting with the group about the contents of the report

## 23/06 ##
  * Finished presentation
  * Did presentation

## 22/06 ##
  * Analysed some of last nights results with quang and davide
  * Worked on presentation

## 21/06 ##
  * Group meeting
  * Helped quang with classifier /experiment code

## 20/06 ##
  * Added a fix for the weibull features to the feature extraction code, because the weibull package returns NaN on a lot of images. Replacing all zero values by a very small positive value seems to fix this.
  * Turns out that the weibull fix doesn't work on all images, so I decided to remove the whole feature from the code since the other components (classifier and visualization) expect the same number of features for each image.
  * removed a small bug from the extraction of the salient points. It wrote a matrix to the xml file instead of a rolled out vector. Now recalculating the features.
  * Wrote a little bit in the report

## 18/06 ##
  * Calculated features for whole dataset
  * Added code for median features for all the HSV and RGB features that only had average features, and added average features to all the ones that only had median.
  * Calculated the new features for the big dataset

## 17/06 ##
  * Changed feature extraction code such that rgb2gray conversion is done only once and then used by all features that need it.
  * Incorporated saliency code into the main loop
  * Added try/catch blocks to handle corrupt images or images that the saliency package cannot handle. The code will now skip these images and remove it's feature file (so basically remove it from the dataset)

## 16/06 ##
  * Added BartB's weibull fit code to the main feature extraction loop
  * Rewrote feature extraction code such that can handle a file structure where the images are seperated bases on the artist. The code reads in the xml files that are created by the scraper en retrieves the artist, category and filename. It stores this in the feature xml together with the feature values so that all information is available to the visualization code.

## 15/06 ##
  * Worked at science park on rewriting gridCode such that it also works on a 3D matrix
  * Attended Lev Manovich's presentation at VKS
  * Added avg RGB  feature
  * Added entropy feature
  * Added variance feature code


## 12/06 ##
  * Used this xml package: http://www.mathworks.com/matlabcentral/fileexchange/4278
  * Rewrote the code such that for each image an xml file is generated that contains the feature. During the feature extraction these xml files are consulted so that only features are calculated that are not yet present for that image, or that have been flagged to be recomputed.
  * Uploaded the code to the downloads section instead of svn (couldnt get it to work). I will make a wiki page tomorrow with the xml format and how to use the toolkit. Code: http://ppis-deviantart.googlecode.com/files/xmlbasedcode.zip


## 11/06 ##
  * Meeting with everyone. Tutorial by Nick
  * Need to rewrite all the code so that the features are stored in XML files. Sent a possible format to everyone, and if they agree on it, I will try to rewrite it this weekend.



## 10/06 ##
  * fixed a small bug in my feature code, because opencv seems to return vsh instead of hsv.
  * put spatial information into the edge ratio feature. Besides the total edge ratio, it now also didvides the edge image into a grid (now set to 3x3 to discriminate between center, corner and top-down/left-right edges, but can handle other amounts of cells) and calculates the edge ratio within each grid cell. It reshapes the matrix containing the ratios for each cell and returns one feature vector. (NOTE: an alternative is to not give the edge ratio within a cell, but the ratio of how much edges there are in this specific cell compared to the entire image).

## 09/06 ##
  * Found a parameters in the facedetect source code that affects how easily something is detected as a face (something about positive neighbours). But even when I set it relatively high it gives a lot of false positives.
  * Created a function that returns the number of detected faces as a feature (might also want to give location). But if the detections are too noisy, we may want to remove this feature.
  * Created function that uses the opencv goodFeaturesForTracking function to detect corners and returns the number of corners in an image.

## 08/06 ##
  * Wasted a couple of hours trying to get the opencv/matlab code that albert sent to work, but it won't compile correctly on mac.
  * Finally works! Turned out to be a small compiler-dependent error in the source code. Tried canny edge, and rgb2hsv and they both were 10-50 times faster then the matlab versions.
  * Rewrote the feature extraction code so that the different feature codes just take one image as input and return the feature(vector) instead of being standalone pieces of code. And replaces builtin matlab functions with opencv functions where possible.
  * Tried the viola and jones face detector. Works, but haven't found out how to give parameters like the confidence threshold yet (otherwise it will give a lot of false positives).

## 07/06 ##
  * We all had a meeting with albert
  * Looked at using opencv from matlab

## 06/06 ##
  * wrote extraction of avg hue, saturation and intensity

## 04/06 ##
  * Meeting with team about research goals and specifics
  * Decided on how to output features and wrote an example feature extractor to extract the edge to non-edge ratio of an image (Note: need to decide on parameters for the canny edge detector). Output is a textfile with a line for each image with the format filename,ratio:
1980\_by\_K1lgore.jpg,0.069953

## 03/06 ##
  * Looked for papers about statistical features
  * Read paper accompanying koen's color description software. Colour descriptions around salient points (or other point sampling technique) are calculated. So for each image there is a list of descriptor vectors (one vector for each sampled point). This list can vary in length. In order to turn this into a fixed length feature vector, the descriptors are compared to a "codebook" which contains a fixed number of elemens. (bag of words model). Each descriptor is assigned to one of the codebook elements, creating a histogram which shows the amount of descriptors in each codebook element (This codebook needs to be created by us using training data?). Finally this histogram is normalized and used as the feature vector.   NOTE: not sure what kind of descriptors we should use for this (they all have different invariance properties, so depends on what kind of invariance we want).
  * Can't run koen's code though. Seems that its not compiled for my OS

## 02/06 ##
  * Had initial meeting about the project and tasks at Science Park
  * My task is the extraction of statistical features
  * Installed ImageJ and looked at some of the features
  * Created research log

## 01/06 ##
  * Project proposal presentation



# Possible features #

  * Avg Intensity / avg Hue
  * Weibull fit parameters
  * Number of edges / edge ratio
  * Corner detection
  * Colour Histograms
  * Codebook vector produced by koen's code

# Implemented features #
  * edge/pixels ratio (also grid version) (now with default parameters) (about 10-50 per second)
  * avg&median hue,saturation,Value,Intensity (also grid version) (about 10-50 per second)
  * number of faces in image (very bad face detection) (processes about 3 images per second)
  * corners pixel ratio in image (also grid version) (5-10 per second)
  * weibull fit  (Bart B.) (Currently not used due to unexplicable bug in the external weibull code)
  * avg&median R,G,B
  * Entropy of intensity
  * Variance of intensity
  * Several saliency features (Davide&Sander)

# TODO #
  * koen's color descriptors? (not very low-level & not intuitive for non-computer-scientists)

# NOTES #
  * not sure whether the opencv mex file expects BGR or RGB as input to the color space conversion method
  * not sure whether to use face detection (noisy), and if so, what parameters

