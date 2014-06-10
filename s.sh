#!/bin/bash

for i in {1..20}
do
	testID=`printf "testMB_%02d" "$i"`
	./run_all.sh $testID ../queries.$testID\.poly
done
