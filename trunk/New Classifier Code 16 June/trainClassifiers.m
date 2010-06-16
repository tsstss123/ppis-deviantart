function [ A, trainset, testset ] = trainClassifiers()

featurenamevector={'r0';'r1'};
numberofrounds=2;
numberoffolds=5;

% Create Full Dataset
% Dataset = 1 + 2.*abs(randn(1500, 10)); % Fake Dataset mean 1 & standard deviation

%  Normalize Dataset with min max normalization
%  maxvector=max(Dataset);
%  minvector=min(Dataset);
%  [imagesdata, featuresdata]=size(Dataset);
%  for i=1:featuresdata
%      Dataset(:,i)=Dataset(:,i)-minvector(i);
%      Dataset(:,i)=(Dataset(:,i)/maxvector(i))-0.5;
%  end

featurenamesinrotation = featurenamevector;

for j=1:numberofrounds
    A=gendatb([750 750]);
    [trainset, testset]=gendat(A, 0.8);
    R=crossval(trainset,[],numberoffolds,0);
    
    for i=1:length(featurenamesinrotation)
        chosenfeaturesvector=ones(1,length(featurenamesinrotation));
        chosenfeaturesvector(i)=0;

        featurenamesused = featurenamevector(chosenfeaturesvector==1);
        featureindeces=find(chosenfeaturesvector==1);
        trainsetused = trainset(:,featureindeces);
        
        % KNN Classifier
        Krange=10;
        besterror=1;
        bestK=-1;
        for l=1:Krange
           errorvector = zeros(1,numberoffolds);
           for p=1:numberoffolds
                currentvalidationset=trainsetused(R==p,:);
                currenttrainset=trainsetused(R~=p,:);
                W=knnc(currenttrainset,j);
                errorvector(p)=testc(currentvalidationset,W);
           end
           errorrate = mean(errorvector);
           if errorrate < besterror
               besterror=errorrate;
               bestK=l;
               bestfeaturenamesused=featurenamesused;
           end
        end        
    end
end

% for i=1:numberofdatasets
%     
%     outputfilename = strcat('Result\Dataset_',int2str(i),'.txt');
%     outputfile = fopen(outputfilename,'w');
%     
%     A = dataset(Dataset,genlab([(imagesdata/2) (imagesdata/2)],{'positive', 'negative'}));
%     A = setfeatlab(A,featurenamesused);
%     A = setprior(A, [0.5 0.5]);
%     
%     %A=gendatb([750 750]);
% 
%     [trainset, testset]=gendat(A, 0.8);
%     R=crossval(trainset,[],numberoffolds,0);
%     
%     % KNN Classifier
%     Krange=10;
%     besterror=1;
%     bestK=-1;
%     for j=1:Krange
%        errorvector = zeros(1,numberoffolds);
%        for p=1:numberoffolds
%             currentvalidationset=trainset(R==p,:);
%             currenttrainset=trainset(R~=p,:);
%             W=knnc(currenttrainset,j);
%             errorvector(p)=testc(currentvalidationset,W);
%        end
%        errorrate = mean(errorvector);
%        if errorrate < besterror
%            besterror=errorrate;
%            bestK=j;
%        end
%     end
%     
%     fprintf(outputfile, 'K-NN Classifier\n\n');
%     fprintf(outputfile, 'Optimized K-parameter: %f\n',bestK);
%     fprintf(outputfile, 'Optimized Error Rate: %f\n',besterror);
%     
%     % Naive Bayes Classifier
%     Binrange=15;
%     besterror=1;
%     bestBin=-1;
%     for j=1:Binrange
%        errorvector = zeros(1,numberoffolds);
%        for p=1:numberoffolds
%             currentvalidationset=trainset(R==p,:);
%             currenttrainset=trainset(R~=p,:);
%             W=naivebc(currenttrainset,j);
%             errorvector(p)=testc(currentvalidationset,W);
%        end
%        errorrate = mean(errorvector);
%        if errorrate < besterror
%            besterror=errorrate;
%            bestBin=j;
%        end
%     end
%     
%     fprintf(outputfile, '\nNaive Bayes Classifier\n\n');
%     fprintf(outputfile, 'Optimized Bin-parameter: %f\n',bestBin);
%     fprintf(outputfile, 'Optimized Error Rate: %f\n',besterror);
%     
%     % Back Propagation Neural Network
% %     HiddenNodesRangeEnd=8;
% %     HiddenNodesRangeBegin=2;    
% %     besterror=1;
% %     bestNodes=-1;
% %     for j=HiddenNodesRangeBegin:HiddenNodesRangeEnd
% %        errorvector = zeros(1,numberoffolds);
% %        for p=1:numberoffolds
% %             currentvalidationset=trainset(R==p,:);
% %             currenttrainset=trainset(R~=p,:);
% %             W=bpxnc(currenttrainset,j);
% %             errorvector(p)=testc(currentvalidationset,W);
% %        end
% %        errorrate = mean(errorvector);
% %        if errorrate < besterror
% %            besterror=errorrate;
% %            bestNodes=j;
% %        end
% %     end
% %     
% %     fprintf(outputfile, '\nBack Propagation Neural Network Classifier\n\n');
% %     fprintf(outputfile, 'Optimized Nodes-parameter: %f\n',bestNodes);
% %     fprintf(outputfile, 'Optimized Error Rate: %f\n',besterror);
% 
%     % Parzen Classifier
% %     SmoothingRangeBegin=;
% %     SmoothingRangeEnd=8;  
% %     stepRange=0.1;
% %     besterror=1;
% %     bestSmoothing=-1;
% %     for j=SmoothingRangeBegin:stepRange:SmoothingRangeEnd
% %        errorvector = zeros(1,numberoffolds);
% %        for p=1:numberoffolds
% %             currentvalidationset=trainset(R==p,:);
% %             currenttrainset=trainset(R~=p,:);
% %             W=parzenc(currenttrainset,j);
% %             errorvector(p)=testc(currentvalidationset,W);
% %        end
% %        errorrate = mean(errorvector);
% %        if errorrate < besterror
% %            besterror=errorrate;
% %            bestSmoothing=j;
% %        end
% %     end
% %     
% %     fprintf(outputfile, '\nParzen Classifier\n\n');
% %     fprintf(outputfile, 'Optimized Smoothing-parameter: %f\n',bestSmoothing);
% %     fprintf(outputfile, 'Optimized Error Rate: %f\n',besterror);        
%     
%     fclose(outputfile);
% end

