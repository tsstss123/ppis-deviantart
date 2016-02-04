# Logbook #

## 29/06/2010 ##
  * Finalized report. Added visualization: intro and proposed approach

## 28/06/2010 ##
  * Report structure change.
  * Report introduction / future work

## 27/06/2010 ##
  * Wrote previous work on image feature visualizations.

## 25/06/2010 ##
  * Wrote implementation of the visualization.

## 24/06/2010 ##
  * Discussed report structure.
  * Created schematic figure of the components and data flow.

## 23/06/2010 ##
  * Improved "visualization" part of the slides.
  * Merging new slides from everybody together.
  * Checking all slides together with whole group.
  * Presentation @ Nikhef

## 22/06/2010 ##
  * Fixed small XMLtoTSV bug, causing removed features to appear in the header line of the TSV file.
  * Added "Select None" button to the feature selector popup.
  * Worked on the presentation. Merged all slides together.

## 21/06/2010 ##
  * Introduction to deviantART (report).
  * Design of de slides for wednesday.
  * Extended the XMLtoTSV converter: ignore features that are not present in all files. Sorting features on name.
  * [ScatterPlot](ScatterPlot.md) The class centers are now clickable to make the corresponding class highlighted.
  * Fixed bug that caused the Y-axis positions to be swapped (high values at the bottom).
  * [ScatterPlot](ScatterPlot.md) Improved the dimming of non-highlighted images: V of the borders decreased, image intensify decreased instead of image alpha.
  * Fixed a bug causing the class centers to be wrong when a class was highlighted (positions of class members added twice).

## 19/06/2010 ##
  * Merge two folders under Mac OS X (copy new thumbs to dataset): ` ditto ./ ~/Documents/School/Eclipse/deviantART/data/albert/dataset/ `
  * Processing's ` smooth() ` causes the delay in the Parallel Coordinates plot.
  * When more data classes are added to the parallel coordinates plot, the alpha of each line is decreased. This makes it more easily to recognize clusters, even when the plot is "overcrowded". ` lineAlpha = 100.0 - (countVisibleClasses / countClasses) * 75.0 `

## 18/06/2010 ##
  * Added performance details to the radial view.
  * Solved Windows issues.
  * Created report skeleton on SVN.
  * Improved the way input files are loaded: users selects one directory, the features and performance files are automatically loaded and attached to the corresponding view method.
  * **Major update**: the data of the views is not stored inside an external (Database) class. The gives better performance (only read a file once), but also allows you to keep the current settings (visible classes/features) when you switch to another view.
