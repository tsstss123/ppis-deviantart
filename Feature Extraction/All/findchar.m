function i = findchar(str,ind,chr)
i=[]; 
while ind<=length(str) 
    if str(ind)==chr 
        i=ind; 
        break 
    else 
        ind=ind+1; 
    end 
end