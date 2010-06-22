%run

%% block load
%addpath(genpath('.'));
%G = loadPajek('deviants_1168');
%Degrees = GraphCountNodesDegree(G);

%% block find core
GCoreIn = myFindCore('in', 43, G)
GCoreOut = myFindCore('out', 44, G)
GCoreAll = myFindCore('all', 185, G)

%% block degree
DFull = GraphCountNodesDegree(G);
DCoreIn = GraphCountNodesDegree(GCoreIn);
DCoreOut = GraphCountNodesDegree(GCoreOut);
DCoreAll = GraphCountNodesDegree(GCoreAll);

%% block plot all normal basis
close all;
figure
subplot(2,2,1)
hold on
plot(DFull(:,2), DFull(:,3), 'dg')
plot(DCoreIn(:,2), DCoreIn(:,3), '*')
plot(DCoreOut(:,2), DCoreOut(:,3), 'dr')
plot(DCoreAll(:,2), DCoreAll(:,3), 'hm')
title('Watching vs. Watched')
xlabel('is watching')
ylabel('watched by')
hold off
%% block plot degree In
subplot(2,2,2)
loglog(DFull(:,2), DFull(:,3), 'og')
hold on
loglog(DCoreIn(:,2), DCoreIn(:,3), '*')
title('Core based on watching')
xlabel('is watching')
ylabel('watched by')
hold off
%% block plot degree Out
subplot(2,2,3)
loglog(DFull(:,2), DFull(:,3), 'og')
hold on
loglog(DCoreOut(:,2), DCoreOut(:,3), 'dr')
title('Core based on watchers')
xlabel('is watching')
ylabel('watched by')
hold off
%% block plot degree All
subplot(2,2,4)
loglog(DFull(:,2), DFull(:,3), 'og')
hold on
loglog(DCoreAll(:,2), DCoreAll(:,3), 'hm')
title('Core based on both watchers + watching')
xlabel('is watching')
ylabel('watched by')
hold off