> > ![http://www.nickd.nl/dl/ai/is/faces.png](http://www.nickd.nl/dl/ai/is/faces.png)
  * You need to run the Java app with the parameter "-Xmx500m" to increase the max. heap space
  * Fixed multiple bugs (class centers not visible, dealing with corrupted/missing images)

## 17/06/2010 ##
  * Asked the service desk for the Media Wall. Sjors is responsible for the content. His office is near the library. The dimensions are 1024x768px. Converting video is easy, slides are more difficult but possible (Powerpoint).
  * Improved the performance of the scatter view: the 50x50 thumb of the plot are stored inside an item's data structure (DataImage).
  * Fixed multiple bugs + many improvements.
  * Added the 'center points' of each class to the scatter view.
  * Added button for the Radial view to the header.
  * Added 'class labels' popup. Shows the names of the classes and enables you to hide classes. This makes the plot much better readable.
  * Exploring the dataset: some features can be used to detect OS (Windows) screenshots
> > ![http://www.nickd.nl/dl/ai/is/os_detector.png](http://www.nickd.nl/dl/ai/is/os_detector.png)

## 16/06/2010 ##
  * Radian view is now working. Todo: select (multiple) items and highlight relevant connections.
  * Wrote Java code to convert XML feature files into a single TSV file that is read by the viz. app.
  * Features that consist of multiple numbers are split into sub-features for the viz. This results in a big feature list, that doesn't fit into one window. I'm adding a scrollbar to tackle this issue.
  * Solved the checkbox scoll issue by adding a JPanel that holds the checkboxes, and this JPanel is added to a JScrollPane. Scrolling is forced to vertical only.
> > ![http://www.nickd.nl/dl/ai/is/parallel_coordinates_v0.45.png](http://www.nickd.nl/dl/ai/is/parallel_coordinates_v0.45.png)

## 15/06/2010 ##
  * Discussed features with the group.
  * Discussed experiment approach (dataset).
  * Discussed the 'performance radian plot' with Quang. Also input file structure.
  * Implemented part of the data structure to store the data that has been read from TSV file.
  * Attended the presentation by Lev.

## 14/06/2010 ##
  * Finished the feature selector panel. It's not perfect yet, because the nr of selected features is not limited on 2 for the scatter plot. The scatter plot picks the 'first' 2 active features from the visible features array.
  * Created the basis for the radian view.

## 13/06/2010 ##
  * Started working on the feature selector (filter) panel.

## 12/06/2010 ##

Asked myself the question: **What is the final output of our system**:
  * Overall [best/avg] performance of each [deviantART](deviantART.md) **category**
  * Overall [best/avg] performance of each **feature (statistical/cognitive)**
  * Overall [best/avg] performance of each **classifier**

  * Performance of each feature given a category
  * Performance of each classifier given a category
  * **Do we have the performance for each each classifier given a feature?**


> ![http://www.nickd.nl/dl/ai/is/sketch.png](http://www.nickd.nl/dl/ai/is/sketch.png)
  * The thickness of each line represents the performance.
  * The color-coded bar below the name of an item represents the overall performance of that item. For example: category1 has the best classification performance of all the categories.


## 11/06/2010 ##
  * Meeting with Albert.
  * Gave a Processing tutorial.
  * Made the header dynamic: buttons instead of 1 static image.
  * Added switching between views.
  * Added application (zip) to the downloads. Extract the zip to your Eclipse working space. It should run out of the box.

## 10/06/2010 ##
  * Changing drawing images in the footer to label, to make the images clickable. Having a lot of issues with Java Swing.
  * Implemented custom mouse listener class for the Footer, that enables me to pass an additional argument for listener call (image that has been clicked).
  * Fixed the alignment problem in the footer: use the FlowLayout manager and pass the FlowLayout.LEFT\_ALIGNMENT argument.
  * It's beter to use setPreferredSize() instead setMaximumSize()
  * Finished first working version of the Scatter view.
  * Preparing slides for the Processing tutorial.
> > ![http://www.nickd.nl/dl/ai/is/parallel_coordinates_v0.35.png](http://www.nickd.nl/dl/ai/is/parallel_coordinates_v0.35.png)

## 09/06/2010 ##
  * Added column (feature) hiding.
  * Added new class "View" which is the parent for all the View (plot) classes. The "View" class contains base functions for loading TSV/CSV data.
  * Reorganizes app structure > Box to JPanel, JPanel supports (re)painting.
  * Now displaying the thumbnails of selected images. Create script to show fullsize in a popup window.
> > ![http://www.nickd.nl/dl/ai/is/parallel_coordinates_v0.3.png](http://www.nickd.nl/dl/ai/is/parallel_coordinates_v0.3.png)

## 08/06/2010 ##
  * Improved the "Parallel coordinates" plot:
    * Added axis + title + min/max value
    * Added highlighting of single image (left click) and whole class (center click)
    * Tested it on Quangs dataset containing 3 features: HSV
    * New design:
> > > ![http://www.nickd.nl/dl/ai/is/parallel_coordinates_v0.2.png](http://www.nickd.nl/dl/ai/is/parallel_coordinates_v0.2.png)

## 07/06/2010 ##
  * Finished chapter 8.
  * Decided to kickoff with the "Parallel coordinates" visualization method. Parallel coordinates is a common way of visualizing high-dimensional geometry and analyzing multivariate data. This methods enables us to compare how different features react on different galleries/images.
  * Finished reading the book. Last chapter described how to integrate a Processing PApplet into a Java Swing application.
  * Created first version of the parallel coordinates vis: ![http://www.nickd.nl/dl/ai/is/parallel_coordinates_v0.1.png](http://www.nickd.nl/dl/ai/is/parallel_coordinates_v0.1.png)

## 06/06/2010 ##
  * Continue reading the book. "A **thread** provides a way to bundle a function in your program so that it can run at the same time as another part of the program. In this case, rather than waiting for the data to download, a thread can be used for the download while the main draw() method of the program continues to run."
  * No changes in data/view: skip the draw() loop by using noLoop() to make the app less CPU demanding.
  * Read the first 245 pages.



## 04/06/2010 ##
  * Discussed our research questions and ways to validate the results of the system.
  * Updated the project details.
  * Continue reading the book. "The translate() method moves the coordinate system over slightly, giving us a white border: (0, 0) will now be (30, 30), so nothing will be drawn in the left or top 30 pixels of the image"
  * Finished chapter 5. Was not interesting at all for our application. Preprocessing data will be done outside the visualization app.
  * Read the first 192 pages.

## 03/06/2010 ##
  * Started reading the "Visualizing Data" book. Why Processing: "Processing was the right combination of cost, ease of use, and execution speed."
  * Read the first 108 pages of the book. Chapter 3 describes how to make a timeSerie (plot) using Processing.

## 02/06/2010 ##
  * Group discussion to divide the work
  * Installed processing using a Mac .dmg.
  * Installed Eclipse. Added a new project with the Processing lib. Now i'm able to program processing application in Eclipse SDK.
  * Explored a couple visualization frameworks/websites:
    * http://blog.blprnt.com/blog/blprnt/your-random-numbers-getting-started-with-processing-and-data-visualization
    * http://prefuse.org/gallery/
    * http://www.wikiviz.org/wiki/Tools
  * Downloaded the JAR and source code of Mondrian. Can't compile the source code, but JAR runs.
  * Downloaded Prefuse. ~~I think this toolkit is more appropriate for our project then Processing.~~ I contains several plot functions.
  * Browsed the internet for Processing examples. It is very powerful and offers many features. The drawback is that we need to script more stuff manually, but this enables us to customize is the way we want.
  * Found an interesting book about Processing: "Visualizing Data". Ordered it and going to read it.