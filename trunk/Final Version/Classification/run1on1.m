function run1on1( train, test )
% This function was used to compute the results for the image experiment 
% in the report.
% This function uses SVM to compute all the scores and find the
% featuresets like in the report.
%
%   Input: Train set and the Test set in PRTools Dataset Format
%

% List of Artist names that are used
artistnames={'Craniata','K1lgore','Kitsunebaka91','Knuxtiger4','LALAax','Mallimaakari','Mentosik8','NEDxfullMOon','One_Vox','Pierrebfoto','Red_Priest_Usada','Skarbog','Swezzels','Udodelig','UdonNodu','WarrenLouw','erroid','fediaFedia','gsphoto','iakobos','kamilsmala','miss_mosh','nyctopterus','sekcyjny','stereoflow','sujawoto','wirestyle','woekan','zihnisinir','omega300m'};

% List of parameters that the file should loop through
% autoselect=0 means feature selection off and 1 mean on
% optimalselect 1-5 means find the best 1-5 features
autoselect=[0,1,1,1,1,1];
optimalselect=[0,1,2,3,4,5];

% Options for the used SVM
options=sprintf('-t 0 -w0 1 -w1 10 -c 0.9');

% Initializes all the output Matrices
rowcolumnlength=length(artistnames);

fmatrix1=zeros(rowcolumnlength, rowcolumnlength);
fmatrix2=zeros(rowcolumnlength, rowcolumnlength);
fmatrix3=zeros(rowcolumnlength, rowcolumnlength);
fmatrix4=zeros(rowcolumnlength, rowcolumnlength);
fmatrix5=zeros(rowcolumnlength, rowcolumnlength);
fmatrix6=zeros(rowcolumnlength, rowcolumnlength);

confmatrix=[{fmatrix1},{fmatrix2}, {fmatrix3}, {fmatrix4}, {fmatrix5}, {fmatrix6}];

cmatrix1=cell(rowcolumnlength, rowcolumnlength);
cmatrix2=cell(rowcolumnlength, rowcolumnlength);
cmatrix3=cell(rowcolumnlength, rowcolumnlength);
cmatrix4=cell(rowcolumnlength, rowcolumnlength);
cmatrix5=cell(rowcolumnlength, rowcolumnlength);
cmatrix6=cell(rowcolumnlength, rowcolumnlength);

conffeaturematrix=[{cmatrix1},{cmatrix2}, {cmatrix3}, {cmatrix4}, {cmatrix5}, {cmatrix6}];

prwarning(0);

if(exist('run1on1_output', 'dir')==0)
    mkdir('run1on1_output');
end

for i=1:length(artistnames)
   for j=1:length(artistnames)
       if (i==j)
           continue;
       else
           names={artistnames{i}, artistnames{j}};
           fprintf('\n\nArtist: %s , Artist: %s\n\n',artistnames{i}, artistnames{j});           
           for k=1:length(optimalselect)
                traindata=filterClasses(train,names);
                testdata=filterClasses(test,names);
                
                if (autoselect(k)==1)
                    [traindata, Fv]=Featureselection( traindata, optimalselect(k));
                    testdata=testdata*Fv;
                end
                
                % Converting PRTools format to LibSVM
                labels=getlablist(traindata);
                [~,index]=ismember(artistnames{i}, labels);
              
                train_data=traindata.data;
                train_labels=getnlab(traindata);
                train_labels=train_labels==index;
                train_labels=double(train_labels);
                
                test_data=testdata.data;
                test_labels=getnlab(testdata);
                test_labels=test_labels==index;
                test_labels=double(test_labels);
                
                % Training and Predicting with libSVM
                model=svmtrain(train_labels, train_data, options);
                [predicted_labels, ~, ~]=svmpredict(test_labels, test_data, model);
                
                % Computing Evaluation Measures
                tp=sum(predicted_labels(test_labels==1)==1);
                fn=sum(predicted_labels(test_labels==1)==0);
                fp=sum(predicted_labels(test_labels==0)==1);
                tn=sum(predicted_labels(test_labels==0)==0);
                
                Fmeasure=computeFmeasure(tp,fp,fn);
                
                fprintf('Fmeasure: %f, tp: %f , fn: %f , fp: %f , tn: %f\n', Fmeasure, tp, fn, fp, tn);
                
                features=getfeatlab(traindata);
                
                confmatrix{k}(i,j)=Fmeasure;
                conffeaturematrix{k}{i,j}=features;
                
                savefile1=['run1on1_output', filesep, 'confmatrix_', int2str(i),'_', int2str(j), '_', int2str(k)];
                savefile2=['run1on1_output', filesep, 'conffeaturematrix_', int2str(i),'_', int2str(j), '_', int2str(k)];
                
                save(savefile1, 'confmatrix');
                save(savefile2, 'conffeaturematrix');
           end
       end
   end
end

end

