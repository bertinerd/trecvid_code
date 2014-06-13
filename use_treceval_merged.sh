#!/bin/bash

cat $1/results_treceval/*.merged.result > $1/results_treceval/all.merged.res

# PRINT MAP
../trec_eval -q -a ../ins.search.qrels.tv13 $1/results_treceval/all.merged.res 1000 | grep "^map[[:space:]]" > $1/results_treceval/TREC_EVAL.merged.parsed

echo ":: RESULTS FOR TYPE D SUBMISSION ::"
cat $1/results_treceval/TREC_EVAL.merged.parsed

# # PRINT RECALL
# rm $1/ALL.recall  2> /dev/null
# echo ":: RESULTS FOR QUERY A ::" >> $1/ALL.recall
# ../trec_eval -q -a ../ins.search.qrels.tv13 $1/results_treceval/all.1.res 1000 | grep "^recall" >> $1/ALL.recall


# # PRINT PRECISION
# rm $1/ALL.precision  2> /dev/null
# echo ":: RESULTS FOR QUERY A ::" >> $1/ALL.precision
# ../trec_eval -q -a ../ins.search.qrels.tv13 $1/results_treceval/all.1.res 1000 | grep "^P" >> $1/ALL.precision
