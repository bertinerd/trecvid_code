function testFusion3(id_test, tm, maxListSize, firstTopic, runType)
    %% normalization parameters
    % all values
%     meanD = [0.0591 0.0981];
%     stdD = [0.6134 1.5905];
    % only non-zero values
    meanD = [3.3845 7.4097];
    stdD = [3.2064 11.7021];    
    meanG = [51.6449 73.7990];
    stdG = [14.6507 9.3833]; 
    
    %%
    warning('off','all');
    runType = str2double(runType);
    maxListSize = str2double(maxListSize);
    firstTopic = str2double(firstTopic);
    matlabpool
    parfor topic = firstTopic:(firstTopic+29)
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
                    rScoreDistrat_n = max(0, (rScoreDistrat - meanD(t))/stdD(t));

                    if(strcmp(tm,'tm10'))
                        rScoreGlobal = abs(str2double(resList{r}{3}));            
                    else
                        rScoreGlobal = str2double(resList{r}{3});
                    end
                    rScoreGlobal_n = (rScoreGlobal - meanG(t))/stdG(t);
                    % if the keyframe is new then add it to the data structures
                    if(~isKey(mapK2ID,rKeyframe))
                        % update index
                        idKeyframe = idKeyframe + 1;
                        % add both normalized score to the array                
                        scoresDistratGlobal(idKeyframe) = rScoreDistrat_n*(numel(resList)^(1)) + rScoreGlobal_n*(nNZ^(1));
%                         scoresDistratGlobal(idKeyframe) = rScoreDistrat_n + rScoreGlobal_n;
                        
                        % keep track of keyframe <-> index
                        mapK2ID(rKeyframe) = idKeyframe;
                        mapID2K(idKeyframe) = rKeyframe;                
                    else
                        scoresDistratGlobal(mapK2ID(rKeyframe)) = scoresDistratGlobal(mapK2ID(rKeyframe)) + rScoreDistrat_n*(numel(resList)^(1)) + rScoreGlobal_n*(nNZ^(1));
%                         scoresDistratGlobal(mapK2ID(rKeyframe)) = scoresDistratGlobal(mapK2ID(rKeyframe)) + rScoreDistrat_n + rScoreGlobal_n;
                        
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
    matlabpool close
    
exit
end
