function neighbours = getNeighbours(pCurrent,w,h)
        % find next move, scanning the neighbours clockwise, from top left
        neighbours = repmat(struct('x',0,'y',0), 8, 1 );
        if pCurrent.x-1>=1 && pCurrent.y-1>=1
            neighbours(1).x = pCurrent.x-1;
            neighbours(1).y = pCurrent.y-1;
        else
            neighbours(1).x = NaN;
            neighbours(1).y = NaN;
        end
        
        if pCurrent.y-1>=1   
            neighbours(2).x = pCurrent.x;
            neighbours(2).y = pCurrent.y-1;
        else
            neighbours(2).x = NaN;
            neighbours(2).y = NaN;
        end
        
        if pCurrent.x+1<=w && pCurrent.y-1>=1
            neighbours(3).x = pCurrent.x+1;
            neighbours(3).y = pCurrent.y-1;
        else
            neighbours(3).x = NaN;
            neighbours(3).y = NaN;
        end
            
        if pCurrent.x+1<=w 
            neighbours(4).x = pCurrent.x+1;
            neighbours(4).y = pCurrent.y;
        else
            neighbours(4).x = NaN;
            neighbours(4).y = NaN;
        end
        
        if pCurrent.x+1<=w && pCurrent.y+1<h
            neighbours(5).x = pCurrent.x+1;
            neighbours(5).y = pCurrent.y+1;
        else
            neighbours(5).x = NaN;
            neighbours(5).y = NaN;
        end        
        
        if pCurrent.y+1<=h 
            neighbours(6).x = pCurrent.x;
            neighbours(6).y = pCurrent.y+1;
        else
            neighbours(6).x = NaN;
            neighbours(6).y = NaN;
        end        
        
        if pCurrent.x-1>=1 && pCurrent.y+1<=h
            neighbours(7).x = pCurrent.x-1;
            neighbours(7).y = pCurrent.y+1;
        else
            neighbours(7).x = NaN;
            neighbours(7).y = NaN;
        end

        if pCurrent.x-1>=1 
            neighbours(8).x = pCurrent.x-1;
            neighbours(8).y = pCurrent.y;
        else
            neighbours(8).x = NaN;
            neighbours(8).y = NaN;
        end 
end