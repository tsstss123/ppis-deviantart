function [ R ] = CrossvalRotation( data, crossfolds )
%   This function is used to create the Rotation matrix that can be used 
%   to do cross validation to optimize parameters
%
%   Input:      data: PRTools Format Dataset
%               crossfolds: Number of crossfolds wanted
%
%   Output:     R: Rotation Matrix
%
    R=crossval(data,[],crossfolds,0);
end