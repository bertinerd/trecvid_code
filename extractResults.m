function [ array ] = extractResults( cellArray )

nQueries = 30;
array = zeros(1,nQueries);

for i = 1:nQueries
    array(i) = str2double(cellArray{i}(end));
end


end

