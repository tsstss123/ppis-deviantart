function [ filtereddata ] = filterFeatures2( data, featurecombo )

    allnames=getfeatlab(data);
    [~,indices]=ismember(featurecombo,allnames);
    filtereddata=data(:,indices);
end

