function MAP_from_treceval(test_id)
    file_results = strcat('../results/',test_id,'/ALL.map');
    results = readList(file_results);
    results_a = zeros(4,31);
    queryType = 0;
    topic = 1;

    for r=1:numel(results)
       if(strcmp(results{r}(1),'::'))
          queryType = queryType+1;
          topic = 1;
       else
           results_a(queryType,topic) = str2double(results{r}(4));
           topic = topic+1;
       end    
    end
    
    results_a(:,end)=[];
    fid = fopen(file_results,'a');
    fprintf(fid,':: RESULTS FOR ALL ::\n');
    fprintf(':: RESULTS FOR ALL ::\n');
    for q=1:30
       fprintf(fid,'map\t%d\t%.4f\n', q+9068, mean(results_a(:,q)));
       fprintf('map\t%d\t%.4f\n', q+9068, mean(results_a(:,q)));
    end
    fprintf(fid,'\nmap\tALL\t%.4f\n', mean(mean(results_a)));
    fprintf('\nmap\tALL\t%.4f\n', mean(mean(results_a)));
    exit
end
