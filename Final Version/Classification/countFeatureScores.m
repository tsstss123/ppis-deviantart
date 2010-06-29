function countFeatureScores( artistnames, inputmatrix, inputfeaturematrix, fscoremin, fscoremax, k)
%
% This function counts the number of occurences of a feature occuring in
% the matrix. This function as opposed to countFeatureArtist looks into all
% the artists to find its features.
%
%
%   Input:  artistnames,    list of the classes names
%           inputmatrix,    the run1on1.m output F-measure score matrix
%           inputfeaturematrix,     the run1on1.m output Feature matrix
%           fscoremin/max,  Search area to count the features
%           k,  which run1on1.m matrix it should look into(e.g. the top 3 
%               features matrix)
%           artistindex,    which artist it should use this function upon

    threshold=0.1;
    confmatrix=inputmatrix{k};
    conffeaturematrix=inputfeaturematrix{k};
    
    firstmatrix=inputfeaturematrix{1};
    ftlist=firstmatrix{1,2};
    
    [rows,~]=size(ftlist);
    countvector=zeros(rows,1);
    for i=1:length(artistnames)
        for j=1:length(artistnames)
            if(j>i)
                firstvalue=confmatrix(i,j);
                secondvalue=confmatrix(j,i);
                if((firstvalue > fscoremin && firstvalue < fscoremax) || (secondvalue>fscoremin && secondvalue < fscoremax))

                    upperthreshold=firstvalue+threshold;
                    lowerthreshold=firstvalue-threshold;

                    if(secondvalue > lowerthreshold && secondvalue < upperthreshold)
                        
                        innerft=conffeaturematrix{i,j};
                        
                        [noft,~]=size(innerft);
                        for q=1:noft
                           [~,I]=ismember(innerft(q,:), {ftlist});
                           countvector(I)=countvector(I)+1;
                        end
                                              
                    end
                end
            end
        end
    end
    fprintf('\n');
    
    [~,I]=sort(countvector,'descend');
    countvector=countvector(I);
    ftlist=ftlist(I,:);
    fprintf('Listing Count Scores of each Feature\n\n');
    for i=1:length(ftlist)
        fprintf('%s: %d\n', ftlist(i,:), countvector(i));
    end
end