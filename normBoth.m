scores = readList('normalization.both');
S = numel(scores);

scoresD = zeros(1,S);
scoresG = zeros(1,S);

for s = 1:S
    scoresD(s) = str2double(scores{s}(2));
    scoresG(s) = abs(str2double(scores{s}(3)));
end

s_max = 1;
s_min = 0;
rD_max = max(scoresD);
rG_max = max(scoresG);
rD_min = min(nonzeros(scoresD));
rG_min = min(scoresG);

scoresD_n = s_min + (scoresD - rD_min)/(rD_max - rD_min) * (s_max - s_min);
scoresD_n(scoresD_n<0) = 0;
scoresG_n = s_min + (scoresG - rG_min)/(rG_max - rG_min) * (s_max - s_min);

figure(5)
hist(nonzeros(scoresD_n),500)
figure(6)
hist(scoresG_n,500)