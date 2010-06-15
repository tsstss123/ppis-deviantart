%     %Cut up in Folds(Cross Validation)
%     shuffledtrainset=trainset(randperm(length(trainset)),:);
%     imagesperfold=length(trainset)/numberoffolds;
%     crosscell=cell(1,numberoffolds);
%     for j=1:numberoffolds
%         beginindex=(imagesperfold*j)-(imagesperfold-1);
%         endindex=(imagesperfold*j);
%         if endindex > length(trainset);
%             cross=shuffledtrainset(beginindex:end,:)            
%         else
%             cross=shuffledtrainset(beginindex:endindex,:);         
%         end
%         crosscell{j}=cross;
%     end
%     
%     for j=1:numberoffolds
%         logvector=zeros(1,numberoffolds);
%         logvector(j)=1;
%         currentvalidationset=crosscell(logvector==1);
%         trainsetparts=crosscell(logvector==0);
%         if numberoffolds==5
%             currenttrainset = [trainsetparts{1};
%                                trainsetparts{2};
%                                trainsetparts{3};
%                                trainsetparts{4}]
%         else
%             disp('Bad programming might cause error check if-statement at line +-50-57');
%         end
% 
%         %Classifier 1
%         %C1_ldc1=ldc(trainset,0,NaN,[])
%         %A = getopt_pars;
%         %A;
%         %C2_ldc2=ldc(trainset,0,0,NaN);
%         %getopt_pars
%         %Classifier 2
%         
%     end
%     currenttrainset
    %svc(currenttrainset,'p',1,1);