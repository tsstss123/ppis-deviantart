%SCRIPT_COREPLOTS Find cores and make degree plots

%G, Graph variable should have been assigned before

%% block degree
DFull = GraphCountNodesDegree(G);
DCoreIn = GraphCountNodesDegree(GCoreIn);
DCoreOut = GraphCountNodesDegree(GCoreOut);
DCoreAll = GraphCountNodesDegree(GCoreAll);

%% block co-occurence

ids = {GCoreIn.Index.Values, ...
    GCoreOut.Index.Values, ...
    GCoreAll.Index.Values};

coOccurence = zeros(length(ids));
coOccurNormalised = zeros(length(ids));

for i=1:length(ids)
    for j=1:length(ids)
        coOccurence(i,j) = sum(ismember(ids{i}, ids{j}));
        coOccurNormalised(i,j) = sum(ismember(ids{i}, ids{j}))/length(ids{i});
    end
end
in = ids{1};
inOut = in(ismember(in, ids{2}));
inOutAll = inOut(ismember(inOut, ids{3}));
triOccurence = length(inOutAll);

%% block plot setup
close all;
figure

%% block plot degree In
subplot(2,2,1)
loglog(DFull(:,2), DFull(:,3), 'og')
hold on
loglog(DCoreIn(:,2), DCoreIn(:,3), '*')
index = ismember(DCoreIn(:,1), DCoreOut(:,1));
loglog(DCoreIn(index,2), DCoreIn(index,3), 'dr')
index = ismember(DCoreIn(:,1), DCoreAll(:,1));
loglog(DCoreIn(index,2), DCoreIn(index,3), 'hk')
title('Core based on watching')
xlabel('is watching')
ylabel('watched by')
hold off
%% block plot degree Out
subplot(2,2,2)
loglog(DFull(:,2), DFull(:,3), 'og')
hold on
loglog(DCoreOut(:,2), DCoreOut(:,3), 'dr')
index = ismember(DCoreOut(:,1), DCoreIn(:,1));
loglog(DCoreOut(index,2), DCoreOut(index,3), '*')
index = ismember(DCoreOut(:,1), DCoreAll(:,1));
loglog(DCoreOut(index,2), DCoreOut(index,3), 'hk')
title('Core based on watchers')
xlabel('is watching')
ylabel('watched by')
hold off
%% block plot degree All
subplot(2,2,3)
loglog(DFull(:,2), DFull(:,3), 'og')
hold on
loglog(DCoreAll(:,2), DCoreAll(:,3), 'hk')
title('Core based on both watchers + watching')
xlabel('is watching')
ylabel('watched by')
hold off
%% block plot all normal basis
subplot(2,2,4)
hold on
plot(DFull(:,2), DFull(:,3), 'dg')
plot(DCoreIn(:,2), DCoreIn(:,3), '*')
plot(DCoreOut(:,2), DCoreOut(:,3), 'dr')
plot(DCoreAll(:,2), DCoreAll(:,3), 'hm')
title('Watching vs. Watched')
xlabel('is watching')
ylabel('watched by')
hold off