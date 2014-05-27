function prepare_treceval(test_id)

load('../keyframe2shot.mat')
topics_all = (9069:9098);
mkdir(strcat('../results/',test_id,'/results_treceval'));

n_topics = numel(topics_all);
query_per_topic = 4;

for t=1:n_topics
    for q=1:query_per_topic
        organizeTRECeval(keyframe2shot,test_id,topics_all(t),q);
    end
end

exit
end

