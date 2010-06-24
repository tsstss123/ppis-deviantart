tic
artistnames={'Craniata','K1lgore','LALAax','Kitsunebaka91','NEDxfullMOon','erroid','fediaFedia','gsphoto','sujawoto','wirestyle'};

experiments={
             {'all'}
            };

train=load('ArtistDataset/Artist_train');
train=train.train;

prwarning(0);

crossfolds=5;

%knnmatrix=zeros(length(artistnames), length(artistnames));
nbmatrix=zeros(length(artistnames), length(artistnames));
%svmmatrix=zeros(length(artistnames), length(artistnames));
%mmatrix=zeros(length(artistnames), length(artistnames));

%pknnmatrix=zeros(length(artistnames), length(artistnames));
pnbmatrix=zeros(length(artistnames), length(artistnames));
%psvmmatrix=zeros(length(artistnames), length(artistnames));

for i=1:length(artistnames)
   for j=1:length(artistnames)
       if (i==j)
           continue;
       else
           names={artistnames{i}, artistnames{j}};
           fprintf('%s and %s\n\n', artistnames{i}, artistnames{j});
           
           traindata=filterArtists(train,names);
           
           labels=getlablist(traindata);
           [~,index]=ismember(artistnames{i}, labels);
           
           train_labels=getnlab(traindata);
           train_labels=train_labels==index;
           
           pos=traindata(train_labels,:);
           neg=traindata(train_labels==0,:);
           
           dpos=pos.data;
           dneg=neg.data;
           f=getfeatlab(pos);
           
           newdpos=dataset(dpos,'Positive');
           newdneg=dataset(dneg,'Negative');
           
           artistdataset=[newdpos;newdneg];
           artistdataset=setfeatlab(artistdataset,f);       
           
           % Prepare Cross Validation
           R=crossval(artistdataset,[],crossfolds,0);
           
           % Here all Classifiers
           %[bestf,k]=newKNN(artistdataset,R,crossfolds);
           %knnmatrix(i,j)=bestf;
           %pknnmatrix(i,j)=k;
           %NaiveBayes
           [bestf,b]=newNaiveBayes(artistdataset,R,crossfolds);
           nbmatrix(i,j)=bestf;
           pnbmatrix(i,j)=b;
           %Means
           %bestf=newNearestMean(artistdataset,R,crossfolds);
          % mmatrix(i,j)=bestf;
           %SVM
           %[bestf,c]=newSVM(artistdataset,R,crossfolds);
           %svmmatrix(i,j)=bestf;
          % psvmmatrix(i,j)=c;
           
           
       end
   end
%     savefile1=['Cselect2', filesep, 'knnmatrix_', int2str(i)];
     savefile2=['Cselect3', filesep, 'nbmatrix_', int2str(i)];           
%     savefile3=['Cselect2', filesep, 'mmatrix_', int2str(i)];
%     savefile4=['Cselect2', filesep, 'svmmatrix_', int2str(i)]; 
%     savefile5=['Cselect2', filesep, 'pknnmatrix_', int2str(i)];           
     savefile6=['Cselect3', filesep, 'pnbmatrix_', int2str(i)];
%     savefile7=['Cselect2', filesep, 'psvmmatrix_', int2str(i)]; 
%     
%     save(savefile1, 'knnmatrix');
     save(savefile2, 'nbmatrix');           
%     save(savefile3, 'mmatrix');
%     save(savefile4, 'svmmatrix');  
%     save(savefile5, 'pknnmatrix');           
     save(savefile6, 'pnbmatrix');
%     save(savefile7, 'psvmmatrix');      
end
toc