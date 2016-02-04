
  * 07/06/2010 (group and supervisor) @ 13.00 albert's office
  * 04/06/2010 (group) @ 11.00 new building
  * 02/06/2010 (group and supervisor)
  * 01/06/2010 (group and supervisor)


# 21-06 #
every feature needs 2 images
between galleries kullback leiber-divergence over feature space.
questions - what is network structure, image features for patterns, as a recommender system, specific featres for daily deviations can we find a representative work. can we find the mean image of a person. cluster a persons style.
show distance between galleries
failures

presentation
why DA <br>
questions <br>
patterns we wanna see <br>
present a system <br>
usecase, what is info flow in system <br>
growth of network mowmany new servers <br>
classiefiers, seperating <br>


<h1>literature study</h1>
network image data<br>
what did they do and reference<br>
<br>
<h1>experiments</h1>
say what you did<br>
not detailed results for failures<br>
<br>
<br>
<br>
<h1>Meeting 11/06/2010</h1>
<b>BJ's notes</b>

<h2>HOMEWORK</h2>
make experimental setup<br>
<br>
-copy blackboard discussions into wiki <br>
-features we discussed: color, hue(median, mean), edge ratio, faces, saliency, weibull, emotions, color temperature, average color <br>
<h2>System</h2>
<blockquote>- user will pick an gallery image or other gallery will be recommended<br>
- system must be efficiently expandable in users features and classifiers<br>
- for instance use XML to store data so it is easily expandable <br>
- look at computation time if its feasible for millions of pics <br>
<h2>Experiments</h2>
- Make an experimental setup that can be run with different combination of classifiers features and their (hybrid)combinations<br>
<blockquote>-- for instance 5 fold validation on the same 5 folds <br>
-- never use the test set till the end. <br>
-- look at mahalanobis distance for unnormalised distances between galleries<br>
-- make ROC curves for the experiments<br>
-- Everything is an experiment and a picture<br>
<h2>Cognitive</h2>
</blockquote>- talked about discriminant saliency??? <br>
- a good journal is trends in cognitive sciences for cognitive grounding of chosen techniques <br>
<h2>Features in general</h2>
- Good features have large interclass similarities and small intraclass<br>
- texture emotions and Weibull were discussed and Perlin? noise generated textures Bart has to look at Marcels work.</blockquote>



<h1>Meeting 07/06/2010</h1>
<b>BJ's notes</b>

-Watch out with metric vs measure, measure is safer, as the comment below also says<br>
-Look at literature firefly recommender systems, as well as LastFM & Pandora<br>
-Make the code so it can be :<br>
<blockquote>- re-used as a "personal" toolbox <br>
- make nice code <br>
- make code that works on millions of images thus: <br>
<blockquote>-- use openCV because it's quick <br>
-- use profiler to see where most of the time is lost <br>
-We can use classifiers as a distance measure as explained with the HMM's<br>
-Some saliency stuff was discussed with Davide<br>
-Some network stuff with BJ<br>
-Stock images are difficult but might be a nice expansion.<br></blockquote></blockquote>


<h1>Meeting 04/06/2010</h1>

<b>Global questions:</b>
<ul><li>Can we use image features to recommend deviants for a given gallery?<br>
</li><li>Can we use those features to cluster (classifier) the images into categories/styles? Given the taxonomy, are there features in our feature vector that can be used to classify these categories?</li></ul>

<ul><li>can we improve recommendation accuracy by incorporating the <a href='friends.md'>friends</a> network?</li></ul>

<ul><li>which features are better? cognitive vs statistical recommendations</li></ul>

- measures<br>
<br>
<blockquote>- use favorites as a metric 100 images of artist as train, 100 images including 10 of his favorites as test set.</blockquote>

<blockquote>- use favorites as a metric 100 images of artist as train, 100 images including 10 of his own work not in the train set.</blockquote>

<blockquote>- correlation between network distance and "image distance"</blockquote>


what are we recommending<br>
<br>
recommending one image per gallery<br>
<br>
see if it performs on a favorites gallery<br>
<br>
limit ourselves to premium accounts