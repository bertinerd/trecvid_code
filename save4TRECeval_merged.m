function save4TRECeval_merged(shot_placed_cell, topic, n_results, test_id)
    fileName = strcat('~/TRECVID_test-suite/results/',test_id,'/results_treceval/',int2str(topic),'.merged.result');
    fout=fopen(fileName,'w');
    for r=1:n_results
        fprintf(fout,'\n%d 0 %s %d %d typeD',topic,shot_placed_cell{r},r,10000-r);
    end
    fclose(fout);
end
