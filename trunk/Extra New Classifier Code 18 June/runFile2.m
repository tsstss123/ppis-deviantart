%artistnames={'Craniata','K1lgore','Kitsunebaka91','Knuxtiger4','LALAax','Mallimaakari','Mentosik8','NEDxfullMOon','One_Vox','Pierrebfoto','Red_Priest_Usada','Skarbog','Swezzels','Udodelig','UdonNodu','WarrenLouw','erroid','fediaFedia','gsphoto','iakobos','kamilsmala','miss_mosh','nyctopterus','sekcyjny','stereoflow','sujawoto','wirestyle','woekan','zihnisinir','omega300m'}; 
artistnames={'Craniata','Kitsunebaka91'};
experiments={
             {'all'}
            };
        
autoselect=[0,1,1,1];
optimalselect=[0,1,2,3];

train=load('ArtistDataset/Artist_train');
train=train.train;

test=load('ArtistDataset/Artist_test');
test=test.test;

beta=1;

beta2=beta^2;

options=sprintf('-t 0 -w1 1 -w2 1 -c 0.9');
        
for i=1:length(artistnames)
   for j=1:length(artistnames)
       if (i==j)
           continue;
       else
           names={artistnames{i}, artistnames{j}};
           for k=1:length(optimalselect)
                Q=ArtistExperiment('artist',names,experiments,autoselect(k),optimalselect(k));
                [F,I]=rankClassifiers(Q);
                
                BestParameters=I{1}.('Parameters'); 
                featurecombo=fieldnames(I{1}.('Features'));
                
                traindata=filterArtists(train,names);
                testdata=filterArtists(test,names);
                
                traindata=filterFeatures2(traindata, featurecombo);
                testdata=filterFeatures2(testdata, featurecombo);
                
                train_data=traindata.data;
                temp_labels=getnlab(traindata);
                train_labels=-(temp_labels-2);
                model=svmtrain(train_labels, train_data, BestParameters);
                
                test_data=testdata.data;
                temp_labels2=getnlab(testdata);
                test_labels=-(temp_labels2-2);    
                [predicted_labels, accuracy, prob_estimates]=svmpredict(test_labels, test_data, model);
                
                tp=sum(predicted_labels(predicted_labels==1)==1);
                fn=sum(predicted_labels(predicted_labels==1)==0);
                fp=sum(predicted_labels(predicted_labels==0)==1);
                tn=sum(predicted_labels(predicted_labels==0)==0);

                Nominator=(1+beta2)*tp;
                Denominator=((1+beta2)*tp + beta2*(fn + fp));

                Fscore=Nominator/Denominator;       
           end
       end
   end
end