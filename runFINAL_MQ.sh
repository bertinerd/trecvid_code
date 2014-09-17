 #!/bin/bash


if [ $# -lt 1 -o $# -gt 6 ]; then
	echo "USAGE: ./runFINAL_MQ.sh [-c] <test-id> <length-retrieval> <first-topic> <runType> <queryPerShot>"
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
	testid_full=`echo $2\_full`
        	echo "RUNNING $testid_full ../queries.tv13.$5.full ......"
        	./runFull_MQ.sh $testid_full ../queries.$year.$5.shot$6 $year
        	#mv CDVS-client.time ../results/$testid_full/
	#echo "RUNNING $testid_poly ../queries.tv13.$5\.poly ......"
	#mkdir ../results/$2
	#mv ../results/$testid_full ../results/$2/
        	#matlab -nodisplay -nosplash -r "testFusion2('$2','tm10','$3','$4','$5')"
	#matlab -nojvm -nodisplay -nosplash -r "prepare_treceval_fusion('$2','$4')"
	#./use_treceval_fusion.sh ../results/$2
	#./createLinkedCopies.sh ../results/$2
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

