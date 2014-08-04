### DEFAULT execution.
mkdir ../results/$1
# Extract query names
cat $2 | grep -o "9.*jpg" | sed 's/\.jpg//g' > ../queries.$3.names
nQueries=`wc -l ../queries.$3\.names | cut -d' ' -f1`
# CDVS-client retrieves results from the server (On network 163)
../CDVS-client $2 $nQueries | tee ../results/$1/CDVS-client.out

# # # Parse CDVS raw results and separate everything per query
./parseResultsCDVS_multiQuery.sh ../results/$1 $2

# # # Prepare results for treceval mAP evaluation tool
matlab -nojvm -nodisplay -nosplash -r "prepare_treceval('$1','../queries.$3\.names')"

# # # # Print average precisions for each topic and each query
./use_treceval.sh ../results/$1 | sed 's/ \+/ /g' | tee ../results/$1/ALL.map
matlab -nojvm -nodisplay -nosplash -r "MAP_from_treceval('$1','$4')"
echo
echo ":: RESULTS WRITTEN IN ../results/$1/ALL.map"

