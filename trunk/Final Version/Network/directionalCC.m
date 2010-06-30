function cc = directionalCC(Graph)
%DIRECTIONALCC calculates the directional clustering coefficients of nodes in a graph
% CC = DIRECTIONALCC(GRAPH)
% CC = verctor of directional clustering coefficients, one per node, in
%      order of Graph.Index.Values
% GRAPH = the Graph object for which clustering coefficients need to be found
%
% example cc = directionalCC(Graph)
% Created by: bjbuter


len = length(Graph.Index.Values);
cc = zeros(1,len);
for i = 1:len
    node=Graph.Index.Values(i);
    forwardIdx = ismember(Graph.Data(:,1), node);
    neighborsForward = unique(Graph.Data(forwardIdx,2));
    backwardIdx = ismember(Graph.Data(:,2), node);
    neighborsBackward = unique(Graph.Data(backwardIdx,1));
    neighbors = unique([neighborsForward;neighborsBackward]);
    degree = numel(neighbors);
    filter1Idx = ismember(Graph.Data(:,1), neighbors);
    filter2Idx = ismember(Graph.Data(:,2), neighbors);
    neighborLinks = sum(filter1Idx & filter2Idx);
    cc(i)= neighborLinks/(degree*(degree-1));
end