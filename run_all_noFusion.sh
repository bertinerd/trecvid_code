#!/bin/bash

#if [ $# -lt 2 -o $# -gt 3 ]; then
#	echo "USAGE: ./run_all.sh <test-id> <query-list> [--test]"
#	exit
#fi

#mkdir ../results/$1

# Extract query names
#cat $2 | grep -o "90.*jpg" | sed 's/\.jpg//g' > ../results/$1/queries.names
#nQueries=`wc -l ../results/$1/queries.names | cut -d' ' -f1`

# CDVS-client retrieves results from the server (On network 163)
#../CDVS-client $2 $nQueries | tee ../results/$1/CDVS-client.out

# Parse CDVS raw results and separate everything per query
#./parseResultsCDVS.sh ../results/$1 $2

# Prepare results for treceval mAP evaluation tool
matlab -nojvm -nodisplay -nosplash -r "prepare_treceval('$1','../results/$1/queries.names')"

# If it is a test, do not consider topics 9069:9098 and queries 1:4
if [ $# -eq 3 ]; then
	for q in `cat ../results/$1/queries.names`;
		do echo $q; ../trec_eval -q -a ../ins.search.qrels.tv13 ../results/$1/results_treceval/$q\.result 1000 | grep "^map[[:space:]]" | grep -v 'all';
	done
else
	# Print average precisions for each topic and each query
	./use_treceval.sh ../results/$1 | sed 's/ \+/ /g' | tee ../results/$1/ALL.map
	matlab -nojvm -nodisplay -nosplash -r "MAP_from_treceval('$1')"

	echo
	echo ":: RESULTS WRITTEN IN ../results/$1/ALL.map"
fi


