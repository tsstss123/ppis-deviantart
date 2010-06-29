%script to add the external packages to the current matlab enviroment
currentPath = pwd;
externalPackagesPath = [a, filesep, '..', filesep, 'externalpackages'];
addpath(genpath(externalPackagesPath))