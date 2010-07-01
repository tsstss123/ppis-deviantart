function extractFeatures
% This is the main feature extraction loop. features.calculate contains all
% the features that need to be calculated. For each user, the loop goes
% over all his/her images and checks for each feature whether it is set to
% be (re)calculated and whether it is not already present in the xml file.
% If so, then the feature is calculated and added to the xml file
%
% NOTE: Images that cannot be processed by saliency or facedetector code are
% skipped and their feature files deleted (so also values for other features). 
% But when the feature extractor is executed with the saliency and facedetector
% turned off, then images that would have failed, might get processed for other features and 
% then different images may have different amounts of calculated features.
%
% Created by Bart van de Poel


project_root = ['..',filesep,'..',filesep,'..',filesep];
addpath(genpath([project_root, 'externalpackages',filesep,'openCV']))
addpath(genpath([project_root, 'externalpackages',filesep,'Weibull']))
addpath(genpath([project_root, 'externalpackages',filesep,'xml_toolbox']))
addpath(genpath([project_root, 'externalpackages', filesep, 'SaliencyToolbox']));

imagedir = ['..',filesep,'bigdataset'];
% feature DIR NEEDS TO EXIST
featuredir = ['..',filesep,'features', filesep];

users = dir(imagedir);

% List of the feature types that need to be calculated (these are not the
% actual feature names, because I grouped some features with the same base 
% (for example I grouped total edge ratio and grid edge ratio features) because
% calculating them independently is inefficient 
features.calculate = {'edgeRatios','HSV','intensity','cornerRatio','RGB','intVariance','intEntropy','weibullFit1','weibullFit2','numFaces','saliency'};

% List of the feature types that need to be computed, even if they are
% already present in the images' feature file
features.recompute = {'edgeRatios'};

% Lists of which feature types use which color spaces
features.useGrayscale = {'edgeRatios','intensity','intVariance','intEntropy','weibullFit1','weibullFit2','numFaces'};
features.useHSV = {'HSV'};
features.useRGB = {'RGB','cornerRatio','saliency'};

% Users that should be skipped (currently everyone except swezzels is
% skipped because only his images are on the svn. Uncomment skipUsers = {}
% to run on all users)
skipUsers = {'catluvr2','Kitsunebaka91','Knuxtiger4','LALAax','Mallimaakari','Mentosik8','NEDxfullMOon','One-Vox','Pierrebfoto','Red-Priest-Usada','Skarbog','Udodelig','UdonNodu','WarrenLouw','catluvr2','erroid','fediaFedia','gsphoto','kamilsmala','miss-mosh','nyctopterus','stereoflow','sujawoto','wirestyle','woekan','zihnisinir','omega300m','iakobos','K1lgore','sekcyjny','Craniata'};%,'Swezzels'};
% skipUsers = {};

for i = 1:size(users,1)
    user = users(i).name
    if ismember(user,skipUsers)
      continue
    end

    % filter hidden files and '.' '..' elements
    if user(1) ~= '.'
        % All the XML files in the directory of that user
        files = dir([imagedir filesep user]);
        for j = 1:size(files,1)
            filename = files(j).name
            isXmlFile = false;
            if size(filename,2) >= 4
                if(strcmp(filename(size(filename,2)-2:size(filename,2)),'xml'))
                   isXmlFile = true; 
                end
            end
            
            if isXmlFile
                dataXml = xml_load([imagedir filesep user filesep filename]);
                category = dataXml.category;
                % filename of the actual image file
                imageFilename = dataXml.filename;
