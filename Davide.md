## 29/06/2010 ##
  * Worked on the report
    * Experiments, conclusion & Abstract
  * Reviewed the entire report with the group
  * After 9 hours of discussion the final report was ready to be delivered!!!  GREAT JOB GUYS!!! :)

## 28/06/2010 ##
  * Proposed to Albert the current version of the report.
  * Changed the structure of the report following his advices
  * Worked on the report
    * Data collection
    * Classification

## 27/06/2010 ##
  * Worked on the report
    * Reviewed everything done so far

## 26/06/2010 ##
  * Worked on the report
    * Feature extraction
    * Future work

## 25/06/2010 ##
  * Worked on the report
    * Introduction
    * Cognitive-inspired feature

## 24/06/2010 ##
  * Started working on the final report

## 23/06/2010 ##
  * Worked with the presentation:
    * Merged all the parts
    * Reviewed the slides
    * Discussed about it with the others
    * Divided the presentation's parts withing the group members
  * Presented the project

## 22/06/2010 ##
  * Tried to analyze the new results:
    * Some users has few images and weighting positive and negative predictions with the same value brings, in these cases, the classifier to classify everything as negative. Therefore the weighs have been changes (the positive one have been increased)
    * Some results are quite significant: a nude photograph has similarities only with an other nude's photograph and with a user with a lot of portraits (faces and bodies).
  * Prepared the slides for the part of the presentation about the cognitive features

## 21/06/2010 ##
  * Discussed with Albert and the group about the presentation
  * Found images from devianArt webpage and computed their saliency maps. Those images (and their saliency maps) are good to explain the cognitive features during the presentation.
  * Helped Quang with the classification:
    * Used 5-fold cross validation to choose the classifier (SVM)
    * Used 5-fold cross validation to set the slack variable of the SVM
    * Changed a bit the code to be able to do a 1vs1 users classification
    * Now the code is ready to classify 1vs1 all the users and to store their results (F-Measure)
    * Quang will run the code during the night


