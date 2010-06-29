function [ normalizeddata ] = MinMaxNormalization( fulldata )
% This function normalizes the data to a -0.5 to 0.5 scale using Min/Max
% Normalization
%
%   Input: A dataset m*n
%   Output: normalized data
%

        % Min Max Normalize the Data
        maxvector=max(fulldata);
        minvector=min(fulldata);
        [~, featuresdata]=size(fulldata);
        for j=1:featuresdata
            fulldata(:,j)=fulldata(:,j)-minvector(j);
            fulldata(:,j)=(fulldata(:,j)/maxvector(j))-0.5;
        end
        normalizeddata=fulldata;

end

