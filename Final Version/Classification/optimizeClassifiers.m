function optimizeClassifiers( traindata, crossfolds )
% This function is used to compute the scores for the classifiers using 
% different ranges.
%
% Due to a large complexity of parameter settings, all parameter ranges are
% predefined. This can be changed by changing the values in the code.
%
% For now this code works with artistnames but it can easily be replaced
% with other kinds of labels like categories
%
% Due to many different outputs, the output is saved in the directory
% 'OP_results'
%
% The output of this function can be used to find the optimized parameter
% found for the classifiers by finding the mean parameter value for each
% classifier using the output parameter matrix

% The list of artistnames that are used in the parameter optimization
artistnames={'Craniata','K1lgore','LALAax','Kitsunebaka91','NEDxfullMOon','erroid','fediaFedia','gsphoto','sujawoto','wirestyle'};

prwarning(0); 

knnmatrix=zeros(length(artistnames), length(artistnames));
nbmatrix=zeros(length(artistnames), length(artistnames));
svmmatrix=zeros(length(artistnames), length(artistnames));
mmatrix=zeros(length(artistnames), length(artistnames));

pknnmatrix=zeros(length(artistnames), length(artistnames));
pnbmatrix=zeros(length(artistnames), length(artistnames));
psvmmatrix=zeros(length(artistnames), length(artistnames));

if(exist('OP_results', 'dir')==0)
    mkdir('OP_results');
end

for i=1:length(artistnames)
   for j=1:length(artistnames)
       if (i==j)
           continue;
       else
           names={artistnames{i}, artistnames{j}};
           fprintf('%s and %s\n\n', artistnames{i}, artistnames{j});
           
           pairdata=filterClasses(traindata,names);
           
           labels=getlablist(pairdata);
           [~,index]=ismember(artistnames{i}, labels);
           
           train_labels=getnlab(pairdata);
           train_labels=train_labels==index;
           
           pos=traindata(train_labels,:);
           neg=traindata(train_labels==0,:);
           
           dpos=pos.data;
           dneg=neg.data;
           f=getfeatlab(pos);
           
           newdpos=dataset(dpos,'Positive');
           newdneg=dataset(dneg,'Negative');
           
           computeddataset=[newdpos;newdneg];
           computeddataset=setfeatlab(computeddataset,f);
           
           R=crossvalRotation(computeddataset, crossfolds);
           
           % kNN with Max K = 9
           [bestf,k]=optimizekNN(computeddataset,R,9);
           knnmatrix(i,j)=bestf;
           pknnmatrix(i,j)=k;    
           
           % Naive Bayes with MinBin=4 and MaxBin=24
           [bestf,b]=optimizeNaiveBayes(computeddataset,R,4,24);
           nbmatrix(i,j)=bestf;
           pnbmatrix(i,j)=b;
           
           % Nearest Mean
           bestf=TADANearestMean(computeddataset,R);
           mmatrix(i,j)=bestf;
           
           % SVM with minC=0.1, maxC=1.5 and stepC=0.1
           [bestf,c]=optimizeSVM(computeddataset,R,0.1,1.5,0.1);
           svmmatrix(i,j)=bestf;
           psvmmatrix(i,j)=c;           
       end
   end
    savefile1=['OP_results', filesep, 'knnmatrix'];
    savefile2=['OP_results', filesep, 'nbmatrix'];           
    savefile3=['OP_results', filesep, 'nmmatrix'];
    savefile4=['OP_results', filesep, 'svmmatrix']; 
    savefile5=['OP_results', filesep, 'p_knnmatrix'];           
    savefile6=['OP_results', filesep, 'p_nbmatrix'];
    savefile7=['OP_results', filesep, 'p_svmmatrix']; 

    save(savefile1, 'knnmatrix');
    save(savefile2, 'nbmatrix');           
    save(savefile3, 'mmatrix');
    save(savefile4, 'svmmatrix');  
    save(savefile5, 'pknnmatrix');           
    save(savefile6, 'pnbmatrix');
    save(savefile7, 'psvmmatrix'); 
end

end

