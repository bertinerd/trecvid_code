#!/bin/bash


if [ $# -lt 1 -o $# -gt 3 ]; then
	echo "USAGE: ./run_all.sh [-t | -c] <test-id> [query-list]"
	echo "    -t: test execution, when topics are not 9069..9098 with examples 1..4"
	echo "    -c: complete execution. Uses polygon area + full image and merges the results. It also combines results of 4 examples"
	exit
fi

while getopts ":tc" opt; do
  case $opt in
### -t: test execution. 	
    
    t)
	mkdir ../results/$2
	# Extract query names
	cat $3 | grep -o "90.*jpg" | sed 's/\.jpg//g' > ../results/$2/queries.names
	nQueries=`wc -l ../results/$2/queries.names | cut -d' ' -f1`
	# CDVS-client retrieves results from the server (On network 163)
	../CDVS-client $3 $nQueries | tee ../results/$2/CDVS-client.out
	# Parse CDVS raw results and separate everything per query
	./parseResultsCDVS.sh ../results/$2 $3
	# Prepare results for treceval mAP evaluation tool
	matlab -nojvm -nodisplay -nosplash -r "prepare_treceval('$2','../results/$1/queries.names')"
	for q in `cat ../results/$2/queries.names`;
		do echo $q; ../trec_eval -q -a ../ins.search.qrels.tv13 ../results/$2/results_treceval/$q\.result 1000 | grep "^map[[:space:]]" | grep -v 'all';
	done
	exit      
      ;;

### -c: complete execution. 	
    c) 
	testid_poly=`echo $2\_poly`
	testid_full=`echo $2\_full`
	echo "./run_all.sh $testid_poly ../queries.poly ......"
	./run_all.sh $testid_poly ../queries.poly
	echo "./run_all.sh $testid_full ../queries.full ......"
	./run_all.sh $testid_full ../queries.full
	matlab -nojvm -nodisplay -nosplash -r "boxVSfull('$testid_poly','$testid_full')" | tee ../results/$2\_poly/COMPLETE.map
	mkdir ../results/$2
	mv ../results/$testid_poly ../results/$2/
	mv ../results/$testid_full ../results/$2/
	mv ../results/$2/$testid_poly/COMPLETE.map ../results/$2/COMPLETE.map
	exit
      ;;
    \?)
	echo "Invalid option: -$OPTARG" >&2
	echo "USAGE: ./run_all.sh [-t] [-c] <test-id> <query-list>"
	echo "    -t: use in test situations, when topics are not 9069..9098 with examples 1..4"
	echo "    -c: complete execution. Uses polygon area + full image and merges the results. It also combines results of 4 examples"
	exit
      ;;
  esac
done

### DEFAULT execution.
mkdir ../results/$1
# Extract query names
cat $2 | grep -o "90.*jpg" | sed 's/\.jpg//g' > ../results/$1/queries.names
nQueries=`wc -l ../results/$1/queries.names | cut -d' ' -f1`

# CDVS-client retrieves results from the server (On network 163)
../CDVS-client $2 $nQueries | tee ../results/$1/CDVS-client.out

# Parse CDVS raw results and separate everything per query
./parseResultsCDVS.sh ../results/$1 $2

# Prepare results for treceval mAP evaluation tool
matlab -nojvm -nodisplay -nosplash -r "prepare_treceval('$1','../results/$1/queries.names')"

# Print average precisions for each topic and each query
./use_treceval.sh ../results/$1 | sed 's/ \+/ /g' | tee ../results/$1/ALL.map
matlab -nojvm -nodisplay -nosplash -r "MAP_from_treceval('$1')"
echo
echo ":: RESULTS WRITTEN IN ../results/$1/ALL.map"

