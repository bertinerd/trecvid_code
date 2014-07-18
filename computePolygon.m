function polygon = computePolygon(pStart, maskC_dilated)
   
    w = size(maskC_dilated,2);
    h = size(maskC_dilated,1);
    % keep track of the visited pixels
    maskVisited = false(size(maskC_dilated));
    maskVertex = false(size(maskC_dilated));
    nVertex = 1;
    nPoints = sum(sum(maskC_dilated));
    % array of the points of the polygon.
    polygon = repmat(struct('x',0,'y',0), nPoints, 1 );        
    polygon(nVertex) = pStart;
    pCurrent = pStart;
    pathClosed = false;
    % loop ends when the path is closed
    while ~pathClosed
        
        neighbours = getNeighbours(pCurrent,w,h);        
        for n=1:8
           if ~isnan(neighbours(n).x) 
               if maskC_dilated(neighbours(n).y,neighbours(n).x) && ~maskVisited(neighbours(n).y,neighbours(n).x)
                    if pCurrent.x ~= neighbours(n).x && pCurrent.y ~= neighbours(n).y
                        nVertex = nVertex+1;
                        polygon(nVertex) = neighbours(n);
                        maskVertex(neighbours(n).y,neighbours(n).x) = true;
                        fprintf('\n:: Added vertex #%d at (%d,%d) ::\n', nVertex, neighbours(n).x, neighbours(n).y);
                    end
                    maskVisited(neighbours(n).y,neighbours(n).x) = true;
                    pCurrent = neighbours(n);

                    break;
               end
           end
        end
                     
        if pCurrent.x==pStart.x && pCurrent.y==pStart.y
           pathClosed = true; 
        end
    end
    
    polygon(nVertex+1:end) = []; 
    
    subplot(3,1,3)
    imshow(maskVisited)    
   
end
