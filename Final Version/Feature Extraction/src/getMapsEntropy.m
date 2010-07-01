function [Ec, Ei, Eo, Ek] = getMapsEntropy(salData)  
% Function used to compute the entropy of the four conspicuity maps use in
% this project (color, intensity, orientation and skip)

% input value: [salData] =  structure used to store the four maps and their
%                           information (such as. dimension, etc. etc.)

% Created by Davide Modolo 

    Ec = entropy(salData(1,1).CM.data);
    Ei = entropy(salData(1,2).CM.data);
    Eo = entropy(salData(1,3).CM.data);
    Ek = entropy(salData(1,4).CM.data);
end