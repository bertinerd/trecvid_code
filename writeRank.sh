#!/bin/bash

cd $1/res_perQuery
for q in *.res;
do
	i=0
	while read keyframe score;
	do
		i=$((i+1))
		printf -v r "r%03d" $i
		echo $r $keyframe $score	
	done < $q | head -500 > $q\.rank
done
cd ../..
