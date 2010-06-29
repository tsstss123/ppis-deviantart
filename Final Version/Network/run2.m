%run2

addpath(genpath('.'))

Gwatchers = myFindCore('in',43,G)
Gwatchered = myFindCore('out',44,G)
Gmixed = myFindCore('all',185,G)

%% CC
CCwatchers  = myCC(Gwatchers);
CC1 = mean(CCwatchers)
CCwatchered = myCC(Gwatchered);
CC2 = mean(CCwatchered)
CCmixed = myCC(Gmixed);
CC3 = mean(CCmixed)

%%
 disp(sprintf('Number of Nodes: %d',GraphCountNumberOfNodes(Gwatchers)));
 %Number of links in graph:
 disp(sprintf('Number of Links: %d',GraphCountNumberOfLinks(Gwatchers)));
 %Average degree:
 Degrees1 = GraphCountNodesDegree(Gwatchers);
 disp(sprintf('Average Node Degree: %2.2f',mean(Degrees1(:,2))));
 Lr1 = log(GraphCountNumberOfNodes(Gwatchers))/log(mean(Degrees1(:,2)))
 
 %%
 Gwatched = Gwatchered;
 disp(sprintf('Number of Nodes: %d',GraphCountNumberOfNodes(Gwatched)));
 %Number of links in graph:
 disp(sprintf('Number of Links: %d',GraphCountNumberOfLinks(Gwatched)));
 %Average degree:
 Degrees2 = GraphCountNodesDegree(Gwatched);
 disp(sprintf('Average Node Degree: %2.2f',mean(Degrees2(:,2))));
 Lr2 = log(GraphCountNumberOfNodes(Gwatchered))/log(mean(Degrees2(:,2)))
 
 disp(sprintf('Number of Nodes: %d',GraphCountNumberOfNodes(Gmixed)));
 %Number of links in graph:
 disp(sprintf('Number of Links: %d',GraphCountNumberOfLinks(Gmixed)));
 %Average degree:
 Degrees3 = GraphCountNodesDegree(Gmixed);
 disp(sprintf('Average Node Degree: %2.2f',mean(Degrees3(:,2))));
 Lr3 = log(GraphCountNumberOfNodes(Gmixed))/log(mean(Degrees3(:,2)))