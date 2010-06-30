%SCRIPT_TUTORIAL Script as provided on the Complex Networks Package for MatLab website
%slow parts are commented out
%
%G, Graph variable should have been assigned before
Graph = G;

close all
%+++Some basic statistics:
disp 'Some basic statistics:'
%Number of nodes in graph:
disp(sprintf('Number of Nodes: %d',GraphCountNumberOfNodes(Graph)));
%Number of links in graph:
disp(sprintf('Number of Links: %d',GraphCountNumberOfLinks(Graph)));
%Average degree:
Degrees = GraphCountNodesDegree(Graph);
Degrees(:,4)=(Degrees(:,2)+Degrees(:,3))/2;
disp(sprintf('Average Node Degree: %2.2f',mean(Degrees(:,2))));

%Find fraction of reciprocal links:
Reciprocal = GraphCountUnderectionality(Graph);
disp(sprintf('Fraction of reciprocal links: %2.2f%%',Reciprocal.DoubleConnectivityFraction*100));
% Clustering coefficient:
CC = mexGraphClusteringCoefficient(Graph);
disp(sprintf('Average Clustering Coefficient: %3.3f%%',CC.C));

%+++Node Degree Distribution:
disp 'Node Degree Distribution:'
h1 = figure;
subplot(2,2,1)
% incoming:
[y x] = hist(Degrees(:,2),unique(Degrees(:,2)));
loglog(x,y/sum(y),'*r');
xlabel('k,Degree');
 ylabel('P(k)');
 title('Incoming');
%hold on
% outgoing
subplot(2,2,2)
[y x] = hist(Degrees(:,3),unique(Degrees(:,3)));
loglog(x,y/sum(y),'dg');
xlabel('k,Degree');
 ylabel('P(k)');
 title('Outgoing');
% ototal
subplot(2,2,3)
[y x] = hist(Degrees(:,4),unique(Degrees(:,4)));
loglog(x,y/sum(y),'hm');
xlabel('k,Degree');
 ylabel('P(k)');
 title('(In + Out)/2');
subplot(2,2,4)

[y x] = hist(Degrees(:,2),unique(Degrees(:,2)));
loglog(x,y/sum(y),'*r');
hold on
% outgoing
[y x] = hist(Degrees(:,3),unique(Degrees(:,3)));
loglog(x,y/sum(y),'dg');
% ototal
[y x] = hist(Degrees(:,4),unique(Degrees(:,4)));
loglog(x,y/sum(y),'hm');

% expected distribution:
%loglog(XAxis,YAxis/sum(YAxis),':b');
% x = xlim;
% y = ylim;
% y = [y(2),y(1)]
% loglog(x, y/sum(y))
% 
 xlabel('k,Degree');
 ylabel('P(k)');
 title('Node Degree Distribution');
 legend({'Incoming','Outgoing','(In+Out)/2'});
% 
% %+++Clustering Coefficient Distribution
% disp 'Clustering Coefficient Distribution'
% h2= figure;
% % direct
% CCin = mexGraphClusteringCoefficient(Graph,[],'direct');
% [y x] = hist(CCin.NodeClusteringCoefficient,linspace(0,1,25));
% plot(x(x>0),y(x>0)/sum(y),'*r');
% hold on;
% % inverse
% CCout = mexGraphClusteringCoefficient(Graph,[],'inverse');
% [y x] = hist(CCout.NodeClusteringCoefficient,linspace(0,1,25));
% plot(x(x>0),y(x>0)/sum(y),'dg')
% xlabel('CC, clustering coefficient');
% ylabel('P(CC)');
% title('Clustering coefficient distribution (CC>0)');
% legend({'Direct','Inverse'});
% 
% %+++Clustering Coefficient Dependence on Degree
% disp 'Clustering Coefficient Dependence on Degree'
% h3 = figure;
% % direct
% loglog(CCin.k,CCin.Ck,'*r');
% hold on;
% % inverse
% loglog(CCout.k,CCout.Ck,'dg');
% 
% xlabel('k, Degree');
% ylabel('<CC(k)>, clustering coefficient');
% title('Average clustering coefficient as a function of degree');
% legend({'Direct','Inverse'});

