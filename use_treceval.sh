#!/bin/bash

cat $1/results_treceval/*.1.result > $1/results_treceval/all.1.res
cat $1/results_treceval/*.2.result > $1/results_treceval/all.2.res
cat $1/results_treceval/*.3.result > $1/results_treceval/all.3.res
cat $1/results_treceval/*.4.result > $1/results_treceval/all.4.res

# PRINT MAP
../trec_eval -q -a ../ins.search.qrels.tv13 $1/results_treceval/all.1.res 1000 | grep "^map[[:space:]]" > $1/results_treceval/TREC_EVAL.1.parsed
../trec_eval -q -a ../ins.search.qrels.tv13 $1/results_treceval/all.2.res 1000 | grep "^map[[:space:]]" > $1/results_treceval/TREC_EVAL.2.parsed
../trec_eval -q -a ../ins.search.qrels.tv13 $1/results_treceval/all.3.res 1000 | grep "^map[[:space:]]" > $1/results_treceval/TREC_EVAL.3.parsed
../trec_eval -q -a ../ins.search.qrels.tv13 $1/results_treceval/all.4.res 1000 | grep "^map[[:space:]]" > $1/results_treceval/TREC_EVAL.4.parsed

echo ":: RESULTS FOR QUERY A ::"
cat $1/results_treceval/TREC_EVAL.1.parsed
echo ":: RESULTS FOR QUERY B ::"
cat $1/results_treceval/TREC_EVAL.2.parsed
echo ":: RESULTS FOR QUERY C ::"
cat $1/results_treceval/TREC_EVAL.3.parsed
echo ":: RESULTS FOR QUERY D ::"
cat $1/results_treceval/TREC_EVAL.4.parsed

# PRINT RECALL
rm $1/ALL.recall  2> /dev/null
echo ":: RESULTS FOR QUERY A ::" >> $1/ALL.recall
../trec_eval -q -a ../ins.search.qrels.tv13 $1/results_treceval/all.1.res 1000 | grep "^recall" >> $1/ALL.recall
echo ":: RESULTS FOR QUERY B ::" >> $1/ALL.recall
../trec_eval -q -a ../ins.search.qrels.tv13 $1/results_treceval/all.2.res 1000 | grep "^recall" >> $1/ALL.recall
echo ":: RESULTS FOR QUERY C ::" >> $1/ALL.recall
../trec_eval -q -a ../ins.search.qrels.tv13 $1/results_treceval/all.3.res 1000 | grep "^recall" >> $1/ALL.recall
echo ":: RESULTS FOR QUERY D ::" >> $1/ALL.recall
../trec_eval -q -a ../ins.search.qrels.tv13 $1/results_treceval/all.4.res 1000 | grep "^recall" >> $1/ALL.recall

# PRINT PRECISION
rm $1/ALL.precision  2> /dev/null
echo ":: RESULTS FOR QUERY A ::" >> $1/ALL.precision
../trec_eval -q -a ../ins.search.qrels.tv13 $1/results_treceval/all.1.res 1000 | grep "^P" >> $1/ALL.precision
echo ":: RESULTS FOR QUERY B ::" >> $1/ALL.precision
../trec_eval -q -a ../ins.search.qrels.tv13 $1/results_treceval/all.2.res 1000 | grep "^P" >> $1/ALL.precision
echo ":: RESULTS FOR QUERY C ::" >> $1/ALL.precision
../trec_eval -q -a ../ins.search.qrels.tv13 $1/results_treceval/all.3.res 1000 | grep "^P" >> $1/ALL.precision
echo ":: RESULTS FOR QUERY D ::" >> $1/ALL.precision
../trec_eval -q -a ../ins.search.qrels.tv13 $1/results_treceval/all.4.res 1000 | grep "^P" >> $1/ALL.precision