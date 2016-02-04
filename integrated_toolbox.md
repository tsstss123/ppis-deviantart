With minimal work we want our toolbox to become 1 integrated tool.

User supplies:
  * a source folder with:
    * a folder structure for images additional image info
    * XML text files with images per artist and additional artist info
    * XML text files with images per category and additional category info
    * possibility for other groupings with links to images and the grouping info

What's the structure of the images folder and the text files?
  * images/
    * category/
      * user/

The tool computes(offline - once) after pressing new data button, and selecting the project directory
- Thumbnails for images (if non-existing)
- Feature files for images
- Representative image groups
(this requires compiling matlab to mex and then running that from java)

A button to "find best features" runs several svm "experiments" to find which features best separate selected groups( artist vs artist, artist vs category, category vs category etc.)
(this requires running svm experiments from java)

Visualizer shows selected groups using either the "best features" or any other features chosen by hand.
(we have this)

Please let me know if i missed anything and what you would like to work on

Bart