function [maskC_correct, startFrom] = correctContour(maskC_dilated, topic, query)
    maskC_correct = maskC_dilated;
    startFrom = 0;
    
    if topic==9102 && query==2
       maskC_correct(380:381,535:539)=0;
       maskC_correct(382,542)=0;
       maskC_correct(381,542:548)=1;
       maskC_correct(380,540)=1;
       maskC_correct(380,542:548)=0;
       maskC_correct(342,607)=0;
    end
    
    if topic==9108
       startFrom = 1; 
       if query==1
           maskC_correct(133,647)=0;
       end
       if query==3
           maskC_correct(119,495:496)=0;
           maskC_correct(144,475)=0;
       end       
    end
    
    if topic==9110 && query==1
       maskC_correct(65,7)=0; 
    end
    
    if topic==9113 && query==2
        startFrom = 1;
        maskC_correct(221,602) = 0;
        maskC_correct(251,578) = 0;
    end
    
    if topic==9114 && query==3
        startFrom = 1;
        maskC_correct(183,694) = 0;
        maskC_correct(255,599) = 0;
    end    
    
    if topic==9115 && query==4
        maskC_correct(136:137,5) = 0;        
    end
    
    if topic==9120 && query==1
       startFrom = 1;
       maskC_correct(304,415) = 0;  
       maskC_correct(257,214) = 0;  
       maskC_correct(332,287) = 0;
       maskC_correct(430,320:341) = 1;
       maskC_correct(431:432,320:341) = 0;
    end

    if topic==9120 && query==4
        startFrom = 1;
        maskC_correct(213,566) = 0;
        maskC_correct(430,640) = 0;
        maskC_correct(206,326) = 0; 
    end
    
    if topic==9121 && query==3
        startFrom = 1;
    end
    
    if topic==9125 && query==2
       maskC_correct(241:249,374:375) = 0;
       maskC_correct(250,375) = 1;
       maskC_correct(250,374) = 0;
       maskC_correct(406,463) = 0;
       maskC_correct(405,462) = 0;
    end
    
    if topic==9125 && query==3
       startFrom = 1;
       maskC_correct(254:256,243:244) = 0;
       maskC_correct(257,243) = 1;
       maskC_correct(257,242) = 0;
       maskC_correct(291,161) = 0;
       maskC_correct(387,123) = 0;
       maskC_correct(430,127:253) = 1;
       maskC_correct(431:432,127:253) = 0;
    end
    
    if topic==9127 && query==1
        maskC_correct(136:137,74) = 0;
    end

    if topic==9127 && query==2
        maskC_correct(61:62,228) = 0;
    end    
    
    
end