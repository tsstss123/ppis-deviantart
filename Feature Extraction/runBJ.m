function features = runBJ()
%run bjbuter run file

dir = ('../deviant/');
filelist = ls(strcat(dir, '*.jpg'));
images = imageReader(dir, filelist, [1:5]);
features = featureExtractor(images, [2,1])




