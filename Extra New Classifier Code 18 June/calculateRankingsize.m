function [ Rankingsize ] = calculateRankingsize( resultstruct )

    Categories=resultstruct.('results');
    Categorynames=fieldnames(Categories);
    
    Rankingsize=0;
    
    % Calculate Rankingsize
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
                Rankingsize=Rankingsize+length(RClassifier);
            end
        end
    end
end

