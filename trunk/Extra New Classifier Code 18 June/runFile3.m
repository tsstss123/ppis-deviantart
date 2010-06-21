artistnames={'Craniata','K1lgore','Kitsunebaka91','Knuxtiger4','LALAax','Mallimaakari','Mentosik8','NEDxfullMOon','One_Vox','Pierrebfoto','Red_Priest_Usada','Skarbog','Swezzels','Udodelig','UdonNodu','WarrenLouw','erroid','fediaFedia','gsphoto','iakobos','kamilsmala','miss_mosh','nyctopterus','sekcyjny','stereoflow','sujawoto','wirestyle','woekan','zihnisinir','omega300m'}; 
%artistnames={'Craniata','Kitsunebaka91'};
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

rowcolumnlength=length(artistnames);

fmatrix1=zeros(rowcolumnlength, rowcolumnlength);
fmatrix2=zeros(rowcolumnlength, rowcolumnlength);
fmatrix3=zeros(rowcolumnlength, rowcolumnlength);
fmatrix4=zeros(rowcolumnlength, rowcolumnlength);

confmatrix=[{fmatrix1}, {fmatrix2}, {fmatrix3}, {fmatrix4}];

cmatrix1=cell(rowcolumnlength, rowcolumnlength);
cmatrix2=cell(rowcolumnlength, rowcolumnlength);
cmatrix3=cell(rowcolumnlength, rowcolumnlength);
cmatrix4=cell(rowcolumnlength, rowcolumnlength);

conffeaturematrix=[{cmatrix1}, {cmatrix2}, {cmatrix3}, {cmatrix4}];

prwarning(0);

for i=1:length(artistnames)
   for j=1:length(artistnames)
       if (i==j)
           continue;
       else
           names={artistnames{i}, artistnames{j}};
           fprintf('Pos_Artist: %s , Neg_Artist: %s\n',artistnames{i}, artistnames{j});           
           for k=1:length(optimalselect)
                traindata=filterArtists(train,names);
                testdata=filterArtists(test,names);
                
                if (autoselect(k)==1)
                    [Fv,~]=featself(traindata,'in-in',optimalselect(k));
                    
                    traindata=traindata*Fv;
                    testdata=testdata*Fv;
                end
                
                labels=getlablist(traindata);
                [~,index]=ismember(artistnames{i}, labels);
              
                train_data=traindata.data;
                train_labels=getnlab(traindata);
                train_labels=train_labels==index;
                train_labels=double(train_labels);
                
                model=svmtrain(train_labels, train_data, options);
                
                test_data=testdata.data;
                test_labels=getnlab(testdata);
                test_labels=test_labels==index;
                test_labels=double(test_labels);
                
                [predicted_labels, accuracy, prob_estimates]=svmpredict(test_labels, test_data, model);
                
                tp=sum(predicted_labels(predicted_labels==1)==1);
                fn=sum(predicted_labels(predicted_labels==1)==0);
                fp=sum(predicted_labels(predicted_labels==0)==1);
                tn=sum(predicted_labels(predicted_labels==0)==0);

                Nominator=(1+beta2)*tp;
                Denominator=((1+beta2)*tp + beta2*(fn + fp));

                Fmeasure=Nominator/Denominator;
                
                features=getfeatlab(traindata);
                
                confmatrix{k}(i,j)=Fmeasure;
                conffeaturematrix{k}{i,j}=features;
           end
       end
   end
end