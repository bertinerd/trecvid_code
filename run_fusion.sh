 #!/bin/bash


if [ $# -lt 1 -o $# -gt 6 ]; then
	echo "USAGE: ./run_all.sh [-c] <test-id> [query-list] <length-retrieval> <first-topic> <run-type>"
	echo "    -t: test execution, when topics are not 9069..9098 with examples 1..4"
	echo "    -c: complete execution. Uses polygon area + full image and merges the results. It also combines results of 4 examples"
	exit
fi

while getopts ":c" opt; do
  case $opt in
### -c: complete execution. 	
    c) 
	if [ $4 -eq 9069 ]
	then
		year=tv13
	fi

	if [ $4 -eq 9099 ]
	then
		year=tv14
	fi	

	sed -i "s/jpg retrievalLength/jpg $3/g" ../queries.$year\.*	
	testid_poly=`echo $2\_poly`
	testid_full=`echo $2\_full`
	# echo "./run_all.sh $testid_poly ../queries.tv13.$5.poly ......"
	# ./run_all.sh $testid_poly ../queries.tv13.$5.poly
	# mv CDVS-client.time ../results/$testid_poly/ 
	# echo "./run_all.sh $testid_full ../queries.tv13.$5\.full ......"
	# ./run_all.sh $testid_full ../queries.tv13.$5\.full
	# mv CDVS-client.time ../results/$testid_full/
	# mkdir ../results/$2
	# mv ../results/$testid_poly ../results/$2/
	# mv ../results/$testid_full ../results/$2/
        	matlab -nodisplay -nosplash -r "testFusion2('$2','tm10','$3','$4','$5')"
	matlab -nojvm -nodisplay -nosplash -r "prepare_treceval_fusion('$2','$4')"
	./use_treceval_fusion.sh ../results/$2
       	sed -i "s/jpg $3/jpg retrievalLength/g" ../queries.$year\.*
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
cat $2 | grep -o "9.*jpg" | sed 's/\.jpg//g' > ../results/$1/queries.names
nQueries=`wc -l ../results/$1/queries.names | cut -d' ' -f1`

# CDVS-client retrieves results from the server (On network 163)
../CDVS-client $2 $nQueries | tee ../results/$1/CDVS-client.out

# Parse CDVS raw results and separate everything per query
./parseResultsCDVS.sh ../results/$1 $2

# # Prepare results for treceval mAP evaluation tool
matlab -nojvm -nodisplay -nosplash -r "prepare_treceval('$1','../results/$1/queries.names')"

# # Print average precisions for each topic and each query
./use_treceval.sh ../results/$1 | sed 's/ \+/ /g' | tee ../results/$1/ALL.map
matlab -nojvm -nodisplay -nosplash -r "MAP_from_treceval('$1','$4')"
echo
echo ":: RESULTS WRITTEN IN ../results/$1/ALL.map"

