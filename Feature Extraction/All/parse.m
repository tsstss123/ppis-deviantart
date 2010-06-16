function [res,ind]=parse(xml,ind, parent) 
 
res=[]; 
if ~xml(ind)~='<' 
    i=findchar(xml,ind,'<'); 
    res=trim(xml(ind:i-1)); 
    ind=i; 
    [tag,ind]=gettag(xml,i) 
    parent
    if ~strcmp(tag,['/' parent]) 
        error('<%s> closed with <%s>',parent,tag); 
    end 
else 
    while ind<=length(xml) 
        [tag,ind]=gettag(xml,ind); 
        if strcmp(tag,['/' parent]) 
            return 
        else 
            [sub,ind]=parse(xml,ind,tag);             
            if isstruct(sub) 
                if isfield(res,tag) 
                    n=length(res.(tag)); 
                    fn=fieldnames(sub); 
                    for f=1:length(fn) 
                        res.(tag)(n+1).(fn{f})=sub.(fn{f}); 
                    end 
                else 
                    res.(tag)=sub; 
                end 
            else 
                if isfield(res,tag) 
                    if ~iscell(res.(tag)) 
                        res.(tag)={res.(tag)}; 
                    end 
                    res.(tag){end+1}=sub; 
                else 
                    res.(tag)=sub; 
                end 
            end 
        end 
    end 
end