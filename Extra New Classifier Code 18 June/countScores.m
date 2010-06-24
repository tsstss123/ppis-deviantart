function countScores( artistnames, inputmatrix, fscoremin, fscoremax, k)

    threshold=0.1;
    confmatrix=inputmatrix{k};
    
    countvector=zeros(length(artistnames),1);
    
    for i=1:length(artistnames)
        for j=1:length(artistnames)
            if(j>i)
                firstvalue=confmatrix(i,j);
                secondvalue=confmatrix(j,i);
                if((firstvalue > fscoremin & firstvalue < fscoremax) | (secondvalue>fscoremin & secondvalue < fscoremax))
                    secondvalue=confmatrix(j,i);

                    upperthreshold=firstvalue+threshold;
                    lowerthreshold=firstvalue-threshold;

                    if(secondvalue > lowerthreshold & secondvalue < upperthreshold)
                        countvector(i)=countvector(i)+1;
                        countvector(j)=countvector(j)+1;
                    end
                end
            end
        end
    end
    fprintf('\n');
    
    [~,I]=sort(countvector,'descend');
    countvector=countvector(I);
    artistnames=artistnames(I);
    fprintf('Listing Count Scores of each Artist\n\n');
    for i=1:length(artistnames)
        fprintf('%s: %d\n', artistnames{i}, countvector(i));
    end
end

