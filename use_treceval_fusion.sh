#!/bin/bash

cat $1/*.result > $1/all.res

# PRINT MAP
../trec_eval -q -a ../ins.search.qrels.tv13 $1/all.res 1000 | grep "^map[[:space:]]" > $1/TREC_EVAL.parsed

echo ":: FUSION - TYPE D - RESULTS::"
cat $1/results_treceval/TREC_EVAL.1.parsed

