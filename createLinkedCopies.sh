#!/bin/bash
# Create symbolic links of the top 500 retrieved keyframes for each query

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

for q in *.rank;
do
	echo $q
	folderName=`echo keyframes_$q | sed 's/\./_/g' | sed 's/_res_rank//g'`
	mkdir $folderName
	while read rank keyframe score;
	do
		vID=`echo $keyframe | cut -d'_' -f1`
		ln -s ~/TRECVID/videos/deinterlaced/keyframes_all/$vID/K/$keyframe\.jpg $folderName/$rank\.jpg
		
	done < $q

done

mkdir scores
mv *.rank scores/
cd ../..
