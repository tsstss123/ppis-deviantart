function [tag,ind]=gettag(xml,ind)
if ind>length(xml) 
    tag=[]; 
elseif xml(ind)=='<' 
    i=findchar(xml,ind,'>'); 
    if isempty(i) 
        error('incomplete tag'); 
    end 
    tag=xml(ind+1:i-1); 
    ind=i+1; 
else 
    error('expected tag'); 
end

end