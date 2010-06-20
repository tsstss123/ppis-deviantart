function [ datasetfeaturestruct ] = readallXML( featuredirectoryname )
    addpath('../externalpackages/xml_toolbox');
    
    featurefiles=dir(featuredirectoryname);
    featurefilesIndex=find(~[featurefiles.isdir]);
    
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

        artiststruct.artists.(artistname).(['image_' imagenumberstr]) ...
                                         .('features')=loadedxml.features;                              
    end
    datasetfeaturestruct=artiststruct;
end