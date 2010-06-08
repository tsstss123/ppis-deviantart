% calcEdgeRatios
imagedir = 'deviant';
% DIR NEEDS TO EXIST
outputdir = 'features/';

files = dir(imagedir);

doER = 1;
doAvgHSV = 1;

if doER
    outputER = fopen([outputdir,'edgeRatios.txt'], 'w');
end
if doAvgHSV
    outputAvgHSV = fopen([outputdir,'avgHSV.txt'], 'w');
end
% outputFile = fopen(output, 'w');
% results = cell(size(files,1)-2,4);

for i = 3:103%size(files,1)
    i
    filename = files(i).name;
    if(strcmp(filename(size(filename,2)-2:size(filename,2)),'jpg') || strcmp(filename(size(filename,2)-2:size(filename,2)),'png') )
        % Image from which features must be extracted
        image = imread(strcat(imagedir,'/',files(i).name));
        
        if doER
            edgeRatio = calcEdgeRatio(image);
            fprintf(outputER,'%s,%f\n',files(i).name,edgeRatio);
        end
        if doAvgHSV
            [avgHue,avgSat,avgInt] = calcAvgHSV(image);
            fprintf(outputAvgHSV,'%s,%f,%f,%f\n',files(i).name,avgHue,avgSat,avgInt);
        end
    end
  
end

if doER
    fclose(outputER);
end
if doAvgHSV
    fclose(outputAvgHSV);
end

