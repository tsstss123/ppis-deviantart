function extractFeatures
%setup paths should be moved to general setup file
project_root = '..\..\'
addpath(genpath([project_root, 'externalpackages\openCV']))
addpath(genpath([project_root, 'externalpackages\Weibull']))
addpath(genpath([project_root, 'externalpackages\xml_toolbox']))
% calcEdgeRatios
% imagedir = 'deviant';
imagedir = [project_root, 'datasets\smallsample'];
% DIR NEEDS TO EXIST
featuredir = ['features' filesep];

% files = dir(imagedir);
users = dir(imagedir);
% grouped features with same base (for example group total edge and grid edge features) because
% calculating them independently is inefficient 
features.calculate = {'edgeRatios'};%,'HSV','numFaces','cornerRatio','RGB','intVariance','intEntropy','weibullFit1','weibullFit2'};
features.recompute = {};%,'HSV'};


for i = 1:size(users,1)
    user = users(i).name
    % filter hidden files and '.' '..' elements
    if user ~= '.'
        files = dir([imagedir filesep user]);
        for j = 1:size(files,1)
            filename = files(j).name;
            isXmlFile = false;
            if size(filename,2) >= 4
                if(strcmp(filename(size(filename,2)-2:size(filename,2)),'xml'))
                   isXmlFile = true; 
                end
            end
            
            if isXmlFile
                dataXml = xml_load([imagedir filesep user filesep filename]);
                category = dataXml.category;
