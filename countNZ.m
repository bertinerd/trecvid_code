function nNZ = countNZ(resList)
    
    nNZ = 0;
    
    for i=1:numel(resList)
       if(str2double(resList{i}(2))>0) 
           nNZ = nNZ + 1;
       end
    end

end