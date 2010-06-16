
tic
for i = 1:100
   v = xml_load('testen2.xml');
   xml_save('testen2.xml',v);    
end
toc