## 18/06/2010 ##
  * Written the code to classify images using the libsvm (http://www.csie.ntu.edu.tw/~cjlin/libsvm/) of Chih-Chung Chang and Chih-Jen Lin. It is written in C and it is much faster than the prTools.
  * Written the code to compute F-Measure
  * Written the code to plot a Precision-Recall curve


## 16/06/2010 ##
  * Written the code to extract **few features** from the saliency maps and the related maps (color, intensity, orientation and skin):
    * entropy of the saliency map (done the previous day)
    * the sum of all the entropy values coming from the five maps
    * standard deviation of the saliency distribution in the saliency map
    * the few most salient points (to get them some function from the Toolbox have been re-written and a WTA (winner takes all) competition using IOR (inhibition of return) has been implemented)
    * amount of skin
  * Changed all the code in Bart's format, so it can be easily incorporate and ready to be computed.

## 15/06/2010 ##
  * Meeting with the group to list all the possible features
  * Discussed experiment approaches (dataset).
  * Written the code to extract entropy as feature from the saliency maps
  * Attended Lev's presentation

## 11/06/2010 ##
  * Attended Nick's tutorial about processing
  * Discussed with Albert and Sender about cognitive features
    * PCA?  It requires to pre-compute a special amount of data, so it is probably not appropriate for our purpose.
  * Written some new code and fixed some old ones, to read and write XML from Matlab. It could hopefully be useful to Bart.

## 10/06/2010 ##
Read the paper: _"**Adding texture to color: quantitative analysis of color emotions**"_ of Marcel P. Lucassen, Theo Gevers, Arjan Gijsenij
  * In the paper they describe some experiment where subjects ordered samples along four scales: Warm-Cool, Masculine-Feminine, Hard-Soft and Heavy-Light. Three sample types were used: uniform color, grayscale textures and color textures.
  * **Thought**: I have no idea about how these experiments and their results can be useful in our project

Read the paper: _"**Emotion-Based Textile Indexing Using Colors and Texture**"_ of Eun Yi Kim, Soo-jeong Kim, Hyun-jin Koo, Karpjoo Jeong, and Jee-in Kim
  * The paper present an approach for labeling images using human emotion or feeling and shows its affirmative results.
  * The proposed system is composed of physical feature extraction and fuzzy-rule based evaluation.
  * The considered physical features are: colors and textures. First, each feature is independently investigated against human emotion and then their combinations against it.

It could be interesting to try to extract some emotional features from color and texture.

## 09/06/2010 ##
  * Searched for ways to compare two different saliency maps.
    * Read few papers talking about using binary classification and cross-validation to choose which feature are discriminant to a given dataset. The method is probably not useful for DevianArt where there are images completely different.
  * **Important question**: does a saliency map have enough information to discriminate images into categories??
  * **Thought**: a saliency map can be useful to understand what user likes, such as if he/she tends to have the subject of the image in the center or in an other position, or if the subject is usually close to the camera or far away from it. But, if a user has few pictures and with different subjects in different locations/distances from the camera, saliency map can not be useful to discriminate.


## 08/06/2010 ##
  * Worked with Sander about finding similarity between two images using their saliency maps. We used the 25 images downloaded yesterday (5 for each style).
  * **Approaches tried**:
    * The subtraction of the saliency maps of two images. This subtraction assigns good similarity to images that have saliency points located in the same part of the image. The _results_ have shown that this idea, applied alone, is not discriminant to divide the images in styles. Tacking into account only the exact location of a saliency object is not enough, because the same object could appear in a different location of the image, or in a different scale/size.
    * The comparison of the distribution of the saliency in the images. Every saliency map can be seen as a vector of features, and counting them it is easy to create the histogram of the saliency map. Then it is easy to compare two histograms of two different saliency maps. The _results_ are again not really interesting. It discriminates images that have few saliency points from images that have a lot of them, but it is not useful to discriminate images into styles.

  * **Ideas & Issue**:
    * Try also to define a circle of a certain radius around a saliency point/object of a map, and then see if the second image contain it two. In this way we consider the "shape" of the saliency point/object, but we loose the location information.
    * Combine the previous three ideas (the two implemented and the circle one) to see if they discriminate better. **But how?**


## 07/06/2010 ##
  * Installed and added the image processing toolbox to my Matlab
  * Downloaded the Dirk Walther's implementation of Itti's model at: http://www.saliencytoolbox.net/
  * Read the documentation about the toolbox
  * Played with the toolbox for simple images that were already proposed

  * Attended the meeting with Albert
  * Discussed about image and feature representation

  * Downloaded 25 images from DevianArt. Images "represent" 5 different styles and each style has 5 images associated.
  * Played with the toolbox with these new images.
  * Tries:
    * give different weights to color, intensity and orientations
    * iterate different times using IOR and see how the different maps changes
    * not tried yet different pyramid level

## 04/06/2010 ##
Read the paper: _"**Computational modeling of visual attention**"_ of Laurent Itti and Christo Kock.
  * In the paper they present a general overview and some recent work on **computational models of focal visual attention**. _Five trends_ have emerged from the work:
    * the perceptual saliency of stimuli critically depends on the surrounding context.
    * a unique saliency map that topographically encodes for stimulus perspicuity over the visual scene has proved to be an efficient an plausible bottom-up control strategy
    * Inhibition of return (IOR), that is the process by which the currently attended location is prevented from being attended again, is a crucial element of attentional deployment
    * attention and eye movements tightly interplay, posing computational challenges with respect to the coordinate system used to control attention
    * scene understanding and object recognition strongly constrain the selection of attended location.
  * The paper was interesting but a bit to general and to much focused on the neurobiological understanding of visual attention.

Read the paper: _"**A Model of Saliency-Based Visual Attention for Rapid Scene Analysis**"_ of Laurent Itti, Christof Koch and Ernst Niebur.
  * The paper is quite interesting and explain really good the way they try to extract saliency locations from images. The process can be seen in the following image:
![http://img3.imageshack.us/img3/9028/archz.png](http://img3.imageshack.us/img3/9028/archz.png)

  * Even more they compare the _saliency maps_ with a _spatial frequency (SFC) maps_. Results shows that the first one is much more robust to addition of noise to the image than the second one that seems to be very weakly.
  * Even if saliency maps are really robust to noise, they still get a bit confused in the noise (e.g. its color) directly conflict with the main feature of the target.

## 03/06/2010 ##
  * Explored DevianArt webages.
**Considerations/Ideas**:
  * Some users save their pictures/photos in galleries and in every gallery explored all the images belong to the same "topic". Maybe it could be interesting to find a way to suggest galleries instead of suggesting single images.
  * DevianArt has categories (not based on the styles). The user is free to put its images under the category he prefer and often some pictures seems to be misclassified.
  * Some categories contain very similar images (because the style is the same one)
  * A category called "Stock Images" (the ones with a commercial target) contains images of completely different topics.

  * We could extract 4-5 categories describing 4-5 different styles and we could see if we are be able to distinguish them (using classification).



## 02/06/2010 ##

  * Meeting about the project and tasks at Science Park
  * My task is the extraction of cognitive-inspired features
  * Discussed some data-structure ideas with Bart