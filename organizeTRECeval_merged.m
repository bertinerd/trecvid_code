function organizeTRECeval_merged(keyframe2shot, test_id, topic)
    
    fprintf('\n:: Preparing results in treceval format for %d ::\n', topic);
    results_file = strcat('~/TRECVID_test-suite/results/',test_id,'/',int2str(topic),'.fusion.res');
    results=readList(results_file);
    n_results = numel(results);
    shot_placed_map = containers.Map('KeyType','char','ValueType','uint16');
    shot_placed_cell = cell(1,n_results);
    
    for k=1:n_results
        sID = keyframe2shot(results{k}{1});
        if(~shot_placed_map.isKey(sID))
            shot_placed_map(sID) = shot_placed_map.Count;
            shot_placed_cell{shot_placed_map.Count} = sID;
        end
    
    end
    n_results = shot_placed_map.Count;
    shot_placed_cell(n_results+1:end) = [];
    numShots = min(numel(shot_placed_cell),1000); 
    save4TRECeval_merged(shot_placed_cell, topic, numShots, test_id)

end
