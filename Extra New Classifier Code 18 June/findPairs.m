function findPairs( artistnames, inputmatrix, inputfeaturematrix, fscoremin, fscoremax,k)

    threshold=0.1;
    confmatrix=inputmatrix{k};
    conffeaturematrix=inputfeaturematrix{k};
    
    fprintf('\nListing Artist with stable F-measure above %f and below %f\n\n', fscoremin, fscoremax);
    
    for i=1:length(artistnames)
        for j=1:length(artistnames)
            if(j>i)
                firstvalue=confmatrix(i,j);
                secondvalue=confmatrix(j,i); 
                if((firstvalue > fscoremin & firstvalue < fscoremax) | (secondvalue>fscoremin & secondvalue < fscoremax))

                    upperthreshold=firstvalue+threshold;
                    lowerthreshold=firstvalue-threshold;

                    if(secondvalue > lowerthreshold & secondvalue < upperthreshold)
                        fprintf('Artist Pair: %s and %s\nFmeasure Pair: %f and %f\n', artistnames{i}, artistnames{j}, firstvalue, secondvalue);
                        features=conffeaturematrix{i,j};
                        [rows,~]=size(features);
                        if(k~=1)
                            for p=1:rows
                                fprintf('%s\n',  features(p,:));
                            end
                                fprintf('\n');
                        else
                            fprintf('All Features\n\n');
                        end
                    end
                end
            end
        end
    end
    fprintf('\n');    
end