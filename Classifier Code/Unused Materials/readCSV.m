%Read in the edge ratio feature
fid=fopen('edgeRatios.txt');
edgeratiodata = textscan(fid, '%s %f', 'Delimiter',',');
fclose(fid);

%Split the edge ratio feature dataset in names and values
edgeratiodatanames = edgeratiodata{1};
edgeratiodatavalues = edgeratiodata{2};

%Read in the edge ratio feature
fid=fopen('avgHSV.txt');
hsvdata = textscan(fid, '%s %f %f %f', 'Delimiter',',');
fclose(fid);

hsvnames = hsvdata{1};
huevalues = hsvdata{2};
saturationvalues = hsvdata{3};
intensityvalues = hsvdata{4};

%Now plot 2 features against each other.
%Note we do not have the 2nd feature yet.
scatter(edgeratiodatavalues, intensityvalues, 'o');