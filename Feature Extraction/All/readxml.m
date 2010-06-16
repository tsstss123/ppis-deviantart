function ret_image = readxml(path) 

    f = fopen(path,'r'); 
    xml = fread(f,'*char')'; 
    fclose(f); 


ret_image = xml2struct(xml); 

end



 
 