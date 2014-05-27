function readScores(fileScores)

a=readList(fileScores);
A = zeros(1,numel(a));
for i=1:numel(a)
   A(i) = str2double(a{i});
end
clear a

fprintf('\n:: %d retrieved results obtained a DISTRAT score higher than zero, mean is %.2f, median is %.2f ::\n', numel(A), mean(A), median(A));
exit
end

