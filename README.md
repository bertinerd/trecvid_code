TRECVID test-suite
====================

* TRECVID_test-suite considered the root folder (.)
* If necessary, modify and build.sh mtclient.cpp in build/src/mtclient.cpp
* CDVS-client retrieves the results from the server (On network 163)
	* Save the results. e.g. `../CDVS-client | tee ../results/<test_id>/CDVS-client.out`
* Go to TRECVID_test-suite/trecvid_code
* `./parseResultsCDVS.sh ../results/<test_id>` will parse CDVS raw results and will separate everything per query
* (opt) `matlab -nojvm -nodisplay -nosplash -r "readScores('../results/<test_id>/scores_only.res')" | tail -2` uses matlab to read the results and print a couple of stats
* (opt) `./createLinkedCopies.sh ../results/<test_id>` Create symbolic links of the top 500 keyframes of each query to have a "visual feedback" of the result of retrieval. Even if links, they occupy about 250MB per test.
* `matlab -nojvm -nodisplay -nosplash -r "prepare_treceval('<test_id>')"` Prepares the results for treceval mAP evaluation tool
* `./use_treceval.sh ../results/<test_id> | tee ../results/<test_id>/ALL.map` finally prints average precisions for each topic and each query.

* OTHERWISE, USE THIS SCRIPT TO RUN ALL NON-OPTIONAL PART: `./run_all.sh <test_id> <query-list> [--test]`
	* Use the flag --test to evaluate performance of a subset or different queries, i.e. not 9069:9098 + 1:4
---------------------------------------------------------------------------------------------------------------------
* In case you need to change the DB, modify configurations on arctic:/var/opt/duserworker/conf.parameters.txt
	* Name has to match trecvid2013.db.cdvs to be consistent with the .conf file (readonly)
* /etc/init/trecvid2013.conf must be edited to modify the mode (no parameters.txt only in this very case)
* IMPORTANT: every time you change the parameters or trecvid2013.conf you need to stop&start the service. i.e. `stop trecvid2013` and `start trecvid2013`
