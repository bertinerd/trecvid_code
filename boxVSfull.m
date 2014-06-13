function boxVSfull(id_poly,id_full)
    pTrim = 0.1;
    % nKeypointsBox = [14 11 13 41 35 49 17 73 20 11 12 18 5 26 24 7 10 23 33 8 16 9 3 3 14 11 20 72 26 38 555 13 35 543 479 575 25 23 18 14 178 223 202 472 73 128 297 29 146 565 400 557 5 6 22 11 18 134 33 33 517 59 267 254 14 16 8 28 24 49 30 44 18 9 7 18 446 376 210 117 3 4 8 5 135 198 264 239 68 8 29 8 55 54 44 51 197 78 115 285 25 6 6 21 72 66 44 24 475 509 509 258 34 35 8 31 99 111 35 54];
    % nKeypointsFull = [561 569 569 557 569 575 559 564 571 553 560 572 580 587 570 564 559 569 567 582 558 562 555 557 555 559 563 560 562 552 557 563 579 584 591 588 561 559 556 552 556 564 550 553 554 554 559 551 555 556 556 555 566 565 609 581 566 557 560 562 567 561 573 565 564 586 565 568 559 560 557 560 557 556 553 560 568 570 559 560 558 565 562 562 549 547 548 553 554 549 555 561 554 554 552 554 558 563 583 574 558 557 562 565 554 571 555 546 561 562 561 566 553 551 565 553 559 556 558 562];
    sizeFull = 432*768;
    sizeBoxes = readList('../boundingBoxSize.txt');
    fFull = strcat('../results/',id_full);
    fBox = strcat('../results/',id_poly);
    map1full = readList(strcat(fFull,'/results_treceval/TREC_EVAL.1.parsed'));
    map2full = readList(strcat(fFull,'/results_treceval/TREC_EVAL.2.parsed'));
    map3full = readList(strcat(fFull,'/results_treceval/TREC_EVAL.3.parsed'));
    map4full = readList(strcat(fFull,'/results_treceval/TREC_EVAL.4.parsed'));
    mapFull = [map1full map2full map3full map4full];
    map1box = readList(strcat(fBox,'/results_treceval/TREC_EVAL.1.parsed'));
    map2box = readList(strcat(fBox,'/results_treceval/TREC_EVAL.2.parsed'));
    map3box = readList(strcat(fBox,'/results_treceval/TREC_EVAL.3.parsed'));
    map4box = readList(strcat(fBox,'/results_treceval/TREC_EVAL.4.parsed'));
    mapBox = [map1box map2box map3box map4box];
    clear map1full map2full map3full map4full map1box map2box map3box map4box

    gain = zeros(1,numel(sizeBoxes));
    mAP = zeros(30,4);
    score = zeros(30,4);
    mapBox_v = zeros(1,numel(sizeBoxes));
    mapFull_v = zeros(1,numel(sizeBoxes));
    mAP_final = zeros(1,30);

    for i=1:numel(sizeBoxes)
       topic = str2double(sizeBoxes{i}{1});
       query = str2double(sizeBoxes{i}{2});
       mapBox_v(i) = str2double(mapBox{topic-9068,query}{15});
       mapFull_v(i) = str2double(mapFull{topic-9068,query}{15});
       resFull = readList(strcat(fFull,'/res_perQuery/',sizeBoxes{i}{1},'.',sizeBoxes{i}{2},'.src.res'));
       sumDistratFull = zeros(1,numel(resFull));
       for r=1:numel(resFull);
          if str2double(resFull{r}{2})==0, break; end
          sumDistratFull(r) = str2double(resFull{r}{2});
       end

       % shrink the array to the nonzero values
       sumDistratFull(r:end)=[];
       % trim away top 5% and bottom 5% from the score
       p5F = round(pTrim*r);

       resBox = readList(strcat(fBox,'/res_perQuery/',sizeBoxes{i}{1},'.',sizeBoxes{i}{2},'.src.res'));
       sumDistratBox = zeros(1,numel(resBox));

       for r=1:numel(resBox);
          if str2double(resBox{r}{2})==0, break; end
          sumDistratBox(r) = str2double(resBox{r}{2});
       end

       % shrink the array to the nonzero values
       sumDistratBox(r:end)=[];
       % trim away top 5% and bottom 5% from the score
       p5B = round(pTrim*r);
       % normalize the sum of distrat scores
       scoreFull = sum(sumDistratFull(p5F+1:end-p5F))/sqrt(sizeFull);
       scoreBox = sum(sumDistratBox(p5B+1:end-p5B))/sqrt(str2double(sizeBoxes{i}{3}));
    %    scoreFull = sumDistratFull/nKeypointsFull(i);
    %    scoreBox = sumDistratBox/nKeypointsBox(i);

       % decide which version of the query to pick (bounding box vs full)
       % according to the normalized distrat score
       if scoreFull>scoreBox
           out='ALL';
           gain(i) = mapFull_v(i) - mapBox_v(i);
           mAP(topic-9068,query) = mapFull_v(i);
           score(topic-9068,query) = scoreFull;
       else
           out ='BOX';
           gain(i) = 0;
           mAP(topic-9068,query) = mapBox_v(i);
           score(topic-9068,query) = scoreBox;
       end

       fprintf('%d.%d    %s    score = %2.4f    mAP = %.4f\n', topic, query, out, score(topic-9068,query), mAP(topic-9068,query));
    end
    [~,id_max]=max(score,[],2);

    fprintf('\n:: mapBox = %.4f :: mapFull = %.4f :: mapCombined = %.4f\n',mean(mapBox_v),mean(mapFull_v),mean(mean(mAP)));

    % Pick the query with the best normalized distrat score for each topic

    for t=1:30
        mAP_final(t) = mAP(t,id_max(t));
    end

    fprintf('\n:: Final mAP (type D submission) = %.4f\n',mean(mAP_final));
exit
end