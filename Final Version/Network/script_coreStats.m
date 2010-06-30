%SCRIPT_CORESTATS Find cores, calculate and show statistics on cores
%
%G, Graph variable should have been assigned before
%% find cores
names = {'watchers', 'watched', 'mixed'};
cores = cell(1,3);
cores(1) = {findCore('in',43,G)};
cores(2) = {findCore('out',44,G)};
cores(3) = {findCore('all',185,G)};

%% for loop block
for i=1:3
    disp(names(i));
    Graph = cores{i};
    
    %Number of nodes in graph:
    n = GraphCountNumberOfNodes(Graph);
    fprintf('Number of Nodes: %d\n',n);
    %Number of links in graph:
    l = GraphCountNumberOfLinks(Graph);
    fprintf('Number of Links: %d\n',l);
    %Average degree:
    degrees = GraphCountNodesDegree(Graph);
    k = mean(degrees(:,2));
    fprintf('Average Node Degree: %2.2f\n',k);
    %Characteristic path length for similar sized random net
    fprintf('L_random: %2.2f\n',log(n)/log(k));
    %Clustering Coefficient
    ccs  = directionalCC(Graph);
    cc = mean(ccs);
    fprintf('Clustering Coefficient: %2.2f\n',cc);
end