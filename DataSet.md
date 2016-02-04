## General information ##
The dataset can be downloaded using scraper/scraper\_gallery.py.
As arguments it takes the usernames of the deviants we want to download

Example:
./scraper\_gallery.py omega300m vyrl

The images are downloaded to the images folder. For each deviant a folder is created. The folder contains for each image a xml file with the category information. It also contains another 3 folders with the full sizes images and thumbtail images.

Example xml file (should be readable in matlab):

```
<?xml version="1.0"?>
<!-- Written on 2010-06-15 13:10:50.043530 using Sanders awesome xml thing -->
<root xml_tb_version="3.1" idx="1" type="struct" size="1 1">
	<guid idx="1" type="char" size="1 49">http://Udodelig.deviantart.com/art/8178-155400343</guid>
	<title idx="1" type="char" size="1 4">8178</title>
	<category idx="1" type="char" size="1 26">photography/people/emotive</category>
	<filename idx="1" type="char" size="1 20">8178_by_Udodelig.jpg</filename>
</root>
```


## Todo ##
For which users should we download the images?

_Alberts deviants set (modified)_

```
omega300m K1lgore  Mallimaakari  catluvr2  Skarbog  erroid  iakobos  miss-mosh  LALAax Craniata  stereoflow  kamilsmala  wirestyle  Red-Priest-Usada  Swezzels  Udodelig  Pierrebfoto  woekan  fediaFedia  UdonNodu  gsphoto  sujawoto  sekcyjny  Mentosik8  One-Vox  zihnisinir  Knuxtiger4  Kitsunebaka91  NEDxfullMOon  nyctopterus 
```

From this group the following users are premium members:
`['omega300m', 'Skarbog', 'miss-mosh', 'Craniata', 'UdonNodu', 'gsphoto', 'sekcyjny', 'Mentosik8', 'Kitsunebaka91', 'nyctopterus']`

http://sandern.com/ppis/bigdataset.tar.gz

General statistics:
```
photography: 2244
customization: 906
traditional: 842
digitalart: 587
fanart: 239
darelated: 139
manga: 102
designs: 89
resources: 43
anthro: 38
artisan: 33
flash: 31
cartoons: 14
contests: 13
literature: 3
projects: 2
scraps: 1
```

_Other_

DESKTOP SCREENSHOT:
  * giannisgx89
  * Eagle07 (he has a gallery called: Desktop)

Nature/Landscapes:
  * my-shots (last pages are deviation in storage)

Small dataset of giannisgx89, Eagle07 and my-shots: http://sandern.com/ppis/smallsample.tar.gz

Category Stats:
```
Analyzing deviant Eagle07
	digitalart: 	86
	photography: 	21
	artisan: 	20
	customization: 	14
	cartoons: 	8
	designs: 	5
	darelated: 	4
	traditional: 	2
	literature: 	1
	fanart: 	1
	manga: 	1
Analyzing deviant giannisgx89
	customization: 	37
	resources: 	6
	designs: 	4
Analyzing deviant my-shots
	photography: 	308
	digitalart: 	1
	darelated: 	1
```