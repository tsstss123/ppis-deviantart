function stringVersion = arrayToString(array)
    stringVersion = num2str(array(1));
    for i = 2:size(array,2)
        stringVersion = [stringVersion,',',num2str(array(i))];
    end
end