function findCombination( artistname1, artistname2, artistnames, inputmatrix, inputfeaturematrix ,k)
%
%   This function is used to quickly analyze two individual artists using
%   the results from the run1on1.m
%
%
%   Input:  artistname1,    Name of artist 1
%           artistname2,    Name of artist 2
%           artistnames,    List of Artistnames
%           inputmatrix,    the run1on1.m output F-measure score matrix
%           inputfeaturematrix,     the run1on1.m output Feature matrix
%           k,  which run1on1.m matrix it should look into(e.g. the top 3 
%               features matrix)
%
    confmatrix=inputmatrix{k};
    conffeaturematrix=inputfeaturematrix{k};
    
    fprintf('\nListing Artist Pair Result:\n\n');
    
    [~,I1]=ismember(artistname1, artistnames);
    [~,I2]=ismember(artistname2, artistnames);
    
    f1=confmatrix(I1,I2);
    f2=confmatrix(I2,I1);
    
    feats1=conffeaturematrix{I1,I2};
    feats2=conffeaturematrix{I2,I1};
    
    fprintf('%s and %s, F-measure: %f\n', artistname1, artistname2, f1);
    [rows,~]=size(feats1);
    
    for k=1:rows
        fprintf('%s\n',  feats1(k,:));
    end
    
    fprintf('\n%s and %s, F-measure: %f\n', artistname2, artistname1, f2);    
    [rows,~]=size(feats2);
    
    for k=1:rows
        fprintf('%s\n',  feats2(k,:));
    end
    fprintf('\n');    
end