function combineAsWholeDistrat(id, pTrim)
    %%
    id_poly = strcat(id, '_poly');
    id_full = strcat(id, '_full');
    sizeFull = 432*768;
    sizeBoxes = readList('../boundingBoxSize.txt');
    fFull = strcat('../results/',id,'/',id_full);
    fBox = strcat('../results/',id,'/',id_poly);
    %%
    % First dimension accounts for the topic, second for the query (1-4) and
    % third for "full" vs "box"
    mAP = zeros(30,4,2);
    distratConfidence = zeros(30,4,2);
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
            sumDistratFull = zeros(1,numel(resFull));            
            for r=1:numel(resFull);
                if str2double(resFull{r}{2})==0, break; end
                sumDistratFull(r) = str2double(resFull{r}{2});
            end
            sumDistratFull(r:end)=[];
            toTrim = round(numel(sumDistratFull)*pTrim);
            distratConfidence(t,q,1) = sum(sumDistratFull(toTrim+1:end-toTrim))/sqrt(sizeFull);
        end
        % box
        for t=1:30
            index = (q-1)*30+t;
            resBox = readList(strcat(fBox,'/res_perQuery/',int2str(t+9068),'.',int2str(q),'.src.res'));
            sumDistratBox = zeros(1,numel(resBox));            
            for r=1:numel(resBox);
                if str2double(resBox{r}{2})==0, break; end
                sumDistratBox(r) = str2double(resBox{r}{2});
            end
            sumDistratBox(r:end)=[];
            toTrim = round(numel(sumDistratBox)*pTrim);
            distratConfidence(t,q,2) = sum(sumDistratBox(toTrim+1:end-toTrim))/sqrt(str2double(sizeBoxes{index}{3}));
        end        
    end
    
    %% Now use the appropriate mAP
    boxVSfull = 0;
    maxID = 0;
    for q=1:30
        [maxFull, maxIDfull] = max(distratConfidence(q,:,1));
        [maxBox, maxIDbox] = max(distratConfidence(q,:,2));
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
    
    fprintf('\npTrim = %.2f -> mAP = %.4f\n', pTrim, mean(finalMAP));
    
end