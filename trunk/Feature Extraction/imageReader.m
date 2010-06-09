function images = imageReader(dir, files, range)
%IMAGEREADER reads NUM images from FILES
% IMAGES = IMAGEREADER(DIR, FILES, RANGE)
% IMAGES = 1*|RANGE|-sized cell vector
% DIR = directory string
% FILES = a cell array of strings with filenames
% RANGE = range of images to be read 
%
% example (win) imageReader('../deviant/', ls('../deviant/*.jpg'), [1:10])
% Created by: bjbuter

if max(range) > length(files)
    disp('Range out of Bounds')
    images = cell();
else 
    disp(sprintf('Reading %d images:', length(range)))
    images = cell(1,length(range));
    for i = 1:length(range)
        filestr = strcat(dir, files(range(i),:));
        disp(strcat('> ', filestr))
        images(1,i) = {im2double(imread(filestr))};
    end
end