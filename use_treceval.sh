#!/bin/bash

cat ../results/$1/results_treceval/*.1.result > ../results/$1/results_treceval/all.1.res
cat ../results/$1/results_treceval/*.2.result > ../results/$1/results_treceval/all.2.res
cat ../results/$1/results_treceval/*.3.result > ../results/$1/results_treceval/all.3.res
cat ../results/$1/results_treceval/*.4.result > ../results/$1/results_treceval/all.4.res

../trec_eval -q -a ../ins.search.qrels.tv13 ../results/$1/results_treceval/all.1.res 1000 | grep "^map[[:space:]]" > ../results/$1/results_treceval/TREC_EVAL.1.parsed

../trec_eval -q -a ../ins.search.qrels.tv13 ../results/$1/results_treceval/all.2.res 1000 | grep "^map[[:space:]]" > ../results/$1/results_treceval/TREC_EVAL.2.parsed

../trec_eval -q -a ../ins.search.qrels.tv13 ../results/$1/results_treceval/all.3.res 1000 | grep "^map[[:space:]]" > ../results/$1/results_treceval/TREC_EVAL.3.parsed

../trec_eval -q -a ../ins.search.qrels.tv13 ../results/$1/results_treceval/all.4.res 1000 | grep "^map[[:space:]]" > ../results/$1/results_treceval/TREC_EVAL.4.parsed

echo ":: RESULTS FOR QUERIES A ::"
cat ../results/$1/results_treceval/TREC_EVAL.1.parsed

echo ":: RESULTS FOR QUERY B ::"
cat ../results/$1/results_treceval/TREC_EVAL.2.parsed

echo ":: RESULTS FOR QUERY C ::"
cat ../results/$1/results_treceval/TREC_EVAL.3.parsed

echo ":: RESULTS FOR QUERY D ::"
cat ../results/$1/results_treceval/TREC_EVAL.4.parsed
