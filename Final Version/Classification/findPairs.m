function findPairs( artistnames, inputmatrix, inputfeaturematrix, fscoremin, fscoremax,k)
%
% This function is used to find artist pairs that are interesting for the
% visualisation.
%
%   Input:  artistnames,    list of the classes names
%           inputmatrix,    the run1on1.m output F-measure score matrix
%           inputfeaturematrix,     the run1on1.m output Feature matrix
%           fscoremin/max,  Search area to count the features
%           k,  which run1on1.m matrix it should look into(e.g. the top 3 
%               features matrix)
%
%   An example:
%
%   findPairs(artistnames,fmatrix,ffmatrix,0.9,1.0,3)
%
%   This command looks for artist pairs that gives an F-measure score of
%   0.9-1.0 using 2 features.
%   The output is a printed text saying which artists and what features.
%   This can then be chosen with the visualization
%

    threshold=0.1;
    confmatrix=inputmatrix{k};
    conffeaturematrix=inputfeaturematrix{k};
    
    fprintf('\nListing Artist with stable F-measure above %f and below %f\n\n', fscoremin, fscoremax);
    
    for i=1:length(artistnames)
        for j=1:length(artistnames)
            if(j>i)
                firstvalue=confmatrix(i,j);
                secondvalue=confmatrix(j,i); 
                if((firstvalue > fscoremin && firstvalue < fscoremax) || (secondvalue>fscoremin && secondvalue < fscoremax))

                    upperthreshold=firstvalue+threshold;
                    lowerthreshold=firstvalue-threshold;

                    if(secondvalue > lowerthreshold && secondvalue < upperthreshold)
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