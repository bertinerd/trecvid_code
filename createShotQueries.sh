#!/bin/bash

root="file:///home/duserworker/TRECVID/queries2013/shot/K$1"
for topic in {9069..9098};
do
	for q in {1..4};
	do		
		line=''
		for t in {1..64};
		do
			t0=`printf "%02d" "$t"`
			new_image=`echo $root\/$topic\.$q\.$t0\.jpg`
			line=`echo $line $new_image`
		done
		echo $line
	done
done > queries.tv13.4.shot$1\.tmp

sed -i 's/ /,/g' queries.tv13.4.shot$1\.tmp

while read line;
do
	echo "q" $line "retrievalLength"
done < queries.tv13.4.shot$1\.tmp > queries.tv13.4.shot$1

rm queries.tv13.4.shot$1\.tmp


