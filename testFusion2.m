function testFusion2(id_test, tm, maxListSize, firstTopic, runType)
    %% normalization parameters
    % Poly
    sP_max = 1;
    sP_min = 0;
    rPD_max = 57.1226;
    rPG_max = 323.42;
    rPD_min = 0.1756;%2.3;
    rPG_min = 25.2651;%26.0416;
    % Full
    sF_max = 1;
    sF_min = 0;
    rFD_max = 144.2570;
    rFG_max = 769.5630;
    rFD_min = 0.7354; %2.3;
    rFG_min = 56.8250; %56.9151;
    % Both
    s_max = [sP_max sF_max];
    s_min = [sP_min sF_min];
    rD_max = [rPD_max rFD_max];
    rG_max = [rPG_max rFG_max];
    rD_min = [rPD_min rFD_min];
    rG_min = [rPG_min rFG_min];
    
    %%
    warning('off','all');
    runType = str2double(runType);
    maxListSize = str2double(maxListSize);
    firstTopic = str2double(firstTopic);
%     matlabpool
    for topic = firstTopic:(firstTopic+29)
%         fprintf('\nMERGING RESULTS FOR TOPIC %d\n', topic);
        idKeyframe = 0;
        mapK2ID = containers.Map('KeyType','char','ValueType','uint32');
        mapID2K = containers.Map('KeyType','uint32','ValueType','char'); 
        % worst case initialization
        scoresDistratGlobal = zeros(1,maxListSize*8);
        type = {'poly','full'};

        for t = 1:2
%             fprintf('\n\tMERGING RESULTS FOR TOPIC %d (%s)\n', topic, type{t});
            fRes = strcat('../results/',id_test,'/',id_test,'_',type{t},'/');
            for query = 1:runType
                resList = readList(strcat(fRes,'/res_perQuery/',int2str(topic),'.',int2str(query),'.src.res'));
                nNZ = countNZ(resList);
                for r=1:numel(resList)            
                    rKeyframe = resList{r}{1};
                    rScoreDistrat = str2double(resList{r}{2});
                    rScoreDistrat_n = s_min(t) + (rScoreDistrat - rD_min(t))/(rD_max(t) - rD_min(t)) * (s_max(t) - s_min(t)) ;
                    rScoreDistrat_n = max(0, rScoreDistrat_n);
                    if(strcmp(tm,'tm10'))
                        rScoreGlobal = -(str2double(resList{r}{3}));            
                    else
                        rScoreGlobal = str2double(resList{r}{3});
                    end
                    rScoreGlobal_n = s_min(t) + (rScoreGlobal - rG_min(t))/(rG_max(t) - rG_min(t)) * (s_max(t) - s_min(t));
                    % if the keyframe is new then add it to the data structures
                    if(~isKey(mapK2ID,rKeyframe))
                        % update index
                        idKeyframe = idKeyframe + 1;
                        % add both normalized score to the array                
                        scoresDistratGlobal(idKeyframe) = rScoreDistrat_n*(numel(resList)^(1/2)) + rScoreGlobal_n*(nNZ^(1/2));
                        % keep track of keyframe <-> index
                        mapK2ID(rKeyframe) = idKeyframe;
                        mapID2K(idKeyframe) = rKeyframe;                
                    else
                        scoresDistratGlobal(mapK2ID(rKeyframe)) = scoresDistratGlobal(mapK2ID(rKeyframe)) + rScoreDistrat_n*(numel(resList)^(1/2)) + rScoreGlobal_n*(nNZ^(1/2));
                    end     
                end
            end
        end

        out = strcat('../results/',id_test,'/',int2str(topic),'.fusion.res');    
        delete(out)
        fout = fopen(out,'a');
        % sort distrat scores and ids
        [scoresSorted,idSorted] = sort(scoresDistratGlobal,'descend');
        % remove keyframes with score zero
        toRemove = scoresSorted==0;
        scoresSorted(toRemove)= [];
        idSorted(toRemove) = [];        
  
        for s=1:numel(idSorted)            
           keyframe = mapID2K(idSorted(s));
           fprintf(fout,'%s %.4f\n', keyframe, scoresSorted(s));
        end
        fclose(fout);
    end
%     matlabpool close
exit
end