%+++Components
% disp 'Components'
% TempGraph=Graph;
% NodesToRemovePerStep =1;
% NumbersOfNodes = [];
% NumbersOfLinks = [];
% NumbersOfComponents = [];
% LargestClusterSizes = [];
% SecondLargestClusterSizes = [];
% 
% RemainingNodes = 1:GraphCountNumberOfNodes(Graph);
% 
% while ~isempty(RemainingNodes)
%     NodeIndecesToRemove = unique(round(rand(NodesToRemovePerStep,1)*(numel(RemainingNodes)-1))+1);
%     NodesToRemove = RemainingNodes(NodeIndecesToRemove);
%     RemainingNodes = setdiff(RemainingNodes,NodesToRemove);
%     TempGraph = mexGraphNodeRemove(TempGraph,NodesToRemove);
%     NumbersOfNodes(end+1) = GraphCountNumberOfNodes(TempGraph);
%     NumbersOfLinks(end+1) = GraphCountNumberOfLinks(TempGraph);
%     if NumbersOfLinks(end)>0
%         Components = mexGraphConnectedComponents(TempGraph);
%         NumbersOfComponents(end+1) = numel(Components);
%         ComponentsSizes = sort(cellfun('length',Components),'descend');
%         if ~isempty(ComponentsSizes)
%             LargestClusterSizes(end+1) = ComponentsSizes(1);
%         else
%             LargestClusterSizes(end+1) = 0;
%         end
%         if numel(ComponentsSizes)>1
%             SecondLargestClusterSizes(end+1) = ComponentsSizes(2);
%         else
%             SecondLargestClusterSizes(end+1) = 0;
%         end
%     else
%         NumbersOfComponents(end+1) = 0;
%         LargestClusterSizes(end+1) = 0;
%         SecondLargestClusterSizes(end+1) = 0;
%     end
% end
% h4 = figure;
% plot(NumbersOfComponents,'r');
% hold on;
% h5 = figure;
% plot(NumbersOfNodes,'r');
% hold on;
% h6 = figure;
% plot(NumbersOfLinks,'r');
% hold on;
% h7 = figure;
% plot(SecondLargestClusterSizes,'r');
% hold on;
% h8=figure;
% plot(LargestClusterSizes,'r');
% hold on;
% 
% 
% %+++remove most connected nodes (with highest outgoing degree)
% disp 'remove most connected nodes (with highest outgoing degree)'
% TempGraph=Graph;
% NodesToRemovePerStep =1;
% NumbersOfNodes = [];
% NumbersOfLinks = [];
% NumbersOfComponents = [];
% LargestClusterSizes = [];
% SecondLargestClusterSizes = [];
% 
% RemainingNodes = 1:NumberOfNodes;
% 
% while ~isempty(TempGraph.Data)
%     Degrees = GraphCountNodesDegree(TempGraph);
%     [OutDegrees SortOrder]=sort( Degrees(:,3),'descend');
%     NodesToRemove = Degrees(SortOrder(1:min([numel(SortOrder) NodesToRemovePerStep])));
%     TempGraph = mexGraphNodeRemove(TempGraph,NodesToRemove);
%     NumbersOfNodes(end+1) = GraphCountNumberOfNodes(TempGraph);
%     NumbersOfLinks(end+1) = GraphCountNumberOfLinks(TempGraph);
%     if NumbersOfLinks(end)>0
%         Components = mexGraphConnectedComponents(TempGraph);
%         NumbersOfComponents(end+1) = numel(Components);
%         ComponentsSizes = sort(cellfun('length',Components),'descend');
%         if ~isempty(ComponentsSizes)
%             LargestClusterSizes(end+1) = ComponentsSizes(1);
%         else
%             LargestClusterSizes(end+1) = 0;
%         end
%         if numel(ComponentsSizes)>1
%             SecondLargestClusterSizes(end+1) = ComponentsSizes(2);
%         else
%             SecondLargestClusterSizes(end+1) = 0;
%         end
%     else
%         NumbersOfComponents(end+1) = 0;
%         LargestClusterSizes(end+1) = 0;
%         SecondLargestClusterSizes(end+1) = 0;
%     end
% end
% figure(h4)
% plot(NumbersOfComponents,'g');
% xlabel('Step');
% ylabel('Number of components');
% legend({'Random','Targeted'});
% figure(h5)
% plot(NumbersOfNodes,'g');
% xlabel('Step');
% ylabel('Number of Nodes');
% legend({'Random','Targeted'});
% figure(h6)
% plot(NumbersOfLinks,'g');
% xlabel('Step');
% ylabel('Number of Links');
% legend({'Random','Targeted'});
% figure(h7);
% plot(SecondLargestClusterSizes,'g');
% xlabel('Step');
% ylabel('Cluster Size');
% title('Size of SECOND largest cluster');
% legend({'Random','Targeted'});
% figure(h8);
% plot(LargestClusterSizes,'g');
% xlabel('Step');
% ylabel('Cluster Size');
% title('Size of largest cluster');
% legend({'Random','Targeted'});

