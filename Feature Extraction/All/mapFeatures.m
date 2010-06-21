function mapFeatures(type, class, settings)

minimalClassSize = 10;

%setup paths should be moved to general setup file
project_root = ['..',filesep,'..',filesep];
addpath(genpath([project_root, 'externalpackages']));

% DIR NEEDS TO EXIST
featuredir = ['..',filesep,'features', filesep];

%parse inputs
[doPca, doLda, doClasses, classes, settings] = parseInputs(type, class, settings);
features = unique([settings.features]);

%parse XML-feature files
files = ls([featuredir, '*.xml']);
featureCell = cell(length(files), length(features));
labels = cell(length(files),4);

for i=1:length(files)
    file = files(i,:);
    dataXml = xml_load([featuredir, file]);

    labels(i, 1)={dataXml.artist};
    categoryFull = dataXml.category;
    slashPos = strfind(categoryFull, '/');
    
    %split categories
    labels(i, 2)={categoryFull};
    if numel(slashPos) > 1
        labels(i, 3)={categoryFull(1:slashPos(2)-1)};
        labels(i, 4)={categoryFull(1:slashPos(1)-1)};
    elseif numel(slashPos) > 0
        labels(i, 3)={categoryFull(1:slashPos(1)-1)};
        labels(i, 4)={categoryFull(1:slashPos(1)-1)};
    else
        labels(i, 3)={categoryFull};
        labels(i, 4)={categoryFull};
    end
    
    %extract features that will be used according to settings
    for j=1:length(features)
        if isfield(dataXml.features, features(j))
            featureVal = getfield(dataXml.features,features{j},'data');
            featureCell(i, j)={reshape(featureVal,1, numel(featureVal))};
        else
            featureCell(i, j)={NaN};
        end
    end
end

% check if at least minimalClassSize items per catagory
% if not, the class gets designated __OTHERS__
% if that class itself < minimalClassSize the smallest class larger than
% minimalClassSize also get designated __OTHERS__
for i=1:size(labels,2)
    uniqueLab = unique(labels(:,i));
    minCount = size(labels,1);
    minLabel = '';
    for j = 1: length(uniqueLab)
        pos = strcmp(labels(:,i), char(uniqueLab(j,:)));
        count = sum(pos);
        if count < minCount && count >= minimalClassSize
            minPos = pos;
            minCount = count;
        end
        if count < minimalClassSize
            labels(pos,i)={'__OTHERS__'};
        end
    end
    %make sure __OTHERS__ is also >= 10, by adding the minClass
    count = sum(strcmp(labels(:,i), '__OriginalClassTooSmall__'));
    if count > 0 && count < 10
        labels(minPos,i)={'__OriginalClassTooSmall__'};
    end
end
   

%make datasets and do pca lda, store as projected
projected = cell(length(settings), doPca+length(doClasses));
for i=1:length(settings)
    setting = settings(i);
    index = ismember(features, setting.features);
    feature = cell2mat(featureCell(:,index));
    if doPca
        data = dataset(feature);
        projected(i,1) = {data*pca(data, setting.projectDim)};
    end
    if doLda
        for j = 1:length(doClasses)
            data = dataset(feature, labels(:,doClasses(j)));
            projected(i,doPca+j) = {data*fisherm(data, setting.projectDim)};
        end
    end
end

% write output
for i=1:length(files)
    file = files(i,:);
    dataXml = xml_load([featuredir, file]);
    for j=1:length(settings)
        if doPca
            name = ['pca_',settings(j).name];
            values = projected{j,1};
            dataXml.features.(name) = struct('data', values.data(i,:));
        end
        if doLda
            for k=1:length(doClasses)
                if doLda
                    name = ['lda_', char(classes(doClasses(k))),'_' ,settings(j).name];
                    values = projected{j,doPca+k};
                    dataXml.features.(name) = struct('data', values.data(i,:));
                end
            end
        end    
    end
    xml_save([featuredir, file], dataXml);
end

function [doPca, doLda, doClasses, classes, settings] = parseInputs(type, class, settings)

type = lower(type);
class = lower(class);

types = {'pca', 'lda', 'all'};
classes = {'artist', 'catfulll', 'catmiddle', 'cattop', 'catall', 'all'};
settingsStrs = {'all', 'standard'};

if ~ischar(type) || ~ismember(type, types)
    error(['Wrong parameter type, this has to be a "pca","lda" or "all"']);
end
if ~ischar(class) || ~ismember(class, classes)
    error(['Wrong parameter class, this has to be artist ', ...
        '"catFull","catMiddle","catTop","catAll" or "all"']);
end
if ischar(settings) 
    if ~ismember(settings, settingsStrs)
        error(['Wrong parameter settings, this has to be a string "standard","all" or a struct']);
    end
elseif ~isstruct(settings)
    error(['Wrong parameter settings, this has to be a string "standard","all" or a struct']);
end
%parse input type
doPca = false;
doLda = false;
switch lower(type)
    case {'pca'} 
        doPca =true;
    case {'lda', 'fisher'}
        doLda =true;
    case {'all'}
        doPca =true;
        doLda =true;
end

%parse input class
doClasses = [];
switch lower(class)
    case {'artist'}
        doClasses = 1;
    case {'catfull'}
        doClasses = 2;
    case {'catmiddle'}
        doClasses = 3;
    case {'cattop'}
        doClasses = 4;
    case {'catall', 'allcat'}
        doClasses = 2:4;
    case {'all'}
        doClasses = 1:4;
end

% reasonable standard settings.
% project higher dimensional features to 2 dimensions
if ischar(settings)
    doFeats = {{'cornerRatioGrid'}, {'gridEdgeRatio'}, {'medHueCells'},...
        {'avgSatCells'}, {'avgIntCells'}, {'cornerRatioGrid'},...
        {'avgRCells'}, {'avgGCells'}, {'avgBCells'}, {'salPoints'}};
    featNames = [doFeats{:}];
    projectDim = {2,2,2,2,2,2,2,2,2,2};
    C = [featNames; doFeats; projectDim];
end
% for "all" add a setting to project all features together to 2 dimensions
if strcmpi(settings, 'all')
    featuresAll = {'numFaces', 'intEntropy', 'intVariance', 'edgeRatio', 'gridEdgeRatio', ...
        'medianHue', 'avgSat', 'avgInt', 'medHueCells', 'avgSatCells', 'avgIntCells', ...
        'cornerRatio', 'cornerRatioGrid', 'avgR', 'avgG', 'avgB', 'avgRCells', 'avgGCells', ...
        'avgBCells', 'salEntropy', 'salMapCEntropy', 'salMapIEntropy', 'salMapOEntropy', ...
        'salMapKEntropy', 'salHistDev', 'salPoints', 'salSkin' };
    C = [C, {'all'; featuresAll; 2}];
end 
if ischar(settings)
    settings = cell2struct(C, {'name', 'features', 'projectDim'},1);
end