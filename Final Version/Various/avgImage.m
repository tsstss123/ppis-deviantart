function [avgimages, numimages, usernames] = avgImage()
%AVGIMAGE calculates the average image for all users in dataset dir
% [AVGIMAGES, AVGCOUNTS, USERNAMES] = AVGIMAGE
% AVGIMAGES = 4D array of average images  per user [R,G,B, user]
% NUMIMAGES = number of images processed per user
% USERNAMES = the names of users in order they have been stored
%
% example [img, num, names] = avgImage()
% Created by: bjbuter
%
% NOTE: paths to external packages should have been added
%       some directories & settings are hardcoded
imsize = [200,200,3];


datadir = ['datasets',filesep,'bigdataset'];
imagedir = ['..', filesep, '..', filesep, datadir];

% initialize
users = dir(imagedir);
numusers = 1;
avgimages = zeros(imsize);
numimages = [];
%% loop all users copied from extractFeatures.m
for i=1:size(users,1)
    user = users(i).name;
    disp(user)
    if user ~= '.'
        files = dir([imagedir filesep user]);
        sumim = zeros(imsize);
        numfiles = 0;
        
        % loop all files
        for j = 1:size(files,1)
            filename = files(j).name;
            isXmlFile = false;
            % is this an xml?
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
                
                % read image & resize
                try
                   im = imread([imagedir filesep user filesep 'full' filesep imageFilename]);
                   thumb= cvlib_mex('resize', im, [imsize(1),imsize(2)]);
                catch
                   disp('Corrupt image. Skipping it');
                   continue
                end
                %convert grey 2 rgb
                if size(thumb, 3) <3
                    thumb(:,:,2) = thumb(:,:,1);
                    thumb(:,:,3) = thumb(:,:,1);
                end
                sumim = sumim + im2double(thumb);
                numfiles = numfiles +1;
            end

        end
        avgimages(:,:,:,numusers)=sumim/numfiles;
        imshow(avgimages(:,:,:,numusers))
        drawnow
        numimages(numusers) = numfiles;
        usernames(numusers) = {user};
        numusers = numusers+1;
    end
end