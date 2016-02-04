# Research Log #

## 26/06 ##
  * Wrote Experiment 1: One against all artist from the report
  * Possibly missing: Formula's!

## 25/06 ##
  * Wrote the Classifier part of the report
  * Possibly missing: Formula's!

## 24/06 ##
  * Started on the Classifier and experiment part of the report

## 23/06 ##
  * Ran a new Parameter Optimization run because the last run of the 1 vs all experiment can not be compared to the 1vs1 run of the SVM. Therefore I have created a new 1vs1 experiment to optimize parameters and find out which classifier computes the best average score. This experiment can give an argument as to why SVM was chosen as the final classifier for our project.
  * Created Intensity plots for the result matrix that was computed from the 1v1 experiment  with SVM, these plots are better readable and you can see which artists score high.
  * Created functions to extract information from the result matrix. It extracts information like which artist is distinct from the rest by counting from how many artists it is seperated. The score for this results matrix is defined in F-measure
  * Looking at only the F-measure of one artist is not reliable to find pairs of artists that are really seperable. Because of the non-uniform dataset the F-measure of one artist does not tell me enough that 2 artists are seperable. It could happen that the classifier classifies everything as positive this will give 1 artist a F-measure of 1 and the other 0. Therefore finding artists that seperable the F-measure score should be around the same value.

## 22/06 ##
  * Results were computed overnight.
  * Davide, BartP and me looked into the results and checked what the top feature combinations were. We also looked at the artists that were not seperable(low score) or high seperable(high score) and see that our observation correspond to the classification.
  * Some artists pairs had when one artist is taken as positive a high Fmeasure but turning around results in a low Fmeasure. We found out that it means that the classifier either classifies everything to positive or negative. Whenever both ways the Fmeasure score is stable then it looks like it seems more like a viable score.
  * Because that some artists still have a lot of photos(+-600) compared to some others(+-7) we are running the results again with giving a weight 10 times higher to the positive example. Initial results look better this way.
  * Running the given feature combinations from the classifier for the best ones in the Nick visualization to check if they really cluster gave good observations too.

## 21/06 ##
  * Outputted initial results which was 1 artist versus all artists. The initial results were with KNN(K=1-9), Nearest Mean and Naive Bayes(Bin 6-24). The results were ranked to the best classifier Fmeasure. It showed that my\_shots(nature guy) was no.1 with 0.85~ Fmeasure Pierrebfoto(nude) no.2 and the rest of the top 20 was between Kitsunebaka(drawings) and gsphoto(nude).
  * The above results gave an indication about which artist were actually quite distinct from the rest. But then we are just focusing on a few artists.
  * A new idea from Albert is to use classify 1 vs 1 for all artists and output a matrix consisting of all results. The values of the matrix is in Fmeasure score for all features and top 1,2,3,4,5 features.
  * Davide helped me with the Experimental Setup for the Matrixresults. We used SVM based in libSVM which was a lot faster than the PRTools SVM and Davide helped me optimize general parameters. Using 5 fold validation on the training set we found out that the average C giving the best performance is 0.9.

## 20/06 ##
  * Filtering on artists/categories works perfectly now.
  * Created function to compute the Fmeasure from the results and sort the Classifiers+Parameter+Features+Artist combo in a cell array according to the Fmeasure in descending order. So throwing in a dataset into the system it can calculate what the best Classifiers+Parameter+Features+Artist is according to the Fmeasure criteria.
  * Noticed a bug when there is only 1 or 2 ClassObjects. PRtools can not deal with classes that do not have a Classobject. Classes with 1 or 2 will result in 0 objects due to Crossvalidation.

## 19/06 ##
  * Computer broke down yesterday had to format/reinstall everything.
  * Rewritten the readallXML.m function to make it handle the new feature xml files.
  * Rewritten createArtistDataset.m function to make it handle the new feature xml files. There are 1 or 2 hard coded lines in it but it works for now.
  * Finishing up a function to filter the dataset so that only some categories you specify will be classified against each other instead of choosing all. Also you can now choose between Artists or Categories.
  * There are also more categories for an image. For now you can only choose between the first, second or third category. Category 1 has some good seperated category names(e.g. Manga, Photography) that can be used for testing. A fusion of these categories can also be done but there are a lot of subcategories that only have 1 image.

