function [allimages, allcounts, allnames] = avgimage()

%setup paths should be moved to general setup file
project_root = ['..',filesep,'..',filesep]
addpath(genpath([project_root, 'externalpackages',filesep,'openCV']))
addpath(genpath([project_root, 'externalpackages',filesep,'Weibull']))
addpath(genpath([project_root, 'externalpackages',filesep,'xml_toolbox']))
addpath(genpath([project_root, 'externalpackages', filesep, 'SaliencyToolbox']));
% calcEdgeRatios
% imagedir = 'deviant';
% imagedir = ['..',filesep,'smallsample'];
imagedir = ['..\..\datasets',filesep,'bigdataset'];
% DIR NEEDS TO EXIST
featuredir = ['..',filesep,'features', filesep];

% files = dir(imagedir);
users = dir(imagedir);
numusers = 1
allimages = zeros([300,300,3]);
allcounts = [];
for i=1:size(users,1)
    user = users(i).name;
    disp(user)
    if user ~= '.'
        files = dir([imagedir filesep user]);
        avgim = zeros([300,300,3]);
        numfiles = 0;
        
        for j = 1:size(files,1)
            filename = files(j).name;
            isXmlFile = false;
            if size(filename,2) >= 4
                if(strcmp(filename(size(filename,2)-2:size(filename,2)),'xml'))
                   isXmlFile = true; 
                end
            end

            if isXmlFile

                matchImages = dir([imagedir filesep user filesep 'full' filesep filename(1:size(filename,2)-3) '*']); 
                disp(matchImages(1).name)
                if size(matchImages,1) < 1
                   disp(['No images with the same filename as the xml file:\n' filename '\nUser: ' user]);   
                   continue;
                else
                   % assume that there is only one image with the same filename (so not .jpg and also .png) 
                   imageFilename = matchImages(1).name;                
                end

                try
                   im = imread([imagedir filesep user filesep 'full' filesep imageFilename]);
                   thumb= cvlib_mex('resize', im, [300,300]);
                catch
                   disp('Corrupt image. Skipping it');
                   continue
                end
                if size(thumb, 3) <3
                    thumb(:,:,2) = thumb(:,:,1);
                    thumb(:,:,3) = thumb(:,:,1);
                end
                avgim = avgim + im2double(thumb);
                numfiles = numfiles +1;
            end

        end
        imshow(avgim/numfiles)
        allimages(:,:,:,numusers)=avgim;
        allcounts(numusers) = numfiles;
        allnames(numusers) = {user};
        numusers = numusers+1;
    end
end