function Graph = loadNetwork(filename)
%LOADNETWORK loads a network (.arcs .vert)as obtained from scraper_network.py
% GRAPH = LOADNETWORK(FILENAME)
% GRAPH = Graph object, using the Complex Networks Package for MatLab
% FILENAME = string with the filename without extensions
%
% example (win) loadNetwork('deviant_99')
% Created by: bjbuter

%make empty Graph
Graph = ObjectCreateGraph;

%parse file
disp(strcat('Opening: ', filename, '.vert'))
fid = fopen(strcat(filename, '.vert'), 'r');
verts = textscan(fid,'%d%s','delimiter',',','whitespace','');
ids = verts{1};
names = verts{2};
[ids, I] = sort(ids);
names = names(I);
fclose(fid);
disp(strcat('Closing: ', filename, '.vert'))
disp(strcat('number of vertices: ', num2str(length(verts{1}))))

%handle vertices
disp('Processing Vertices')
Graph = GraphNodeAdd(Graph, single(ids), names);

%handle arcs
disp(strcat('Opening: ', filename, '.arcs'))
arcs = dlmread(strcat(filename, '.arcs'), ',');
arcs = sortrows(arcs);

disp(strcat('Closing: ', filename, '.arcs'))
disp(strcat('number of arcs: ', num2str(length(arcs))))

% add a dummy link or we'll get an error from GraphLinkAdd\GraphLinkRemove
Graph.Data = [0,0,0];

Graph = GraphLinkAdd(Graph, arcs, true);
% remove dummy link
Graph.Data = Graph.Data(2:end,:);