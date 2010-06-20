function [ filtereddata ] = filterArtists( data, varargin )

    names=varargin{1};

    classnames=getlablist(data);
    
    % First filter out NaN if they exist
    NaNindex=find(strcmp(classnames,'NaN'),1);
    if(numel(NaNindex))
        data=data(getnlab(data)~=NaNindex,:);
    end
    
    % Filter out every name except for the ones you want 
    for i=1:length(classnames)
        if(sum(strcmp(names, classnames{i}))==0)
            data=data(getnlab(data)~=i,:);
        end
    end
    
    % Finalize operation
    filtereddata=remclass(data);
end