%                 matchImages = dir([imagedir filesep user filesep 'full' filesep filename(1:size(filename,2)-3) '*']); 
%                 if size(matchImages,1) < 1
%                    disp(['No images with the same filename as the xml file:\n' filename '\nUser: ' user]);   
%                    continue;
%                 else
%                    % assume that there is only one image with the same filename (so not .jpg and also .png) 
%                    imageFilename = matchImages(1).name;                
%                 end
                
                try
                   image = imread([imagedir filesep user filesep 'full' filesep imageFilename]);
                catch
                   disp('Corrupt image. Skipping it');
                   continue
                end
                                
                xmlUpdated = false;
                % If there is already a feature file for the current image,
                % load it into a struct, otherwise create a new struct
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
                
                % All the features that take a greyscale image as input
                if someFeatInCell(features.useGrayscale, features.calculate)
                    % Flag that says whether the image hasn't already been
                    % converted to greyscale (to avoid converting the same
                    % image twice)
                    convertedToGrey = false;
                    clear grayImage;
                    
                    % FEATURE: number of faces detected
                    feature = 'numFaces';
                    % check if this feature is set to be calculated and if
                    % it is not already present in the xml file (or set to
                    % be recomputed)
                    if (ismember(feature,features.calculate)) && ((~allFeatInStruct({feature},xmlFeatures)) || ismember(feature,features.recompute))
                        if ~convertedToGrey
                           grayImage = convToGrey(image);
                           convertedToGrey = true;                           
                        end
                        try                            
                            numFaces = detectFaces(grayImage,project_root);
                            xmlFeatures.features.numFaces.data = numFaces;
                            xmlUpdated = true;
                        catch
                            % For our experiments we skipped images that
                            % caused problems in openCV or other packages
                            disp('Image cannot be processed by opencv face detector. Deleting feature file and skipping it...');
                            delete([featuredir filename]);                            
                            continue;
                        end
                    end
                    
                    % FEATURE: avg & median intensity (& compositional
                    % version)
                    feature = 'intensity';
                    % In this case multiple features are grouped under the
                    % "intensity" name. So in this case the actual features
                    % are given to the ~allFeatInStruct check instead of
                    % 'intensity'. If one of these features are not
                    % present, all of them are calculated.
                    if (ismember(feature,features.calculate)) && ((~allFeatInStruct({'avgInt','avgIntCells','medianInt','medIntCells'},xmlFeatures)) || ismember(feature,features.recompute))
                        if ~convertedToGrey
                           grayImage = convToGrey(image);
                           convertedToGrey = true;
%                            disp('converted to grey');
                        end                        
                        [avgInt,medianInt,avgIntCells,medIntCells]= calcIntensity(grayImage);                        
                        xmlFeatures.features.avgInt.data = avgInt;
                        xmlFeatures.features.medianInt.data = medianInt;
                        xmlFeatures.features.avgIntCells.data = avgIntCells;
                        xmlFeatures.features.medIntCells.data = medIntCells;
                        xmlUpdated = true;
                    end
                    
                    % FEATURE: entropy of the intensity image
                    feature = 'intEntropy';
                    if (ismember(feature,features.calculate)) && ((~allFeatInStruct({feature},xmlFeatures)) || ismember(feature,features.recompute))
                        if ~convertedToGrey
                           grayImage = convToGrey(image);
                           convertedToGrey = true;
%                            disp('entropy: converted to grey');                        
                        end
                        intEnt = intEntropy(grayImage);
                        xmlFeatures.features.intEntropy.data = intEnt;
                        xmlUpdated = true;
                    end
                    
                    % FEATURE: variance of the intensity image
                    feature = 'intVariance';
                    if (ismember(feature,features.calculate)) && ((~allFeatInStruct({feature},xmlFeatures)) || ismember(feature,features.recompute))
                        if ~convertedToGrey
                           grayImage = convToGrey(image);
                           convertedToGrey = true;                           
                        end
                        intVar = intVariance(grayImage);
                        xmlFeatures.features.intVariance.data = intVar;
                        xmlUpdated = true;
                    end
                    
                    % 2 pieces of code for two different versions of the
                    % weibull fit. Removed from this version due to an
                    % unexplicable error of the external packages on some
                    % images
