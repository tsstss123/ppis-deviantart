function [ newdata, Fv ] = Featureselection( data, setlength )
%   Uses the feature selection algorithm of PRTools to select the best
%   features according to the inter-intra distance
%
%   Input:      data: PRTools dataset format
%
%   Output:     newdata: The filtered Data
%               Fv: Output result of the feature selection mapping

        [Fv,~]=featself(data,'in-in',setlength);
        data=data*Fv;
        newdata=data;
end

