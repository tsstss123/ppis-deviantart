% K-means clustering
numberofclusters = 2;

% Create a testset
testset = HueFeature('testset2');

% Clusters based on features
result = kmeans(testset, numberofclusters);

hold off
scatter(testset(result==1,1), testset(result==1,2), 'o');
hold all
scatter(testset(result==2,1), testset(result==2,2), 'x');