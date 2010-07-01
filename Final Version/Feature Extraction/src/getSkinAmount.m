function [s] = getSkinAmount(skinMap)
% Function used to compute the amount of skin in the skin map

% input values: [skiMap] = skin map got from the saliency toolbox and
% created during the process of creation of the saliency map

% Created by Davide Modolo

    s = sum(sum(skinMap.CM.data))/(numel(skinMap.CM.data));
end