function writexml(fid,img,depth)
 
fn=fieldnames(img); 
for i=1:length(fn) 
    f=rec.(fn{i}); 
    if ~isempty(f) 
            if isstruct(f)  ....  (we will probably use a general structure with a lot of cells. right?)
            else iscell(f) ...
            end
    end
end



end