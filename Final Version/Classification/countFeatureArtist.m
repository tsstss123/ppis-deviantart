function countFeatureArtist( artistnames, inputmatrix, inputfeaturematrix, fscoremin, fscoremax, k, artistindex)
%
% This function counts the occurences of a feature for an artist given 
% a search area with a minimum F-measure score and maximum F-measure score
% By setting the value for this search area high (e.g. > 0.9) one can 
% find features that are reliably separating an artist.
%
%   Input:  artistnames,    list of the classes names
%           inputmatrix,    the run1on1.m output F-measure score matrix
%           inputfeaturematrix,     the run1on1.m output Feature matrix
%           fscoremin/max,  Search area to count the features
%           k,  which run1on1.m matrix it should look into(e.g. the top 3 
%               features matrix)
%           artistindex,    which artist it should use this function upon
%
    threshold=0.1;
    confmatrix=inputmatrix{k};
    conffeaturematrix=inputfeaturematrix{k};
    
    firstmatrix=inputfeaturematrix{1};
    ftlist=firstmatrix{1,2};
    
    [rows,~]=size(ftlist);
    countvector=zeros(rows,1);
        for j=1:length(artistnames)
                firstvalue=confmatrix(artistindex,j);
                secondvalue=confmatrix(j,artistindex);
                if((firstvalue > fscoremin && firstvalue < fscoremax) || (secondvalue>fscoremin && secondvalue < fscoremax))

                    upperthreshold=firstvalue+threshold;
                    lowerthreshold=firstvalue-threshold;

                    if(secondvalue > lowerthreshold && secondvalue < upperthreshold)
                        
                        innerft=conffeaturematrix{artistindex,j};
                        
                        [noft,~]=size(innerft);
                        for q=1:noft
                           [~,I]=ismember(innerft(q,:), {ftlist});
                           countvector(I)=countvector(I)+1;
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