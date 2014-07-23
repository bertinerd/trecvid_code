function prepare_treceval_fusion(test_id,firstTopic)
    firstTopic = str2double(firstTopic);
    load('../keyframe2shot.mat')
    mkdir(strcat('../results/',test_id,'/results_treceval'));
    for topic=firstTopic:(firstTopic+29)
        organizeTRECeval_fusion(keyframe2shot,test_id,topic);    
    end
exit
end
