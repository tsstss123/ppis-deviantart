## 06/27/2010 ##
  * Refined data collection section
  * Wrote small toolkit introduction.

## 06/24/2010 ##
  * Football
  * Cleaned up gallery scraper code. Made downloading images a command line option.
  * Rewrote data collection section to be more general and shorter.
  * Discussion report

## 06/23/2010 ##
  * Presentation
  * Found bug in the network scaper, causing the friends name to fall off when the http:// part of the url is stripped. Only happens in cases of special characters.
  * Added nice command options to the category analyser.

## 06/22/2010 ##
  * Playing around with the visualization tool
  * Working on the report.
  * Working on slides about the gallery scraper

## 06/21/2010 ##
  * Added initial text for Technical Details Deviantart section.
  * Updated gallery implementation section. Added small part about the category analyser script.

## 06/20/2010 ##
  * Wrote initial gallery implementation section.

## 06/19/2010 ##
  * Redownloaded thumbs big dataset, because a lot of the thumbnails were corrupt.

## 06/18/2010 ##
  * Updated category analyzer to also show per sub category (as an option). Also added an option to show the total categories, instead of per user.
  * Tried to get libcv for matlab working. Still pending..
  * Played around with svmlib.

## 06/17/2010 ##
  * Solved various problems with the gallery scraper.
> > Failed downloads are nicely cleaned up, instead of xml files remaining while the images are not downloaded.
> > Executing the code again won't result in downloading the images again if they are already downloaded, so you can rerun in case images failed to download (in case the servers have problems)
  * Added extra info for each image: the link to the image on deviantart.
  * Added a verification script, to ensure each xml file has existing images and thumbnails.
  * Made a script to list per user how many images belong to each category.

## 06/16/2010 ##
  * Found a problem with the gallery downloader. For example it only downloads 1 image for  the user giannisgx89, while this user has a lot more.


> Solved it by directly accessing http://backend.deviantart.com/rss.xml?q=gallery:giannisgx89&offset=0. This page does show all images, in contrary to the backend link the gallery page. It also makes the code a bit faster since the backend url doesn't needs to be retrieved from the gallery page.

## 06/15/2010 ##
  * Updated gallery scraper code to generate a xml file containing the category information for each image.
  * Possible features we can extract for saliency:
    1. Histogram. Save the values of all different bins to the xml file (for example save 25 bins)
    1. Entropy. Just one value. Matlab already has a function for this.
    1. PCA. For example reduce the image to 20 dimensions.
    1. Number of saliency points
    1. Saliency points coordinates (might be difficult to compare).

## 06/11/2010 ##
  * Cleaned up saliency code, so the different similarity parts are nicely splitted up in different functions. Added the code to svn.

## 06/10/2010 ##
  * Comparing the saliency map histograms also doesn't seems to work too well. Might want to play with the params and features to get better results.
  * Played around with SIFT combined with saliency map. Not sure if it works yet and what's the best way how to use it.

## 06/09/2010 ##
  * Substracting two saliency maps does not work very well. Might have to do with the image resizing.

  * Looking into saliency maps.
    * A straight forward way to compute the simalirity between two images would be to just substract two saliency maps. Disadvantage: problems with different sized images and saliency spots that are just on a different position in the image while the images are still about the same.
    * Another way would be to look at the histogram of the saliency maps. In this case we would rather compare the distribution of the saliency.
    * Maybe calculate the top N coordinates of saliency spots and compare them to the other image.

  * Worked a bit more on the image download script.

> Usage: python scrapper\_gallery deviant1 deviant2 deviant3 ..

> Accepts a list of deviants. For each deviant it will download the full images and thumbtails to the folder images/deviant/

## 06/08/2010 ##
  * In case we store everything in a database we could maybe use a database scheme like this?
> http://ppis-deviantart.googlecode.com/files/db.PNG

> Filename refers to image filename. Can be the full image or one of the thumbs.

  * We might want to consider to only download the thumbs. The thumbs of 300 width might be sufficient for most features, while the thumbs are much smaller than the full images.

## 06/07/2010 ##
  * Working on extracting all images from a gallery of a deviant.
> > Looked at the matlab code of Albert. Seems he does not extract all images for each deviant. The first backend page only shows like the first 2.5 pages of the gallery. You need to modify the offset to show the remaining image information.

  * I'm rewriting the code in python. Using the SGMLParser class to find the backend url in the gallery page. Using xml.sax to parse the backend page.

  * The backend page contains the following information:
    * Image link
    * Thumbtail links (two versions: 300 width and 150 height)
    * Title
    * Category information
    * Keywords
    * Etc.

  * Downloads about 60 images per minute.

## 06/03/2010 ##
  * Worked together with Bart on extracting all friends from a deviant. With this information we can generate a graph of all connected deviants.

> The friends selection is limited to special members (premium members).

## 06/02/2010 ##
#### A Model of Saliency-Based Visual Attention for Rapid Scene Analysis" and "COMPUTATIONAL MODELLING OFVISUAL ATTENTION ####
  * Read the papers "A Model of Saliency-Based Visual Attention for Rapid Scene Analysis" and  "COMPUTATIONAL MODELLING OFVISUAL ATTENTION"
  * Assumes primates decompose visual input into a set of topographic feature maps. Spatial locations compete for saliency in each map. A saliency map is constructed from this and the attention point is derived from this.

  * Maps are constructed from different visual features like color, intensity and orientation. Then in various steps the saliency map is constructed. The point with the biggest output is the attention point.

  * _Discussion point:_ Papers seem to be focussed on finding saliency. The features could certainly be used to find similar images, but what if two images have the same attention points but are actually pretty different?

## 05/02/2010 ##
Made a research log.