clear all
clc
sizeFull = 432*768;
sizeBoxes = readList('../boundingBoxSize.txt');
fFull = '../results/04_06_full/res_perQuery/';
fBox = '../results/04_06_chiSquare99/res_perQuery/';
map1full = readList('../results/04_06_full/results_treceval/TREC_EVAL.1.parsed');
map2full = readList('../results/04_06_full/results_treceval/TREC_EVAL.2.parsed');
map3full = readList('../results/04_06_full/results_treceval/TREC_EVAL.3.parsed');
map4full = readList('../results/04_06_full/results_treceval/TREC_EVAL.4.parsed');
mapFull = [map1full map2full map3full map4full];
map1box = readList('../results/04_06_chiSquare99/results_treceval/TREC_EVAL.1.parsed');
map2box = readList('../results/04_06_chiSquare99/results_treceval/TREC_EVAL.2.parsed');
map3box = readList('../results/04_06_chiSquare99/results_treceval/TREC_EVAL.3.parsed');
map4box = readList('../results/04_06_chiSquare99/results_treceval/TREC_EVAL.4.parsed');
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
   resFull = readList(strcat(fFull,sizeBoxes{i}{1},'.',sizeBoxes{i}{2},'.res'));
   sumDistratFull = 0;
   for r=1:numel(resFull);
      if str2double(resFull{r}{2})==0, break; end
      sumDistratFull = sumDistratFull + str2double(resFull{r}{2});
   end
   
   resBox = readList(strcat(fBox,sizeBoxes{i}{1},'.',sizeBoxes{i}{2},'.res'));
   sumDistratBox = 0;
   for r=1:numel(resBox);
      if str2double(resBox{r}{2})==0, break; end
      sumDistratBox = sumDistratBox + str2double(resBox{r}{2});
   end
   
   % normalize the sum of distrat scores
   scoreFull = sumDistratFull/sqrt(sizeFull);
   scoreBox = sumDistratBox/sqrt(str2double(sizeBoxes{i}{3}));
   % decide which version of the query to pick (boundin box vs full)
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
   
%    fprintf('%d.%d    %.4f    %.4f    %s    %.4f    %.4f    %.4f\n', topic, query, scoreFull, scoreBox, out,mapFull_c,mapBox_c, gain(i));
   fprintf('%d.%d    %s    score = %2.4f    mAP = %.4f\n', topic, query, out, score(topic-9068,query), mAP(topic-9068,query));
end
[~,id_max]=max(score,[],2);

fprintf('\n:: mapBox = %.4f :: mapFull = %.4f :: mapCombined = %.4f\n',mean(mapBox_v),mean(mapFull_v),mean(mean(mAP)));

% Pick the query with the best normalized distrat score for each topic

for t=1:30
    mAP_final(t) = mAP(t,id_max(t));
end
