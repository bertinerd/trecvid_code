
scoresF = readList('./normalization.full');
SF = numel(scoresF);

scoresFD = zeros(1,SF);
scoresFG = zeros(1,SF);

for s = 1:SF
    scoresFD(s) = str2double(scoresF{s}(2));
    scoresFG(s) = abs(str2double(scoresF{s}(3)));
end

sF_max = 1;
sF_min = 0;
rFD_max = max(scoresFD)
rFG_max = max(scoresFG)
rFD_min = min(scoresFD)
rFG_min = min(scoresFG)

scoresP = readList('./normalization.poly');
SP = numel(scoresP);

scoresPD = zeros(1,SP);
scoresPG = zeros(1,SP);

for s = 1:SP
    scoresPD(s) = str2double(scoresP{s}(2));
    scoresPG(s) = abs(str2double(scoresP{s}(3)));
end

sP_max = 1;
sP_min = 0;
rPD_max = max(scoresPD)
rPG_max = max(scoresPG)
rPD_min = min(scoresPD)
rPG_min = min(scoresPG)

% 
% scoresFD_n = sF_min + (scoresFD - rFD_min)/(rFD_max - rFD_min) * (sF_max - sF_min);
% scoresFG_n = sF_min + (scoresFG - rFG_min)/(rFG_max - rFG_min) * (sF_max - sF_min);
% 
% figure(3)
% hist(nonzeros(scoresFD_n),500)
% figure(4)
% hist(scoresFG_n,500)