function s = trim(s)
for i=1:numel(s) 
    if ~isspace(s(i)) 
        s=s(i:end); 
        break 
    end 
end 
for i=numel(s):-1:1 
    if ~isspace(s(i)) 
        s=s(1:i); 
        break 
    end 
end
end