clc
clear all
fullCase = 0;
id_test = '11_06_full_mode5_resize640';
if ~isempty(strfind(id_test,'full')), fullCase = 1; end
listSize = 3000;
sizeFull = 432*768;
sizeBoxes = readList('../boundingBoxSize.txt');
fRes = strcat('../results/',id_test,'/');

for topic = 9069:9098
    fprintf('\nTOPIC %d\n', topic);
    idDistrat = 0;
    idGlobal = 0;    
    mapK2ID_distrat = containers.Map('KeyType','char','ValueType','uint32');
    mapID2K_distrat = containers.Map('KeyType','uint32','ValueType','char');
    mapK2ID_global = containers.Map('KeyType','char','ValueType','uint32');
    mapID2K_global = containers.Map('KeyType','uint32','ValueType','char');        
    scoresDistrat = zeros(1,listSize*4);
    scoresGlobal = zeros(1,listSize*4);    
    for query=1:4
        i = (topic-9069)*4+query;
        resBox = readList(strcat(fRes,'/res_perQuery/',int2str(topic),'.',int2str(query),'.src.res'));
        for r=1:numel(resBox)            
            rKeyframe = resBox{r}{1};
            if fullCase
                querySize = sizeFull;
            else
                querySize = str2double(sizeBoxes{i}{3});
            end
            
            rScoreDistrat = str2double(resBox{r}{2}) / sqrt(querySize);            
            rScoreGlobal = abs(str2double(resBox{r}{3}));
            
            % if the keyframe is new then add it to the data structures
            if(~isKey(mapK2ID_distrat,rKeyframe))
                % update index
                idDistrat = idDistrat + 1;
                % add the score to the array                
                scoresDistrat(idDistrat) = rScoreDistrat;
                % keep track of keyframe <-> index
                mapK2ID_distrat(rKeyframe) = idDistrat;
                mapID2K_distrat(idDistrat) = rKeyframe;                
            else
                scoresDistrat(mapK2ID_distrat(rKeyframe)) = scoresDistrat(mapK2ID_distrat(rKeyframe)) + rScoreDistrat;
            end
            
            if(~isKey(mapK2ID_global,rKeyframe))
                % update index
                idGlobal = idGlobal + 1;
                % add the score to the array                
                scoresGlobal(idGlobal) = rScoreGlobal;
                % keep track of keyframe <-> index
                mapK2ID_global(rKeyframe) = idGlobal;
                mapID2K_global(idGlobal) = rKeyframe;                
            else
                scoresGlobal(mapK2ID_global(rKeyframe)) = scoresGlobal(mapK2ID_global(rKeyframe)) + rScoreGlobal;
            end               
        end
    end
    out = strcat(fRes,'/res_perQuery/',int2str(topic),'.merged.res');    
    fout = fopen(out,'w');
    % sort distrat scores and ids
    [scoresDistratSorted,idDistratSorted] = sort(scoresDistrat,'descend');
    % remove keyframes with score zero
    toRemove = scoresDistratSorted==0;
    scoresDistratSorted(toRemove)= [];
    idDistratSorted(toRemove) = [];
    for s=1:numel(idDistratSorted) 
       distratKeyframe = mapID2K_distrat(idDistratSorted(s));
       fprintf(fout,'%s %.4f\n', distratKeyframe, scoresDistratSorted(s));
       % Remove keyframe from global scores
       id2remove = mapK2ID_global(distratKeyframe);
       scoresGlobal(id2remove) = 0;
    end
    fclose(fout);
    fout = fopen(out,'a');
    % Here comes the global scores part
    [scoresGlobalSorted,idGlobalSorted] = sort(scoresGlobal,'descend');
    toRemove = scoresGlobalSorted==0;
    scoresGlobalSorted(toRemove)= [];
    idGlobalSorted(toRemove) = [];
    for s=1:numel(idGlobalSorted) 
       globalKeyframe = mapID2K_global(idGlobalSorted(s));
       fprintf(fout,'%s %.4f\n', globalKeyframe, scoresGlobalSorted(s));
    end    
    fclose(fout);
end