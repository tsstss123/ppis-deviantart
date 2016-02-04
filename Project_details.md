# Groups #

**Group 1**
Group one will focus on the classification based on statistical features.

  * Bart van de Poel (features)
  * Quang (classifiers)
  * Nick (visualization)

**Group 2**
Group two will focus on the classification based on cognitive features.

  * Sander (features)
  * Bart Buter (Scraping & social network)
  * Davide (features)

# Research questions #

**Global questions:**
  * Can we use image features to recommend deviants for a given gallery?
  * Can we use those features to cluster (classifier) the images into categories/styles? Given the taxonomy, are there features in our feature vector that can be used to classify these categories?

  * can we improve recommendation accuracy by incorporating the [friends](friends.md) network?
  * which features are better? cognitive vs statistical recommendations

**Measure:**
  * use favorites as a metric 100 images of artist as train, 100 images including 10 of his favorites as test set.
  * use favorites as a metric 100 images of artist as train, 100 images including 10 of his own work not in the train set.
  * orrelation between network distance and "image distance"

  * what are we recommending
  * recommending one image per gallery
  * see if it performs on a favorites gallery
  * limit ourselves to premium accounts

# Visualization methods #
  * First we are going to implement the "Parallel coordinates" visualization method. "Parallel coordinates is a common way of visualizing high-dimensional geometry and analyzing multivariate data." This methods enables us to compare how different features react on different galleries/images.