%                 user
%                 filename
%                 imageFilename = dataXml.filename;
                matchImages = dir([imagedir filesep user filesep 'full' filesep filename(1:size(filename,2)-3) '*']); 
                if size(matchImages,1) < 1
                   error(['No images with the same filename as the xml file:\n' filename '\nUser: ' user],'bla');   
                else
                   % assume that there is only one image with the same filename (so not .jpg and also .png) 
                   imageFilename = matchImages(1).name                 
                end

                image = imread([imagedir filesep user filesep 'full' filesep imageFilename]);

                xmlUpdated = false;
                if (exist([featuredir filename],'file') > 0)
                    xmlFeatures = xml_load([featuredir filename]);
                else
                    clear('xmlFeatures');
                    xmlFeatures.filename = [user filesep 'full' filesep imageFilename];
                    xmlFeatures.category = category;
                    xmlFeatures.artist = user;
                end

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%CALL FEATURE CALCULATIONS%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        
        
                % number of faces detected
                feature = 'numFaces';
                if (sum(ismember(features.calculate,feature)) > 0) && ((~featInStruct(feature,xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)
                    numFaces = detectFaces(image);
                    xmlFeatures.features.numFaces.data = numFaces;
                    xmlUpdated = true;
                end

                % corner ratio
                feature = 'cornerRatio';
                % only calc if feature is set to be calculated. And only if the
                % feature is not already present in the xml file (or if the
                % recompute flag is set).

                if (sum(ismember(features.calculate,feature)) > 0) && ((~featInStruct({'cornerRatio','cornerRatioGrid'},xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)
                    [cornerRatio, cornerRatioGrid] = detectCorners(image);
                    xmlFeatures.features.cornerRatio.data = cornerRatio;
                    xmlFeatures.features.cornerRatioGrid.data = cornerRatioGrid;
                    xmlUpdated = true;
                end

                % avg RGB
                feature = 'RGB';
                if (sum(ismember(features.calculate,feature)) > 0) && ((~featInStruct({'avgR','avgG','avgB'},xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)
                    [avgR,avgG,avgB,avgRCells,avgGCells,avgBCells] = calcRGB(image);
                    xmlFeatures.features.avgR.data = avgR;
                    xmlFeatures.features.avgG.data = avgG;
                    xmlFeatures.features.avgB.data = avgB;
                    xmlFeatures.features.avgRCells.data = avgRCells;
                    xmlFeatures.features.avgGCells.data = avgGCells;
                    xmlFeatures.features.avgBCells.data = avgBCells;
                    xmlUpdated = true;
                end

                % entropy of the intensity image
                feature = 'intEntropy';
                if (sum(ismember(features.calculate,feature)) > 0) && ((~featInStruct(feature,xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)
                    intEnt = intEntropy(image);
                    xmlFeatures.features.intEntropy.data = intEnt;
                    xmlUpdated = true;
                end

                % variance of the intensity image
                feature = 'intVariance';
                if (sum(ismember(features.calculate,feature)) > 0) && ((~featInStruct(feature,xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)
                    intVar = intVariance(image);
                    xmlFeatures.features.intVariance.data = intVar;
                    xmlUpdated = true;
                end


                feature = 'weibullFit1';
                if (sum(ismember(features.calculate,feature)) > 0) && ((~featInStruct(feature,xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)
                    [scale shape location] = weibullMle(image, 0, 0); % for raw data
                    % Do all 3 parameter? or just 2?
                    xmlFeatures.features.weibullFit1.data = [scale,shape,location];
                    xmlUpdated = true;
                end

                feature = 'weibullFit2';
                if (sum(ismember(features.calculate,feature)) > 0) && ((~featInStruct(feature,xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)
                    [scale shape location] = integWeibullMle(image,'x', 1, 0); % for raw data
                    % Do all 3 parameter? or just 2?
                    xmlFeatures.features.weibullFit2.data = [scale,shape,location];
                    xmlUpdated = true;
                end


                % EDGE RATIOS of total image and of parts of image)
                % I grouped the edgeRatio and gridEdgeRatio features under the
                % "edgeRatios" flag. If this flag is set in features.calculate,
                % then all edge ratio features are calculated.
                feature = 'edgeRatios';
                if (sum(ismember(features.calculate,feature)) > 0) && ((~featInStruct({'edgeRatio','gridEdgeRatio'},xmlFeatures))  || sum(ismember(features.recompute,feature)) > 0)
                    [totalRatio,cellRatios] = calcEdgeRatios(image);
                    xmlFeatures.features.edgeRatio.data = totalRatio;
                    xmlFeatures.features.gridEdgeRatio.data = cellRatios;
                    xmlUpdated = true;
                end

                % HSV information of total image and of parts of image
                % I grouped all the HSV related features under the
                % "HSV" flag. If this flag is set in features.calculate,
                % then all HSV related features are calculated.
                feature = 'HSV';
                if (sum(ismember(features.calculate,feature)) > 0) && ((~featInStruct({'medianHue','avgSat','avgInt','medHueCells','avgSatCells','avgIntCells'},xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)
                    [medianHue,avgSat,avgInt,medHueCells,avgSatCells,avgIntCells] = calcHSV(image);
                    xmlFeatures.features.medianHue.data = medianHue;
                    xmlFeatures.features.avgSat.data = avgSat;
                    xmlFeatures.features.avgInt.data = avgInt;
                    xmlFeatures.features.medHueCells.data = medHueCells;
                    xmlFeatures.features.avgSatCells.data = avgSatCells;
                    xmlFeatures.features.avgIntCells.data = avgIntCells;
                    xmlUpdated = true;
                end


                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


                % If features have been computed, save the new XML file
                if xmlUpdated
                    xml_save([featuredir filename],xmlFeatures);
                end

            end
        end
    end
        
    
end
% Loop over images
% for i = 3:0%size(files,1)
%     i
%     filename = files(i).name;
%     if(strcmp(filename(size(filename,2)-2:size(filename,2)),'jpg') || strcmp(filename(size(filename,2)-2:size(filename,2)),'png') )
%         % Image from which features must be extracted
%         image = imread(strcat(imagedir,'/',files(i).name));
%         
%         
%         xmlUpdated = false;
%         if (exist([featuredir filename '.xml'],'file') > 0) 
%            xmlFeatures = xml_load([featuredir filename '.xml']);
%         else
%            clear('xmlFeatures');
%            xmlFeatures.filename = filename;           
%         end
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %%%%CALL FEATURE CALCULATIONS%%%%%%%%%%%%%%%%%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         
%         
%         
%          % number of faces detected
%         feature = 'numFaces';
%         if (sum(ismember(features.calculate,feature)) > 0) && ((~featInStruct(feature,xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)
%             numFaces = detectFaces(image);            
%             xmlFeatures.features.numFaces.data = numFaces;
%             xmlUpdated = true;
%         end
%         
%         % corner ratio
%         feature = 'cornerRatio';
%         % only calc if feature is set to be calculated. And only if the
%         % feature is not already present in the xml file (or if the
%         % recompute flag is set).
%         
%         if (sum(ismember(features.calculate,feature)) > 0) && ((~featInStruct({'cornerRatio','cornerRatioGrid'},xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)
%             [cornerRatio, cornerRatioGrid] = detectCorners(image);
%             xmlFeatures.features.cornerRatio.data = cornerRatio;
%             xmlFeatures.features.cornerRatioGrid.data = cornerRatioGrid;
%             xmlUpdated = true;
%         end        
%         
%          % avg RGB
%         feature = 'RGB';
%         if (sum(ismember(features.calculate,feature)) > 0) && ((~featInStruct({'avgR','avgG','avgB'},xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)
%             [avgR,avgG,avgB,avgRCells,avgGCells,avgBCells] = calcRGB(image);            
%             xmlFeatures.features.avgR.data = avgR;
%             xmlFeatures.features.avgG.data = avgG;
%             xmlFeatures.features.avgB.data = avgB;
%             xmlFeatures.features.avgRCells.data = avgRCells;
%             xmlFeatures.features.avgGCells.data = avgGCells;
%             xmlFeatures.features.avgBCells.data = avgBCells;
%             xmlUpdated = true;
%         end
%         
%         % entropy of the intensity image
%         feature = 'intEntropy';
%         if (sum(ismember(features.calculate,feature)) > 0) && ((~featInStruct(feature,xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)
%             intEnt = intEntropy(image);            
%             xmlFeatures.features.intEntropy.data = intEnt;
%             xmlUpdated = true;
%         end
%         
%         % variance of the intensity image
%         feature = 'intVariance';
%         if (sum(ismember(features.calculate,feature)) > 0) && ((~featInStruct(feature,xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)
%             intVar = intVariance(image);            
%             xmlFeatures.features.intVariance.data = intVar;
%             xmlUpdated = true;
%         end
%         
%         
%         feature = 'weibullFit1';
%         if (sum(ismember(features.calculate,feature)) > 0) && ((~featInStruct(feature,xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)            
%             [scale shape location] = weibullMle(image, 0, 0); % for raw data
%             % Do all 3 parameter? or just 2?
%             xmlFeatures.features.weibullFit1.data = [scale,shape,location];
%             xmlUpdated = true;            
%         end
%         
%         feature = 'weibullFit2';
%         if (sum(ismember(features.calculate,feature)) > 0) && ((~featInStruct(feature,xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)            
%             [scale shape location] = integWeibullMle(image,'x', 1, 0); % for raw data
%             % Do all 3 parameter? or just 2?
%             xmlFeatures.features.weibullFit2.data = [scale,shape,location];
%             xmlUpdated = true;            
%         end
%       
% 
%         % EDGE RATIOS of total image and of parts of image)
%         % I grouped the edgeRatio and gridEdgeRatio features under the
%         % "edgeRatios" flag. If this flag is set in features.calculate,
%         % then all edge ratio features are calculated.
%         feature = 'edgeRatios';
%         if (sum(ismember(features.calculate,feature)) > 0) && ((~featInStruct({'edgeRatio','gridEdgeRatio'},xmlFeatures))  || sum(ismember(features.recompute,feature)) > 0)
%             [totalRatio,cellRatios] = calcEdgeRatios(image);
%             xmlFeatures.features.edgeRatio.data = totalRatio;
%             xmlFeatures.features.gridEdgeRatio.data = cellRatios;
%             xmlUpdated = true;
%         end
%         
%         % HSV information of total image and of parts of image
%         % I grouped all the HSV related features under the
%         % "HSV" flag. If this flag is set in features.calculate,
%         % then all HSV related features are calculated.
%         feature = 'HSV';
%         if (sum(ismember(features.calculate,feature)) > 0) && ((~featInStruct({'medianHue','avgSat','avgInt','medHueCells','avgSatCells','avgIntCells'},xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)
%             [medianHue,avgSat,avgInt,medHueCells,avgSatCells,avgIntCells] = calcHSV(image);
%             xmlFeatures.features.medianHue.data = medianHue;
%             xmlFeatures.features.avgSat.data = avgSat;
%             xmlFeatures.features.avgInt.data = avgInt;
%             xmlFeatures.features.medHueCells.data = medHueCells;
%             xmlFeatures.features.avgSatCells.data = avgSatCells;
%             xmlFeatures.features.avgIntCells.data = avgIntCells;
%             xmlUpdated = true;
%         end
%         
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         
%         % If features have been computed, save the new XML file
%         if xmlUpdated
%             xml_save([featuredir filename '.xml'],xmlFeatures);
%         end
%     end
%   
% end


end


% check if the struct that came from the xml file already contains
% this feature (or in the case of a cell array, if it contains ALL the features)
function isTrue = featInStruct(feature,xmlFeatures)
    fields = fieldnames(xmlFeatures);
    isTrue = false;
    % if it's a list of features
    if sum(ismember(fields,'features')) > 0
        if iscell(feature)
            
            for i = 1:size(feature,2)
                if sum(ismember(fieldnames(xmlFeatures.features),feature{i})) > 0
                    isTrue = true;
                else
                    isTrue = false;
%                     breaking = 0
                    break;
                end
            end
            % if it's a single feature
        else
            if sum(ismember(fieldnames(xmlFeatures.features),feature)) > 0
                isTrue = true;
            end
        end
    end
end


