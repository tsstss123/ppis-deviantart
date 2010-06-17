function [Ec, Ei, Eo, Ek] = getMapsEntropy(salData)    
    Ec = entropy(salData(1,1).CM.data);
    Ei = entropy(salData(1,2).CM.data);
    Eo = entropy(salData(1,3).CM.data);
    Ek = entropy(salData(1,4).CM.data);
end