%NOTE: change all the sum(ismember(....)) stuff
%NOTE: Images that cannot be processed by saliency or facedetector code are
%skipped. But when the feature extractor is executed with the saliency and facedetector
% turned off, then these images might get processed for other features and 
% then different images may have different amount of calculated features.

function extractFeatures
%setup paths should be moved to general setup file
project_root = ['..',filesep,'..',filesep]
addpath(genpath([project_root, 'externalpackages',filesep,'openCV']))
addpath(genpath([project_root, 'externalpackages',filesep,'Weibull']))
addpath(genpath([project_root, 'externalpackages',filesep,'xml_toolbox']))
addpath(genpath([project_root, 'externalpackages', filesep, 'SaliencyToolbox']));
% calcEdgeRatios
% imagedir = 'deviant';
% imagedir = ['..',filesep,'smallsample'];
imagedir = ['..',filesep,'bigdataset'];
% DIR NEEDS TO EXIST
featuredir = ['..',filesep,'features', filesep];

% files = dir(imagedir);
users = dir(imagedir);
% grouped features with same base (for example group total edge and grid edge features) because
% calculating them independently is inefficient 
features.calculate = {'edgeRatios','HSV','cornerRatio','RGB','intVariance','intEntropy','weibullFit1','weibullFit2','numFaces','saliency'};

features.recompute = {};%,'HSV'};
features.useGrayscale = {'edgeRatios','intVariance','intEntropy','weibullFit1','weibullFit2','numFaces'};
features.useHSV = {'HSV'};
features.useRGB = {'RGB','cornerRatio','saliency'};
% calcUsers = {'Eagle07','blablabla'}
% catluvr2,WarrenLouw,UdonNodu,Udodelig,Skarbog,Red_Priest_Usada,
% Pierrebfoto,
% One_Vox,NEDxfullMOon,Mentosik8,Mallimaakari,Knuxtiger4,Kitsunebaka91
% K1lgore,Craniata
skipUsers = {'catluvr2'};%{'Craniata','K1lgore','Kitsunebaka91','Knuxtiger4','LALAax','Mallimaakari','Mentosik8','NEDxfullMOon','One-Vox','Pierrebfoto','Red-Priest-Usada','Skarbog','Swezzels','Udodelig','UdonNodu','WarrenLouw','catluvr2','erroid','fediaFedia','gsphoto','iakobos','kamilsmala','miss-mosh','nyctopterus','sekcyjny','stereoflow','sujawoto','wirestyle','woekan','zihnisinir'}%,'omega300m'};

for i = 1:size(users,1)
    user = users(i).name
      
      if ismember(user,skipUsers)
          continue
      end
