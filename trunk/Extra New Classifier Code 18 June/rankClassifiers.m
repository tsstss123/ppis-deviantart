function [ Fmeasurevector,rankingstruct ] = rankClassifiers( resultstruct )

    Categories=resultstruct.('results');
    Categorynames=fieldnames(Categories);
    
    rankingsize=calculateRankingsize(resultstruct);
    
    Fmeasurevector=zeros(rankingsize,1);
    Fmeasureindex=1;  
    
    ClassifierComboInfo=[];
    
    for i=1:length(Categorynames)
        ExperimentNames=fieldnames(Categories.(Categorynames{i}));
        for j=1:length(ExperimentNames)
            Classifiers=fieldnames(Categories.(Categorynames{i}) ...
                                             .(ExperimentNames{j}) ...
                                             .('Classifiers'));
            for k=1:length(Classifiers)
                RClassifier=fieldnames(Categories.(Categorynames{i}) ...
                                             .(ExperimentNames{j}) ...
                                             .('Classifiers') ...
                                             .(Classifiers{k}));
                for l=1:length(RClassifier)
                    Results=Categories.(Categorynames{i}) ...
                                      .(ExperimentNames{j}) ...
                                      .('Classifiers') ...
                                      .(Classifiers{k}) ...
                                      .(RClassifier{l});
                                  
                    Fmeasure=calculateFmeasure(Results);
                    Fmeasurevector(Fmeasureindex)=Fmeasure;
                    
                    cname=['Ex_' int2str(Fmeasureindex)];
                    
                    ClassifierComboInfo.(cname) ...
                                       .('Name')=Categorynames{i};                    
                    
                    ClassifierComboInfo.(cname) ...
                                       .('Classifier')=Classifiers{k};
                                   
                    ClassifierComboInfo.(cname) ...
                                       .('Fmeasure')=Fmeasure;                                   
                    
                    if (strcmp(Classifiers{k},'NearestMean_Classifier')==0)            
                        pn=fieldnames(Results);
                        ClassifierComboInfo.(cname) ...
                                           .(pn{1})=Results.(pn{1});
                    end
                                   
                    ClassifierComboInfo.(cname) ...
                                       .('Features')=Categories ...
                                             .(Categorynames{i}) ...
                                             .(ExperimentNames{j}) ...
                                             .('Features');
                                             
                    Fmeasureindex=Fmeasureindex+1;                                             
                end
            end
        end
    end
    rankingstruct=ClassifierComboInfo;
    
    [Fmeasurevector,I]=sort(Fmeasurevector,'descend');
    C=struct2cell(rankingstruct);
    rankingstruct=C(I);
end