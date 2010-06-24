function countFeatureScores( artistnames, inputmatrix, inputfeaturematrix, fscoremin, fscoremax, k)

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
                if((firstvalue > fscoremin & firstvalue < fscoremax) | (secondvalue>fscoremin & secondvalue < fscoremax))

                    upperthreshold=firstvalue+threshold;
                    lowerthreshold=firstvalue-threshold;

                    if(secondvalue > lowerthreshold & secondvalue < upperthreshold)
                        %countvector(i)=countvector(i)+1;
                        %countvector(j)=countvector(j)+1;
                        
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