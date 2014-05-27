TRECVID code
============
* Root folder (.) is considered TRECVIDgit
* If necessary, modify and build mtclient.cpp in build/src/mtclient.cpp
* CDVS-client can retrieve the results from the server (On network 163)
	* Save the results. e.g. `./CDVS-client > results/27_05_luca/CDVS-client.out`
* Create a file in the current test folder, e.g. results/27_05_luca/TEST.meta that explains all the details of the test
* Go to TRECVIDgit/trecvid_code
* `./parseResultsCDVS.sh ../results/27_05_luca` will parse CDVS raw results and will separate everything per query
* (opt) `matlab -nojvm -nodisplay -nosplash -r "readScores('../results/27_05_luca/scores_only.res')" | tail -2` uses matlab to read the results and print a couple of stats
* (opt) `./createLinkedCopies.sh ../results/27_05_luca` Create symbolic links of the top 500 keyframes of each query to have a "visual feedback" of the result of retrieval. Even if links, they occupy about 250MB per test.
* `matlab -nojvm -nodisplay -nosplash -r "prepare_treceval('27_05_luca')"` Prepares the results for treceval mAP evaluation tool
* `use_treceval.sh 27_05_luca` finally prints average precisions for each topic and each query.

