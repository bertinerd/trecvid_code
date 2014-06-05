function save4TRECeval_new(shot_placed_cell,name,topic,query,n_results,test_id)
    fileName = strcat('~/TRECVID_test-suite/results/',test_id,'/results_treceval/',name,'.result');
    fout=fopen(fileName,'w');
    for r=1:n_results
        fprintf(fout,'\n%d 0 %s %d %d query%d',topic,shot_placed_cell{r},r,10000-r,query);
    end
    fclose(fout);
end
