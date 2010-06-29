function [ datasetfeaturestruct ] = readfeatureXML( featuredirectoryname )
%   This function is used to read in all the Feature XML files where the
%   values of each feature is stored.
%   
%   The information taken from the xml files are all stored inside a
%   struct. Other functions depend on this struct format to work.
%
%
%   Input: is the directorypath containing the feature XML files
%   Output: Struct containing all the information for the dataset
%
%   Struct format looks like this:
%
%   artists - artistname - image_n - filename
%                                  - category
%                                  - artist
%                                  - features - feature1 - feature1value
%                                             - feature2 - feature2value
%                                             - featuren - featurenvalue
%
%
    
    featurefiles=dir(featuredirectoryname);
    featurefilesIndex=find(~[featurefiles.isdir]);
    
    % Names of the features that are read in
    featurenames={'numFaces';
                  'intEntropy';
                  'intVariance';
                  'edgeRatio';
                  'gridEdgeRatio';
                  'medianHue';
                  'avgSat';
                  'avgInt';
                  'medHueCells';
                  'avgSatCells';
                  'avgIntCells';
                  'cornerRatio';
                  'cornerRatioGrid';
                  'avgR';
                  'avgG';
                  'avgB';
                  'avgRCells';
                  'avgGCells';
                  'avgBCells';
                  'salEntropy';
                  'salMapCEntropy';
                  'salMapIEntropy';
                  'salMapOEntropy';
                  'salMapKEntropy';
                  'salHistDev';
                  'salPoints';
                  'salSkin';
                  'medianSat';
                  'medianInt';
                  'avgHue';
                  'medSatCells';
                  'medIntCells';
                  'avgHueCells';
                  'medianR';
                  'medianG';
                  'medianB';
                  'medRCells';
                  'medGCells';
                  'medBCells'
                 };
      
    % A struct is used to store all the data retrieved from the XML
    artiststruct=struct('artists',[]);
     
    for i=1:length(featurefilesIndex)
        featurefileName=featurefiles(featurefilesIndex(i)).name;
        disp(featurefileName);
        
        featurefilePath=[featuredirectoryname, filesep, featurefileName];
        loadedxml=xml_load(featurefilePath);
        
        % Find the artistname in the struct or create a new artist field
        % name
        artistname=loadedxml.artist;
        artistname=strrep(artistname,'-','_');
        if isfield(artiststruct.artists, artistname)
           imagenumber=length(fieldnames(artiststruct.artists.(artistname)))+1;
        else
           artiststruct.artists.(artistname)=[];
           imagenumber=1;
        end
        
        % Read and add image details to the struct
        imagenumberstr=int2str(imagenumber);
        artiststruct.artists.(artistname).(['image_' imagenumberstr]) ...
                                         .('filename')=loadedxml.filename;
                                     
        artiststruct.artists.(artistname).(['image_' imagenumberstr]) ...
                                         .('category')=loadedxml.category;
                                     
        artiststruct.artists.(artistname).(['image_' imagenumberstr]) ...
                                         .('artist')=loadedxml.artist;
         
        % Read and add the specified features intro the struct
        artistfieldnames=fieldnames(loadedxml.features);
        
        for j=1:length(artistfieldnames)
            for k=1:length(featurenames)
                if strcmp(featurenames{k},artistfieldnames{j})
                    artiststruct.artists.(artistname) ...
                                        .(['image_' imagenumberstr]) ...
                                        .('features') ...
                                        .(featurenames{k})= ...
                                        loadedxml.features.(featurenames{k});
                end
            end
        end
                                     
                                     
    end
    datasetfeaturestruct=artiststruct;
end