%     flag = false;
%     for calcUser = 1:size(calcUsers,2)
%         if strcmp(user,calcUsers{calcUser})
%             flag = true;
%         end
%     end
%     if flag
%         continue;
%     end
    % filter hidden files and '.' '..' elements
    if user ~= '.'
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
%                 user
%                 filename
%                 imageFilename = dataXml.filename;
                matchImages = dir([imagedir filesep user filesep 'full' filesep filename(1:size(filename,2)-3) '*']); 
                if size(matchImages,1) < 1
                   disp(['No images with the same filename as the xml file:\n' filename '\nUser: ' user]);   
                   continue;
                else
                   % assume that there is only one image with the same filename (so not .jpg and also .png) 
                   imageFilename = matchImages(1).name;                
                end
                
                try
                   image = imread([imagedir filesep user filesep 'full' filesep imageFilename]);
                catch
                   disp('Corrupt image. Skipping it');
                   continue
                end
                
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
                
                if someFeatInCell(features.useGrayscale, features.calculate)
                    if size(image,3) == 3
                       grayImage = rgb2gray(image);
                    else
                       clear grayImage; 
                       grayImage = image(:,:,1);
                    end
                    
                    % number of faces detected
                    feature = 'numFaces';
                    if (sum(ismember(features.calculate,feature)) > 0) && ((~allFeatInStruct(feature,xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)
                        try
                            numFaces = detectFaces(grayImage,project_root);
                            xmlFeatures.features.numFaces.data = numFaces;
                            xmlUpdated = true;
                        catch
                            disp('Image cannot be processed by opencv face detector. Deleting feature file and skipping it...');
                            delete([featuredir filename]);                            
                            continue;
                        end
                    end
                    
                    % entropy of the intensity image
                    feature = 'intEntropy';
                    if (sum(ismember(features.calculate,feature)) > 0) && ((~allFeatInStruct(feature,xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)
                        intEnt = intEntropy(grayImage);
                        xmlFeatures.features.intEntropy.data = intEnt;
                        xmlUpdated = true;
                    end
                    
                    % variance of the intensity image
                    feature = 'intVariance';
                    if (sum(ismember(features.calculate,feature)) > 0) && ((~allFeatInStruct(feature,xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)
                        intVar = intVariance(grayImage);
                        xmlFeatures.features.intVariance.data = intVar;
                        xmlUpdated = true;
                    end
                    
                    feature = 'weibullFit1';
                    epsilon = 0.001;
                    weibullGray = im2double(grayImage);                    
                    weibullGray(weibullGray == 0) = epsilon;
                    if (sum(ismember(features.calculate,feature)) > 0) && ((~allFeatInStruct(feature,xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)
%                         filename
                        [scale shape location] = weibullMle(weibullGray, 0, 0); % for raw data
                        % Do all 3 parameter? or just 2?
                        xmlFeatures.features.weibullFit1.data = [scale,shape,location];
                        xmlUpdated = true;
                    end

                    feature = 'weibullFit2';
                    if (sum(ismember(features.calculate,feature)) > 0) && ((~allFeatInStruct(feature,xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)
                        [scale shape location] = integWeibullMle(weibullGray,'x', 1, 0); % for raw data
                        % Do all 3 parameter? or just 2?
                        xmlFeatures.features.weibullFit2.data = [scale,shape,location];
                        xmlUpdated = true;
                    end


                    % EDGE RATIOS of total image and of parts of image)
                    % I grouped the edgeRatio and gridEdgeRatio features under the
                    % "edgeRatios" flag. If this flag is set in features.calculate,
                    % then all edge ratio features are calculated.
                    feature = 'edgeRatios';
                    if (sum(ismember(features.calculate,feature)) > 0) && ((~allFeatInStruct({'edgeRatio','gridEdgeRatio'},xmlFeatures))  || sum(ismember(features.recompute,feature)) > 0)
                        [totalRatio,cellRatios] = calcEdgeRatios(grayImage);
                        xmlFeatures.features.edgeRatio.data = totalRatio;
                        xmlFeatures.features.gridEdgeRatio.data = cellRatios;
                        xmlUpdated = true;
                    end

                    
                end
                
                if someFeatInCell(features.useHSV,features.calculate)
                    if size(image,3) == 3
                        vshImage = cvlib_mex('color',image,'rgb2hsv');
                    else
                        clear vshImage; 
                        vshImage(:,:,2:3) = zeros(size(image,1),size(image,2),2);
                        vshImage(:,:,1) = image(:,:,1); 
                    end
                    
                    % HSV information of total image and of parts of image
                    % I grouped all the HSV related features under the
                    % "HSV" flag. If this flag is set in features.calculate,
                    % then all HSV related features are calculated.
                    feature = 'HSV';
                    if (sum(ismember(features.calculate,feature)) > 0) && ((~allFeatInStruct({'medianHue','medianSat','medianInt','avgHue','avgSat','avgInt','medHueCells','medSatCells','medIntCells','avgHueCells','avgSatCells','avgIntCells'},xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)
%                         [medianHue,avgSat,avgInt,medHueCells,avgSatCells,avgIntCells] = calcHSV(vshImage);
                        [medianHue,medianSat,medianInt,avgHue,avgSat,avgInt,medHueCells,medSatCells,medIntCells,avgHueCells,avgSatCells,avgIntCells] = calcHSV(vshImage);
                        xmlFeatures.features.medianHue.data = medianHue;
                        xmlFeatures.features.medianSat.data = medianSat;
                        xmlFeatures.features.medianInt.data = medianInt;
                        xmlFeatures.features.avgHue.data = avgHue;
                        xmlFeatures.features.avgSat.data = avgSat;
                        xmlFeatures.features.avgInt.data = avgInt;
                        xmlFeatures.features.medHueCells.data = medHueCells;
                        xmlFeatures.features.medSatCells.data = medSatCells;
                        xmlFeatures.features.medIntCells.data = medIntCells;
                        xmlFeatures.features.avgHueCells.data = avgHueCells;
                        xmlFeatures.features.avgSatCells.data = avgSatCells;
                        xmlFeatures.features.avgIntCells.data = avgIntCells;
                        xmlUpdated = true;
                    end
                    
                end
                
                if someFeatInCell(features.useRGB,features.calculate)
                    if size(image,3) == 3
                        RGBImage = image;
                    else
                        clear RGBImage;
                        RGBImage(:,:,1) = image(:,:,1);
                        RGBImage(:,:,2) = image(:,:,1);
                        RGBImage(:,:,3) = image(:,:,1);
                    end
                    
                    % corner ratio
                    feature = 'cornerRatio';
                    
                    % only calc if feature is set to be calculated. And only if the
                    % feature is not already present in the xml file (or if the
                    % recompute flag is set).
                    if (sum(ismember(features.calculate,feature)) > 0) && ((~allFeatInStruct({'cornerRatio','cornerRatioGrid'},xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)
                        [cornerRatio, cornerRatioGrid] = detectCorners(RGBImage);
                        xmlFeatures.features.cornerRatio.data = cornerRatio;
                        xmlFeatures.features.cornerRatioGrid.data = cornerRatioGrid;
                        xmlUpdated = true;
                    end

                    % avg RGB
                    feature = 'RGB';
                    if (sum(ismember(features.calculate,feature)) > 0) && ((~allFeatInStruct({'medianR','medianG','medianB','avgR','avgG','avgB','medRCells','medGCells','medBCells','avgRCells','avgGCells','avgBCells'},xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)
%                         [avgR,avgG,avgB,avgRCells,avgGCells,avgBCells] = calcRGB(RGBImage);
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
                    
                    % Amount of Skin normalized???????????????????
                    feature = 'saliency';
                    if (sum(ismember(features.calculate,feature)) > 0) && ((~allFeatInStruct({'salEntropy','salMapCEntropy','salMapIEntropy','salMapOEntropy','salMapKEntropy'},xmlFeatures)) || sum(ismember(features.recompute,feature)) > 0)
                        numberPoints = 3;
                        params = set_parameters(RGBImage);
                        salSucces = false;
                        salCount = 0;
                        salRGBImage = RGBImage;
                        while (salSucces == false) && (salCount < 3)
                           try
                              [salMap, salData] = generateSaliencyMap(salRGBImage, params);
                              salSucces = true;
                           catch
                              disp('Image cannot be processed by saliency package. Resizing it...');
%                             delete([featuredir filename]);
                              if size(salRGBImage,1)*size(salRGBImage,2) < 750000
                                  salRGBImage = imresize(salRGBImage,2);
                                  salCount = salCount+1;                                                            
                              else
                                  break;
                              end
%                               salRGBImage = imresize(salRGBImage,2);
                              
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
                            xmlFeatures.features.salPoints.data = reshape(P,1,size(P,1),size(P,2));
                            xmlFeatures.features.salSkin.data = Sk;

                            xmlUpdated = true;
                        else
                            disp('Image cannot be processed by saliency package. Deleting feature file and skipping it...');
                            delete([featuredir filename]);                            
                            continue;
                        end                                                
                    end
                end
                

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


                % If features have been computed, save the new XML file
                if xmlUpdated
                     disp('xml updated');
%                    lala = fieldnames(xmlFeatures.features); 
%                    for i = 1:size(lala,1)
% %                       xmlFeatures
%                       lala{i}  
%                       xmlFeatures.features.(lala{i}).data 
%                    end
                   xml_save([featuredir filename],xmlFeatures);
                end

            end
        end
    end
        
    
end



end


% check if the struct that came from the xml file already contains
% this feature (or in the case of a cell array, if it contains ALL the features)
function isTrue = allFeatInStruct(feature,xmlFeatures)
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

% check if the struct that came from the xml file already contains
% this feature (or in the case of a cell array, if it contains ONE OF the features)
function isTrue = someFeatInCell(feature,cellArray)
%     fields = fieldnames(xmlFeatures);
%     isTrue = false;
    % if it's a list of features
    
    if sum(ismember(feature,cellArray)) > 0
        isTrue = true;
    else
        isTrue = false;
    end
%     
%     if sum(ismember(fields,'features')) > 0
%         if iscell(feature)            
%             for i = 1:size(feature,2)
%                 if sum(ismember(fieldnames(xmlFeatures.features),feature{i})) > 0
%                     isTrue = true;
%                 else
%                     isTrue = false;
% %                     breaking = 0
%                     break;
%                 end
%             end
%             % if it's a single feature
%         else
%             if sum(ismember(fieldnames(xmlFeatures.features),feature)) > 0
%                 isTrue = true;
%             end
%         end
%     end
% %     disp('some feat in struct returns:')
% %     isTrue
% %     if
end


