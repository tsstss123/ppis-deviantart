function [f categoryLabels, artistLabels] = mapFeatures(type, class, features)
%setup paths should be moved to general setup file
project_root = ['..',filesep,'..',filesep];
addpath(genpath([project_root, 'externalpackages']));

% DIR NEEDS TO EXIST
featuredir = ['..',filesep,'features', filesep];

if strcmp(lower(features), 'all')
    features = {'cornerRatioGrid', 'gridEdgeRatio', 'medHueCells', 'avgSatCells', 'avgIntCells', 'cornerRatioGrid', 'avgRCells', 'avgGCells', 'avgBCells', 'salPoints'};
end 
files = ls([featuredir, '*.xml']);
featureCell = cell(length(files), length(features));
categoryLabels = cell(length(files),1);
artistLabels = cell(length(files),1);

for i=1:length(files)
    file = files(i,:);
    dataXml = xml_load([featuredir, file]);

    categoryLabels(i)={dataXml.category};
    artistLabels(i)={dataXml.artist};
    
    for j=1:length(features)
       if isfield(dataXml.features, features(j))
           featureVal = getfield(dataXml.features,features{j},'data');
           featureCell(i, j)={reshape(featureVal,1, prod(size(featureVal)))}; 
       else
           featureCell(i, j)={NaN};
       end
    end
end
%cell2mat
    switch lower(class)
        case {'artist'}
            for i=1:length(features)
                d = dataset(cell2mat(featureCell(:,i)), artistLabels);
                map  = pca(d)
                projection = d*map
                
            end
        case {'category'}
    
        otherwise
            error('wrong class parameter')
            return
    end

switch lower(type)
    case {'pca_map'}
        map  = pca(d,2)
    case {'fisher_map'}
        map = fisherm(d,2)
end
f = featureCell