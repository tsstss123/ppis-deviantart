%script to add the external packages to the current matlab enviroment
currentPath = pwd;
externalPackagesPath = [currentPath, filesep, '..', filesep, 'externalpackages'];
addpath(genpath(externalPackagesPath))