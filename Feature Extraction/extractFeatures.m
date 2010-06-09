% calcEdgeRatios
imagedir = 'deviant';
% DIR NEEDS TO EXIST
outputdir = 'features/';

files = dir(imagedir);

doER = 0;
doAvgHSV = 0;
doFaceDetect = 0;
doCornerDetect = 1;

if doER
    outputER = fopen([outputdir,'edgeRatios.txt'], 'w');
end
if doAvgHSV
    outputAvgHSV = fopen([outputdir,'avgHSV.txt'], 'w');
end
if doFaceDetect
    outputFaceDetect = fopen([outputdir,'faceDetect.txt'], 'w');
end
if doCornerDetect
    outputCornerDetect = fopen([outputdir,'cornerDetect.txt'], 'w');
end
% outputFile = fopen(output, 'w');
% results = cell(size(files,1)-2,4);

for i = 3:size(files,1)
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
        if doFaceDetect
            numFaces = detectFaces(image);
            fprintf(outputFaceDetect,'%s,%d\n',files(i).name,numFaces);
% test code for inspecting in which images it detects faces    
%             if numFaces > 0
%                 copyfile([imagedir,'/',filename],'deviant/test/');
%             end
        end
        if doCornerDetect
            numCorners = detectCorners(image);
            fprintf(outputCornerDetect,'%s,%d\n',files(i).name,numCorners);
        end
    end
  
end

if doER
    fclose(outputER);
end
if doAvgHSV
    fclose(outputAvgHSV);
end
if doFaceDetect
    fclose(outputFaceDetect);
end
if doCornerDetect
    fclose(outputCornerDetect);
end
