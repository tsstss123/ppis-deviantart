function Graph = loadPajek(filename)
%LOADPAJEK loads a Pajek style network as used in DA project
% GRAPH = LOADPAJEK(FILENAME)
% GRAPH = Graph object
% FILENAME = string with Pajek file 
%
% example (win) loadPajek('deviant_-99.net')
% Created by: bjbuter

%make empty Graph
Graph = ObjectCreateGraph;

disp(strcat('Opening: ', filename, '.vert'))
fid = fopen(strcat(filename, '.vert'), 'r');
verts = textscan(fid,'%d%s','delimiter',',','whitespace','');
ids = verts{1};
names = verts{2};
[ids, I] = sort(ids);
names = names(I);
fid = fclose(fid);
disp(strcat('Closing: ', filename, '.vert'))
disp(strcat('number of vertices: ', num2str(length(verts{1}))))

%handle vertices
disp('Processing Vertices')
Graph = GraphNodeAdd(Graph, single(ids), names);

disp(strcat('Opening: ', filename, '.arcs'))
arcs = dlmread(strcat(filename, '.arcs'), ',');
arcs = sortrows(arcs);
%arcs = textscan(fid,'%d%d%d','delimiter',',','whitespace','');
disp(strcat('Closing: ', filename, '.arcs'))
disp(strcat('number of arcs: ', num2str(length(arcs))))

% add a dummy link or we'll get an error from GraphLinkAdd\GraphLinkRemove
Graph.Data = [0,0,0];

Graph = GraphLinkAdd(Graph, arcs, true);
% remove dummy link
Graph.Data = Graph.Data(2:end,:);
%Graph = mexGraphSqueeze(Graph)

%handle first arc\edge line
%arcs_or_edges = char(sscanf(temp{i+2}, '*%s %*s', inf))
%if strcmp('Arcs', arcs_or_edges)
%    arcs = true
%elseif strcmp('Edges', arcs_or_edges)
%    arcs = false
%else
%    disp 'error in Pajek file format'
%end

% 
% 
% disp('Processing Arcs')
% while i <= length(temp)
%     if mod(i, 10000)==0
%         disp(strcat('line: ', num2str(i)))
%     end
%     link = sscanf(temp{i}, '%d %d %d %*s %*d', [1, inf]);
%     link = link(1:2); %only the first 2 ints are interesting
%     Graph = GraphLinkAdd(Graph, link, true);
%     i = i+1;
% end
% disp(strcat('number of arcs: ', num2str(i-3-numVertices)))
% 