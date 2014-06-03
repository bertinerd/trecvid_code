function [maskC_correct, startFrom] = correctContour(maskC_dilated, topic, query)
    maskC_correct = maskC_dilated;
    startFrom = 0;
    
    if topic==9072 && query==3
       maskC_correct(378,303)=1;
       maskC_correct(378,302)=0;
       maskC_correct(379,302)=0;
    end
    
    if topic==9076 && query==1
       maskC_correct(79,149)=0;
       maskC_correct(80,149)=0;
       maskC_correct(80,150)=0;
       maskC_correct(81,150)=1;
    end
    
    if topic==9076 && query==2
       maskC_correct(100,511)=0;
    end
    
    if topic==9077 && query==3
       maskC_correct(429,5)=0;
       maskC_correct(428,5)=0;
    end
    
    if topic==9077 && query==4
       maskC_correct(68:69,585)=0;
    end  
    
    if topic==9080 && query==2
       startFrom = 1;
    end
    if topic==9088 && query==4
       maskC_correct(180,270)=0;
       maskC_correct(181,269)=0;
       maskC_correct(181,271)=0;
       maskC_correct(182,270)=0;
       maskC_correct(184,269)=0;
       maskC_correct(185,270)=0;
       maskC_correct(185,268)=0;
       maskC_correct(186,269)=0;  
    end
    
    if topic==9090 && query==3
       maskC_correct(243,9)=0;
    end

    if topic==9091 && query==1
       maskC_correct(431,105)=0;
       maskC_correct(430,105)=0;
       maskC_correct(429,107)=0;
       maskC_correct(429,108)=0;
       maskC_correct(429,109)=0;
       maskC_correct(428,110)=0;
       maskC_correct(428,106)=0;       
       maskC_correct(427,110)=0;
       maskC_correct(426,109)=0;
       maskC_correct(427,108)=0;
       maskC_correct(427,107)=0;
       maskC_correct(429,106)=1;
    end
    if topic==9092 && query==4
       maskC_correct(161:179,254:258)=0;
       maskC_correct(170:179,253)=1;
       maskC_correct(168:169,253)=0;
       maskC_correct(170,252:253)=0;
       maskC_correct(171,253)=0;
    end
    if topic==9093 && query==1
       maskC_correct(429:431,502:508)=0;
       maskC_correct(431,501)=1;
       maskC_correct(430,501)=0;  
    end
    if topic==9093 && query==2
       maskC_correct(180:432,1:52)=0;
       maskC_correct(432,174)=0;       
    end

    if topic==9093 && query==3
       maskC_correct(1:432,1:34)=0;
    end       
    if topic==9098 && query==4
       maskC_correct(173:181,460:469)=0;
       maskC_correct(173:182,459)=1;
       maskC_correct(182,459:468)=1;       
    end        
    
end