## 18/06 ##
  * Created the part of the experiment code where you can specify what kind of experiments you want to run. You just type in what features you want to use and the matlab file will create the dataset and run it through all the classifiers and return a struct with the result. The entire experiment file can now be used to classify all the artists using all the classifiers and different specified combination of features.
  * An extra function must be build in to also specify which artists you want to train to so that for example you can find features that differentiate between 2,3,n artists.
  * Davide recommended libSVM to use as the SVM classifier because libSVM is in C and compared to Matlab it is superfast. Davide halfly implemented the code in Matlab for me. I still have to structure that code so that all results will be saved in the result struct.

## 17/06 ##

  * Discussion about what the report should look like and what we actually want to evaluate. In the end we did not know what to do and I should just save as much of the results as possible
  * Modified the XML Reader to also create labels that seperate artists from each other. The createArtistDataset.m is now only read 1 time and the full dataset must be created and put inside a struct. This is needed for the new modified Experiment runner.
  * Created another type of Experiment running. This experiment saves all the results acquired. The average error estimate, fp/tp, fn/tn, precision, recall of the results that are outputted from the classifiers.
  * Also The feature selection tool can be used with inter intra distance which seems like a good criteria.
  * I have checked some results of the KNN classifier and it seems that it classifies almost everything to negative. This increases when the K gets larger. This is caused because of a large negative training examples compared to the positive ones.

## 16/06 ##

  * Created another XML reader based on the new XML output format. Given the features you want to have and the target artist it creates a dataset with positive(target artist) and negative(the other artists) labels for the artists.
  * Created Experiment that calls KNN and Naive Bayes in order to classify the created dataset and output the results.

## 15/06 ##

  * Created an experiment file that should be used for experimenting. Given the features it reads all XML files and label it positive or negative according to the target artist. Reading XML files takes 2 minutes, maybe reading it once and storing it in a struct would be better.
  * Also the experiment splits the dataset in training and test set. The training set is used with 5 fold cross validation to optimize the parameters of the classifier used. PRtools also has a build in optimizer but it requires about 100 calls to the classifier. For SVM this would be a problem.

## 14/06 ##

  * Played with a feature select tool in PRtools that can be used to select the best feature set. This selection tool can use the error estimate of a classifier as a criteria. This tool is also called in the literature as a sequential feature selection algorithm. It can either be used forward or backward.

## 11/06 ##
  * Organized all the .m files, it was getting a bit unclear.
  * Currently trying to create a workflow through matlab code but there are a lot of parameters.

## 10/06 ##
  * Created code to run a PRTools dataset format on different classifiers and outputted the scores, this helps in selecting what classifier performs the overall best. Also the function can be used for training a classifier to be used for classifying a new image.
  * PRTools also contains tools for finding the best feature on a dataset this might be handy in the future.

## 09/06 ##

  * Implemented code to convert data to PRTools dataset format and use it for KNN.
  * Implemented code that given the features names return a dataset containing only those feature values. (Extension needed to extract only images we want but will need the information of the SQL database to know which images)

## 08/06 ##
  * Created code to classify a new image given the trained SVM classifier.
  * Created code to compute the similarity between users, now we have a ranking of which users are similar to the given user based on the features(for now hsv). Similarity measure was done using Euclidian distance on the gallery level(one vector representing all images of an user). User set are 8 different users, can be found in the Downloads section.

## 07/06 ##
  * Created a basis for dividing a dataset into train and test set in order to evaluate and structured the scores using Matlabs classperf function. So now you can get the error rate using the code. Also made it so that you can just train the classifier.
  * The basis can be reused just changing the classifiers.

## 06/06 ##
  * Read the PRTools documentation to have a better understanding of it in order to utilize better.

## 04/06 ##
  * Written code to read in a vector with feature values and use it in SVM. Also did this for kmeans.
  * Written the code to create simple features like the average hue, saturation and intensity.
  * Note: We are going to run experiments so an extra addition to the code is to let it automatically output all statistics.

## 03/06 ##
  * Looked for papers for Image classification. Found a very interesting survey paper containing all kinds of classification methods used in the literature. Also contains lots of information about how the research field has extracted different kinds of image features: http://isu.indstate.edu/qweng/classification_review_IJRS_2007.pdf

## 02/06 ##
  * Had initial meeting about the project and tasks at Science Park
  * Started on SVM Classifier.