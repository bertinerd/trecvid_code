function combineAsWholeGlobal(id)
    %%
    id_poly = strcat(id, '_poly');
    id_full = strcat(id, '_full');
    sizeFull = 432*768;
    pTrim = 0;
    sizeBoxes = readList('../boundingBoxSize.txt');
    fFull = strcat('../results/',id,'/',id_full);
    fBox = strcat('../results/',id,'/',id_poly);
    %%
    % First dimension accounts for the topic, second for the query (1-4) and
    % third for "full" vs "box"
    mAP = zeros(30,4,2);
    globalConfidence = zeros(30,4,2);
    finalMAP = zeros(1,30);
    finalMAPbox = zeros(1,30);
    finalMAPfull = zeros(1,30);
        
    for q = 1 : 4
        %% assign map
        % full
        cellArrayFull=readList(strcat(fFull,'/results_treceval/TREC_EVAL.',int2str(q),'.parsed'));
        mAP(:,q,1) = extractResults(cellArrayFull);
        % box
        cellArrayBox=readList(strcat(fBox,'/results_treceval/TREC_EVAL.',int2str(q),'.parsed'));
        mAP(:,q,2) = extractResults(cellArrayBox);        
        %% assign distrat confidence score
        % full
        for t=1:30
            resFull = readList(strcat(fFull,'/res_perQuery/',int2str(t+9068),'.',int2str(q),'.src.res'));
            sumGlobalFull = zeros(1,numel(resFull));            
            for r=1:numel(resFull);
                if str2double(resFull{r}{3})==0, break; end
                sumGlobalFull(r) = abs(str2double(resFull{r}{3}));
            end
            sumGlobalFull(r:end)=[];
            globalConfidence(t,q,1) = sum(sumGlobalFull(pTrim+1:end-pTrim));%/sqrt(sizeFull);
        end
        % box
        for t=1:30
            index = (q-1)*30+t;
            resBox = readList(strcat(fBox,'/res_perQuery/',int2str(t+9068),'.',int2str(q),'.src.res'));
            sumGlobalBox = zeros(1,numel(resBox));            
            for r=1:numel(resBox);
                if str2double(resBox{r}{3})==0, break; end
                sumGlobalBox(r) = abs(str2double(resBox{r}{3}));
            end
            sumGlobalBox(r:end)=[];
            globalConfidence(t,q,2) = sum(sumGlobalBox(pTrim+1:end-pTrim));%/sqrt(str2double(sizeBoxes{index}{3}));
        end        
    end
    
    %% Now use the appropriate mAP
    boxVSfull = 0;
    maxID = 0;
    for q=1:30
        [maxFull, maxIDfull] = max(globalConfidence(q,:,1));
        [maxBox, maxIDbox] = max(globalConfidence(q,:,2));
        if maxFull > maxBox
            boxVSfull = 1;
            maxID = maxIDfull;
        else
            boxVSfull = 2;
            maxID = maxIDbox;
        end
        
        finalMAPfull(q) = mAP(q,maxIDfull,1);
        finalMAPbox(q) = mAP(q,maxIDbox,2);        
        finalMAP(q) = mAP(q,maxID,boxVSfull);        
    end    
end