function GOld = myFindCore(str, startDegree, Graph)

if(strcmpi(str,'in'))
    degreeCol = 2;
elseif(strcmpi(str,'out'))
    degreeCol = 3;
elseif(strcmpi(str, 'all'))
    degreeCol = 4;
else
    error('wrong input')
end

GNew = Graph;
i = startDegree;


Degree = myDegree(GNew);

while ~isempty(Degree) 
    disp(['removing nodes below degree:', num2str(i)])
    
    indexRemoveNodes = Degree(:,degreeCol)<i;
    idsRemoveNodes = Degree(indexRemoveNodes,1);
    GOld = GNew;
    while ~isempty(idsRemoveNodes);   
        disp(['removing: ', num2str(length(idsRemoveNodes)), ' nodes'])
        
        indexLinksFrom = ismember(GNew.Data(:,1), idsRemoveNodes);
        indexLinksTo = ismember(GNew.Data(:,2), idsRemoveNodes);
        indexRemoveLinks = indexLinksFrom | indexLinksTo;
        
        GNew.Data = GNew.Data(~indexRemoveLinks, :);
        GNew.Index.Values = GNew.Index.Values(~indexRemoveNodes);
        GNew.Index.Names = GNew.Index.Names(~indexRemoveNodes);
        
        Degree = myDegree(GNew);
        if ~isempty(Degree) %avoid index out of bounds
            indexRemoveNodes = Degree(:,degreeCol)<i;
            idsRemoveNodes = Degree(indexRemoveNodes,1);
        else
            idsRemoveNodes = [];
        end

     end
    i = i+1;
end
disp(['removing nodes below degree ', num2str(i-1), ' failed'])
disp(['thus core is found when removing nodes below degree ', num2str(i-2)])

function Degree = myDegree(G)
    Degree = GraphCountNodesDegree(G);
    if ~isempty(Degree)
        Degree(:,4)=Degree(:,2)+Degree(:,3);
    else
        Degree = zeros(0,4);
    end