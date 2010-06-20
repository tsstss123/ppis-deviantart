function [ Fscore ] = calculateFmeasure( resultstruct )   
    beta=1;
    
    fn=resultstruct.('fn');
    fp=resultstruct.('fp');
    tp=resultstruct.('tp');
    
    beta2=beta^2;
    
    Nominator=(1+beta2)*tp;
    Denominator=((1+beta2)*tp + beta2*(fn + fp));
    
    Fscore=Nominator/Denominator;
end