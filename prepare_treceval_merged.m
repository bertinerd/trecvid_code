function prepare_treceval_merged(test_id)

load('../keyframe2shot.mat')
mkdir(strcat('../results/',test_id,'/results_treceval'));
for topic=9069:9098
    organizeTRECeval_merged(keyframe2shot,test_id,topic);    
end

% exit
end
