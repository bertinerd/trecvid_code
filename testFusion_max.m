function testFusion_max(id_test,tm)

    listSize = 3000;
%     sizeFull = 432*768;
%     sizeBoxes = readList('../boundingBoxSize.txt');

    for topic = 9069:9098

        fprintf('\nMERGING RESULTS FOR TOPIC %d\n', topic);
        idDistrat = 0;
        idGlobal = 0;    
        mapK2ID_distrat = containers.Map('KeyType','char','ValueType','uint32');
        mapID2K_distrat = containers.Map('KeyType','uint32','ValueType','char');
        mapK2ID_global = containers.Map('KeyType','char','ValueType','uint32');
        mapID2K_global = containers.Map('KeyType','uint32','ValueType','char');        
        scoresDistrat = zeros(1,listSize*4);
        scoresGlobal = zeros(1,listSize*4);    
        type = {'poly','full'};

        for t = 1:2
            fprintf('\n\tMERGING RESULTS FOR TOPIC %d (%s)\n', topic, type{t});
            fRes = strcat('../results/',id_test,'/',id_test,'_',type{t},'/');
            for query = 1:4
                resList = readList(strcat(fRes,'/res_perQuery/',int2str(topic),'.',int2str(query),'.src.res'));
                for r=1:numel(resList)            
                    rKeyframe = resList{r}{1};
                    rScoreDistrat = str2double(resList{r}{2});
                    if(strcmp(tm,'tm10'))
                        rScoreGlobal = abs(str2double(resList{r}{3}));            
                    else
                        rScoreGlobal = str2double(resList{r}{3});
                    end
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
                        scoresDistrat(mapK2ID_distrat(rKeyframe)) = max(scoresDistrat(mapK2ID_distrat(rKeyframe)) , rScoreDistrat);
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
                        scoresGlobal(mapK2ID_global(rKeyframe)) = max(scoresGlobal(mapK2ID_global(rKeyframe)) , rScoreGlobal);
                    end               
                end
            end
        end

        out = strcat('../results/',id_test,'/',int2str(topic),'.fusion.res');    
        delete(out)
        fout = fopen(out,'a');
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
end