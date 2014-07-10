clear
clc
[~,out] = unix('wc -l ../DB-management/keyframes.all | cut -d'' '' -f1');
nKeyframes = str2double(out);
keyframe2shot = containers.Map('KeyType','char','ValueType','char');
K2S = readList('../DB-management/keyframe2shot.all');
for k=1:nKeyframes
    kID = strtok(K2S{k}{1},'.');
    sID = K2S{k}{2};
    keyframe2shot(kID) = sID;
end

save('../keyframe2shot.mat','keyframe2shot');
