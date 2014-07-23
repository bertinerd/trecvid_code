
scoresP = readList('normalization.poly');
SP = numel(scoresP);

scoresPD = zeros(1,SP);
scoresPG = zeros(1,SP);

for s = 1:SP
    scoresPD(s) = str2double(scoresP{s}(2));
    scoresPG(s) = abs(str2double(scoresP{s}(3)));
end

sP_max = 1;
sP_min = 0;
rPD_max = max(scoresPD);
rPG_max = max(scoresPG);
rPD_min = min(scoresPD);
rPG_min = min(scoresPG);

scoresPD_s = (scoresPD - mean(scoresPD))/std(scoresPD);
scoresPG_s = (scoresPG - mean(scoresPG))/std(scoresPG);
rPD_max = max(scoresPD_s);
rPD_min = min(scoresPD_s);
rPG_max = max(scoresPG_s);
rPG_min = min(scoresPG_s);
scoresPD_s_n = sP_min + (scoresPD_s - rPD_min)/(rPD_max - rPD_min) * (sP_max - sP_min);
scoresPG_s_n = sP_min + (scoresPG_s - rPG_min)/(rPG_max - rPG_min) * (sP_max - sP_min);


