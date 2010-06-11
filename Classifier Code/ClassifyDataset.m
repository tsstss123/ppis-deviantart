function ClassifyDataset( A, trainpercentage, varargin )

knn_neighbours = 3;
bnn_nonodes = 3;

classifiernames = {'KNN', ...
                   'BNN', ...
                   'LDC', ...
                   'QDC', ...
                   'PARZENC', ...
                   'PARZENDC', ...
                   'TREEC', ...
                   'SVC', ...
                   'PERLC', ...
                   'NEURC'};

classifierfunctions = {knnc([],knn_neighbours), ...
                       bpxnc([],bnn_nonodes), ...
                       ldc, ...
                       qdc, ...
                       parzenc, ...
                       parzendc, ...
                       treec, ...
                       svc, ...
                       perlc, ...
                       neurc};

% Find the user specified classifier(s)
classifierinputvector = zeros(1, length(classifiernames));
for k=1:length(varargin)
    compare = strcmp(classifiernames, varargin(k));
    classifierinputvector = classifierinputvector+compare;  
end
classifierfunctions = classifierfunctions(classifierinputvector==1);

% Split in training and test set
[train,test] = gendat(A, trainpercentage);

% Train the classifiers
V = train*classifierfunctions;

% Output the Classfier Statistics
disp([newline 'Output Error Rate'])
testc(test,V)

disp([newline 'Output Precision'])
testc(test,V,'precision')

disp([newline 'Output False Negatives'])
testc(test,V,'FN')

disp([newline 'Output True Positives'])
testc(test,V,'TP')

end