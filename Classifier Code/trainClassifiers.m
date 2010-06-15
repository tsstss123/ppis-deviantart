function [ A, trainset, testset ] = trainClassifiers()

featurenamevector={'r0';'r1';'r2';'r3';'r4';'r5';'r6';'r7';'r8';'r9'};
numberofdatasets=1;

% Create Full Dataset
Dataset = 1 + 2.*abs(randn(1500, 10)); % Fake Dataset mean 1 & standard deviation

% Normalize Dataset with min max normalization
maxvector=max(Dataset);
minvector=min(Dataset);
[imagesdata, featuresdata]=size(Dataset);
for i=1:featuresdata
    Dataset(:,i)=Dataset(:,i)-minvector(i);
    Dataset(:,i)=(Dataset(:,i)/maxvector(i))-0.5;
end

for i=1:numberofdatasets
    
    outputfilename = strcat('Result\Dataset_',int2str(i),'.txt');
    outputfile = fopen(outputfilename,'w');
    
    % Use of Features
    numberoffeaturesvector=round(rand(1,featuresdata));
    featurenamesused = featurenamevector(numberoffeaturesvector==1);
    Datasetused = Dataset(:,numberoffeaturesvector==1);
    fprintf(outputfile, 'Features Used for the Results:\n\n');
    for j=1:length(featurenamesused)
        fprintf(outputfile, 'Feature: %s\n' ,featurenamesused{j});
    end
    fprintf(outputfile, '\nClassifier Error Rate\n\n');

    
    A = dataset(Datasetused,genlab([(imagesdata/2) (imagesdata/2)],{'positive', 'negative'}));
    A = setfeatlab(A,featurenamesused);
    A = setprior(A, [0.5 0.5]);
    
    %A=gendatb([750 750]);

    [trainset, testset]=gendat(A, 0.8);
    R=crossval(trainset,[],numberoffolds,0);
    
    % KNN Classifier
    Krange=10;
    besterror=1;
    bestK=-1;
    for j=1:Krange
       errorvector = zeros(1,numberoffolds);
       for p=1:numberoffolds
            currentvalidationset=trainset(R==p,:);
            currenttrainset=trainset(R~=p,:);
            W=knnc(currenttrainset,j);
            errorvector(p)=testc(currentvalidationset,W);
       end
       errorrate = mean(errorvector);
       if errorrate < besterror
           besterror=errorrate;
           bestK=j;
       end
    end
    
    fprintf(outputfile, 'K-NN Classifier\n\n');
    fprintf(outputfile, 'Optimized K-parameter: %f\n',bestK);
    fprintf(outputfile, 'Optimized Error Rate: %f\n',besterror);
    
    % Naive Bayes Classifier
    Binrange=15;
    besterror=1;
    bestBin=-1;
    for j=1:Binrange
       errorvector = zeros(1,numberoffolds);
       for p=1:numberoffolds
            currentvalidationset=trainset(R==p,:);
            currenttrainset=trainset(R~=p,:);
            W=naivebc(currenttrainset,j);
            errorvector(p)=testc(currentvalidationset,W);
       end
       errorrate = mean(errorvector);
       if errorrate < besterror
           besterror=errorrate;
           bestBin=j;
       end
    end
    
    fprintf(outputfile, '\nNaive Bayes Classifier\n\n');
    fprintf(outputfile, 'Optimized Bin-parameter: %f\n',bestBin);
    fprintf(outputfile, 'Optimized Error Rate: %f\n',besterror);
    
    % Back Propagation Neural Network
%     HiddenNodesRangeEnd=8;
%     HiddenNodesRangeBegin=2;    
%     besterror=1;
%     bestNodes=-1;
%     for j=HiddenNodesRangeBegin:HiddenNodesRangeEnd
%        errorvector = zeros(1,numberoffolds);
%        for p=1:numberoffolds
%             currentvalidationset=trainset(R==p,:);
%             currenttrainset=trainset(R~=p,:);
%             W=bpxnc(currenttrainset,j);
%             errorvector(p)=testc(currentvalidationset,W);
%        end
%        errorrate = mean(errorvector);
%        if errorrate < besterror
%            besterror=errorrate;
%            bestNodes=j;
%        end
%     end
%     
%     fprintf(outputfile, '\nBack Propagation Neural Network Classifier\n\n');
%     fprintf(outputfile, 'Optimized Nodes-parameter: %f\n',bestNodes);
%     fprintf(outputfile, 'Optimized Error Rate: %f\n',besterror);

    % Parzen Classifier
%     SmoothingRangeBegin=;
%     SmoothingRangeEnd=8;  
%     stepRange=0.1;
%     besterror=1;
%     bestSmoothing=-1;
%     for j=SmoothingRangeBegin:stepRange:SmoothingRangeEnd
%        errorvector = zeros(1,numberoffolds);
%        for p=1:numberoffolds
%             currentvalidationset=trainset(R==p,:);
%             currenttrainset=trainset(R~=p,:);
%             W=parzenc(currenttrainset,j);
%             errorvector(p)=testc(currentvalidationset,W);
%        end
%        errorrate = mean(errorvector);
%        if errorrate < besterror
%            besterror=errorrate;
%            bestSmoothing=j;
%        end
%     end
%     
%     fprintf(outputfile, '\nParzen Classifier\n\n');
%     fprintf(outputfile, 'Optimized Smoothing-parameter: %f\n',bestSmoothing);
%     fprintf(outputfile, 'Optimized Error Rate: %f\n',besterror);        
    
    fclose(outputfile);
end

