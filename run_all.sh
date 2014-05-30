#!/bin/bash

mkdir ../results/$1

# CDVS-client retrieves results from the server (On network 163)
../CDVS-client | tee ../results/$1/CDVS-client.out

# parse CDVS raw results and separate everything per query
./parseResultsCDVS.sh ../results/$1

# Prepare results for treceval mAP evaluation tool
matlab -nojvm -nodisplay -nosplash -r "prepare_treceval('$1')"

#  Finally print average precisions for each topic and each query
./use_treceval.sh ../results/$1 | tee ../results/$1/ALL.map
echo
echo ":: RESULTS WRITTEN IN ../results/$1/ALL.map"
