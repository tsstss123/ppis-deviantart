function [ datasetfeaturestruct ] = readallXML( featuredirectoryname )
    addpath('../externalpackages/xml_toolbox');
    
    featurefiles=dir(featuredirectoryname);
    featurefilesIndex=find(~[featurefiles.isdir]);
    
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
      
    artiststruct=struct('artists',[]);
     
    for i=1:length(featurefilesIndex)
        featurefileName=featurefiles(featurefilesIndex(i)).name;
        disp(featurefileName);
        
        featurefilePath=[featuredirectoryname, filesep, featurefileName];
        loadedxml=xml_load(featurefilePath);
        
        % Find artist and its Images else Create new Artist
        artistname=loadedxml.artist;
        artistname=strrep(artistname,'-','_');
        if isfield(artiststruct.artists, artistname)
           imagenumber=length(fieldnames(artiststruct.artists.(artistname)))+1;
        else
           artiststruct.artists.(artistname)=[];
           imagenumber=1;
        end
        
        % Add fieldnames to the image entries
        imagenumberstr=int2str(imagenumber);
        artiststruct.artists.(artistname).(['image_' imagenumberstr]) ...
                                         .('filename')=loadedxml.filename;
                                     
        artiststruct.artists.(artistname).(['image_' imagenumberstr]) ...
                                         .('category')=loadedxml.category;
                                     
        artiststruct.artists.(artistname).(['image_' imagenumberstr]) ...
                                         .('artist')=loadedxml.artist;
                                     
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