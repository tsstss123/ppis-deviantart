function [ distance ] = euclidianDistance( v1, v2 )
    t=v1-v2;
    t_2=t.*t;
    distance = sqrt(sum(t_2));
end