function [coordinates] = getMostSalientPoints(salmap, salData, params, n)
   
    wta = initializeWTA(salmap,params);
    
   for i=1:n
       winner = [-1,-1];
       
       % evolve WTA until we have a winner
       while (winner(1) == -1)
            [wta,winner] = evolveWTA(wta);
       end
       
       shapeData = estimateShape(salmap,salData,winner,params);
       
       % trigger inhibition of return
       wta = applyIOR(wta,winner,params,shapeData);
       
       % convert the winner's location to image coordinates
       coordinates(i,:) = winnerToImgCoords(winner,params);
       
       % normalize to image dimension
       coordinates(i,:) = coordinates(i,:)./salmap.origImage.size([1:2]);
   end
    
    
end