%                     feature = 'weibullFit1';
%                     epsilon = 0.001;
%                     weibullGray = im2double(grayImage);                    
%                     weibullGray(weibullGray == 0) = epsilon;
%                     if (ismember(feature,features.calculate)) && ((~allFeatInStruct({feature},xmlFeatures)) || ismember(feature,features.recompute))
%                         if ~convertedToGrey
%                            grayImage = convToGrey(image);
%                            convertedToGrey = true;                           
%                         end
%                         [scale shape location] = weibullMle(weibullGray, 0, 0); % for raw data
%                         % Do all 3 parameter? or just 2?
%                         xmlFeatures.features.weibullFit1.data = [scale,shape,location];
%                         xmlUpdated = true;
%                     end
% 
%                     feature = 'weibullFit2';
%                     if (ismember(feature,features.calculate)) && ((~allFeatInStruct({feature},xmlFeatures)) || ismember(feature,features.recompute))
%                         if ~convertedToGrey
%                            grayImage = convToGrey(image);
%                            convertedToGrey = true;                           
%                         end
%                         [scale shape location] = integWeibullMle(weibullGray,'x', 1, 0); % for raw data
%                         % Do all 3 parameter? or just 2?
%                         xmlFeatures.features.weibullFit2.data = [scale,shape,location];
%                         xmlUpdated = true;
%                     end


                    % FEATURE: edgeRatios of total image and of parts of image)
                    % the edgeRatio and gridEdgeRatio features are grouped under the
                    % "edgeRatios" flag. If this flag is set in features.calculate,
                    % then all edge ratio features are calculated.
                    feature = 'edgeRatios';
                    if (ismember(feature,features.calculate)) && ((~allFeatInStruct({'edgeRatio','gridEdgeRatio'},xmlFeatures))  || ismember(feature,features.recompute))
                        if ~convertedToGrey
                           grayImage = convToGrey(image);
                           convertedToGrey = true;                           
                        end
                        [totalRatio,cellRatios] = calcEdgeRatios(grayImage);
                        xmlFeatures.features.edgeRatio.data = totalRatio;
                        xmlFeatures.features.gridEdgeRatio.data = cellRatios;
                        xmlUpdated = true;
                    end

                    
                end
                
                % All the features that use an HSV image
                if someFeatInCell(features.useHSV,features.calculate)
                    convertedToVSH = false;
                    clear vshImage;
                    
                    % FEATURE: HSV information of total image and of parts of image
                    % I grouped all the HSV related features under the
                    % "HSV" flag. If this flag is set in features.calculate,
                    % then all HSV related features are calculated.
                    feature = 'HSV';
                    if (ismember(feature,features.calculate)) && ((~allFeatInStruct({'medianHue','medianSat','medianVal','avgHue','avgSat','avgVal','medHueCells','medSatCells','medValCells','avgHueCells','avgSatCells','avgValCells'},xmlFeatures)) || ismember(feature,features.recompute))
                        if ~convertedToVSH
                           vshImage = convToVSH(image);
                           convertedToVSH = true;
                        end
                        [medianHue,medianSat,medianVal,avgHue,avgSat,avgVal,medHueCells,medSatCells,medValCells,avgHueCells,avgSatCells,avgValCells] = calcHSV(vshImage);
                        xmlFeatures.features.medianHue.data = medianHue;
                        xmlFeatures.features.medianSat.data = medianSat;
                        xmlFeatures.features.medianVal.data = medianVal;
                        xmlFeatures.features.avgHue.data = avgHue;
                        xmlFeatures.features.avgSat.data = avgSat;
                        xmlFeatures.features.avgVal.data = avgVal;
                        xmlFeatures.features.medHueCells.data = medHueCells;
                        xmlFeatures.features.medSatCells.data = medSatCells;
                        xmlFeatures.features.medValCells.data = medValCells;
                        xmlFeatures.features.avgHueCells.data = avgHueCells;
                        xmlFeatures.features.avgSatCells.data = avgSatCells;
                        xmlFeatures.features.avgValCells.data = avgValCells;
                        xmlUpdated = true;
                    end
                    
                end
                
                % All the features that use an RGB image
                if someFeatInCell(features.useRGB,features.calculate)
                    convertedToRGB = false;
                    clear RGBImage;                    
                    
                    % FEATURE: corner ratio
                    feature = 'cornerRatio';                    
                    if (ismember(feature,features.calculate)) && ((~allFeatInStruct({'cornerRatio','cornerRatioGrid'},xmlFeatures)) || ismember(feature,features.recompute))
                        if ~convertedToRGB
                           RGBImage = convToRGB(image);
                           convertedToRGB = true;
                        end
                        [cornerRatio, cornerRatioGrid] = detectCorners(RGBImage);
                        xmlFeatures.features.cornerRatio.data = cornerRatio;
                        xmlFeatures.features.cornerRatioGrid.data = cornerRatioGrid;
                        xmlUpdated = true;
                    end

                    % FEATURE: average and median R,G and B (also
                    % compositional versions)
                    feature = 'RGB';
                    if (ismember(feature,features.calculate)) && ((~allFeatInStruct({'medianR','medianG','medianB','avgR','avgG','avgB','medRCells','medGCells','medBCells','avgRCells','avgGCells','avgBCells'},xmlFeatures)) || ismember(feature,features.recompute))
                        if ~convertedToRGB
                           RGBImage = convToRGB(image);
                           convertedToRGB = true;
                        end
                        [medianR,medianG,medianB,avgR,avgG,avgB,medRCells,medGCells,medBCells,avgRCells,avgGCells,avgBCells] = calcRGB(RGBImage);
                        xmlFeatures.features.medianR.data = medianR;
                        xmlFeatures.features.medianG.data = medianG;
                        xmlFeatures.features.medianB.data = medianB;                        
                        xmlFeatures.features.avgR.data = avgR;
                        xmlFeatures.features.avgG.data = avgG;
                        xmlFeatures.features.avgB.data = avgB;
                        xmlFeatures.features.medRCells.data = medRCells;
                        xmlFeatures.features.medGCells.data = medGCells;
                        xmlFeatures.features.medBCells.data = medBCells;
                        xmlFeatures.features.avgRCells.data = avgRCells;
                        xmlFeatures.features.avgGCells.data = avgGCells;
                        xmlFeatures.features.avgBCells.data = avgBCells;
                        xmlUpdated = true;
                    end
                    
                    % FEATURE: All saliency features
                    feature = 'saliency';
                    if (ismember(feature,features.calculate)) && ((~allFeatInStruct({'salEntropy','salMapCEntropy','salMapIEntropy','salMapOEntropy','salMapKEntropy','salHistDev','salPoints','salSkin'},xmlFeatures)) || ismember(feature,features.recompute))
                        if ~convertedToRGB
                           RGBImage = convToRGB(image);
                           convertedToRGB = true;
                        end
                        % number of most salient points that will be used
                        % for the salPoints feature
                        numberPoints = 3;                        
                        params = set_parameters(RGBImage);
                        % flag that is set when the saliency package
                        % succeeded in processing the current image
                        salSucces = false;
                        % Number of times the image has been resized (images that are 
                        % too small can't be processed and are therefore enlarged)
                        salCount = 0;
                        salRGBImage = RGBImage;
                        % Only resize 3 times, then give up and skip the
                        % image.
                        while (salSucces == false) && (salCount < 3)
                           try
                              [salMap, salData] = generateSaliencyMap(salRGBImage, params);
                              salSucces = true;
                           catch
                              disp('Image cannot be processed by saliency package. Resizing it...');
                              % if number of pixels get bigger than 750.000 then don't
                              % try enlarging anymore
                              if size(salRGBImage,1)*size(salRGBImage,2) < 750000
                                  salRGBImage = imresize(salRGBImage,2);
                                  salCount = salCount+1;                                                            
                              else
                                  break;
                              end                              
                           end
                        end
                        if salSucces
                            E = entropy(salMap.data);
                            [EC, EI, EO, EK] = getMapsEntropy(salData);
                            H = getSalMapHist(salMap.data);
                            P = getMostSalientPoints(salMap, salData, params, numberPoints);
                            Sk = getSkinAmount(salData(4));


                            xmlFeatures.features.salEntropy.data = E;
                            xmlFeatures.features.salMapCEntropy.data = EC;
                            xmlFeatures.features.salMapIEntropy.data = EI;
                            xmlFeatures.features.salMapOEntropy.data = EO;
                            xmlFeatures.features.salMapKEntropy.data = EK;
                            xmlFeatures.features.salHistDev.data = H;
                            xmlFeatures.features.salPoints.data = reshape(P,1,size(P,1)*size(P,2));
                            xmlFeatures.features.salSkin.data = Sk;

                            xmlUpdated = true;
                        % If the saliency package fails, then delete the entire feature 
                        % file for that image (thus removing that image from our experiments)                        
                        else
                            disp('Image cannot be processed by saliency package. Deleting feature file and skipping it...');
                            delete([featuredir filename]);                            
                            continue;
                        end                                                
                    end
                end
                

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


                % If features have been (re)computed, save the new XML file
                if xmlUpdated
                    disp('xml updated');
                    xml_save([featuredir filename],xmlFeatures);
                end

            end
        end
    end
        
    
end



end




% check if the struct "xmlFeatures" already contains
% all features given in the cell array "features"
function isTrue = allFeatInStruct(features,xmlFeatures)
    fields = fieldnames(xmlFeatures);
    isTrue = false;
    % If the XML contains no features yet, then the field "features"
    % doesn't exist yet. So check if it does. 
    if ismember('features',fields)
        if sum(ismember(features,fieldnames(xmlFeatures.features))) == length(features)
           isTrue = true; 
        end
    end
end


% check if the struct that came from the xml file already contains
% this feature (or in the case of a cell array, if it contains ONE OF the features)
% Return true if at least one of the elements in features (can be a string
% or cell array of strings) is in cellArray (a cell array of strings)
function isTrue = someFeatInCell(features,cellArray)    
    if sum(ismember(features,cellArray)) > 0
        isTrue = true;
    else
        isTrue = false;
    end
end

% Convert to greyscale image
function grayImage = convToGrey(image)
    if size(image,3) == 3
        grayImage = rgb2gray(image);
    else    
        grayImage = image(:,:,1);
    end
end

% convert to Value,Saturation, Hue image
function vshImage = convToVSH(image)
    if size(image,3) == 3
        vshImage = cvlib_mex('color',image,'rgb2hsv');
    else
        vshImage(:,:,2:3) = zeros(size(image,1),size(image,2),2);
        vshImage(:,:,1) = image(:,:,1); 
    end
end

% Check if the image has 3 channels, otherwise repeat the first channel 3
% times so that it can be used as an RGB image in external packages
function RGBImage = convToRGB(image)
    if size(image,3) == 3
        RGBImage = image;
    else
        RGBImage(:,:,1) = image(:,:,1);
        RGBImage(:,:,2) = image(:,:,1);
        RGBImage(:,:,3) = image(:,:,1);
    end
end

