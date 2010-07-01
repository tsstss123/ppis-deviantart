function [s] = getSkinAmount(skinMap)
    s = sum(sum(skinMap.CM.data))/(numel(skinMap.CM.data));
end