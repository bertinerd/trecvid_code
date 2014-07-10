#!/bin/bash

mkdir ../results/test_poly

for query in `cat ../queries.poly | cut -d' ' -f2`;
do
	
	n_res=`cat ../results/test_poly/CDVS-client.out | grep $query -A1 | tail -1 | cut -d' ' -f2`
	n_res1=$((n_res+1))
	queryN=`echo $query | grep -o "90.*.jpg" | sed 's/\.jpg//g'`
	# WARNING: it could be necessary to change cut -f3 to -f4
	cat ../results/test_poly/CDVS-client.out | grep $query -A$n_res1 | tail -$n_res | cut -d'/' -f3 | sed 's/.jpg//g' # > ../results/test_poly/res_perQuery/$queryN\.res
	echo $query $n_res $n_res1 $queryN
	sleep 2
done

#cat $1/res_perQuery/*.res | grep -v " 0" | cut -d' ' -f2 > $1/scores_only.res



