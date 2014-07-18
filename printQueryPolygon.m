clear
warning('off','all');
warning;

% Location of file containing query polygons (for CDVS-client)
fileName = '~/TRECVID_test-suite/queries.tv14.poly';
fout = fopen(fileName,'w');
for topic=9099:9128
   for query=1:4
       % Full BW mask provided by TRECVID
       maskBW=logical(rgb2gray(imread(strcat('../tv14_ins_topics/resized_bmp/mask/',int2str(topic),'.',int2str(query),'.mask.bmp'))));
       nPixelMask = sum(sum(maskBW==1));
       % structuring element dimension is adapted to the size of the
       % bounding box. The bigger the object, the bigger the margin
       dimSE = round(log2(nPixelMask/1000)*2+4);
       dimSE = max(dimSE,6);
       structuring_element = strel('disk',dimSE);
       % Dilate the binary mask using the structuring element
       dimSE = 2;
       maskBW_dilated = maskBW;
       % For CDVS, a query object should be at least 40x40 pixels
       while(sum(sum(maskBW_dilated))<40*40)
            dimSE=dimSE+1;
            structuring_element = strel('disk',dimSE);
            maskBW_dilated = logical(imdilate(maskBW,structuring_element));
       end
       
       maskC = bwmorph(maskBW,'remove');
       % Transform the full mask into a contour of 1px width
       maskC_dilated = bwmorph(maskBW_dilated,'remove');
       [maskC_dilated, startFrom] = correctContour(maskC_dilated, topic, query);
       
       subplot(3,1,2)
       imshow(maskC_dilated)
       
       srcRGB=imread(strcat('../tv14_ins_topics/resized_bmp/src/',int2str(topic),'.',int2str(query),'.src.bmp')); 
       srcRGB(maskC) = 100;
       srcRGB(maskC_dilated) = 255;
       figure(1)
       subplot(3,1,1)
       imshow(srcRGB)
                
       % x,y coordinates of points belonging to contour
       [Yraster,Xraster] = find(maskC_dilated==1);
       % starting point for polygon computation
       if(startFrom==0)
            [~,raster]=min(Yraster+Xraster);
       else
            [~,raster]=max(Yraster+Xraster); 
       end
       
       pStart.x = Xraster(raster);
       pStart.y = Yraster(raster);

       polygon = computePolygon(pStart, maskC_dilated);
       polygon_a = struct2array(polygon);
       % Convert polygon in a string [x1,y1, ..., xN, yN] compatible with mtclient.cpp format 
       polygon_str = arrayfun(@(x) (int2str(x)),polygon_a,'UniformOutput',false);
       polygon_final = strcat('[',strjoin(polygon_str,','),']');
       fprintf('\n:: Query %d.%d - %d points, %d vertex ::\n', topic, query, sum(sum(maskC_dilated)), numel(polygon)); 
       fprintf(fout,'q file:////home/cdvs/TRECVID/queries2014/src/%d.%d.src.jpg retrievalLength %s\n', topic, query, polygon_final);

       imgOut = strcat('../tv14_ins_topics/bounding_poly/',int2str(topic),'.',int2str(query),'.bmp');        
       print (gcf, '-dbmp', imgOut)          
   end
end

fclose(fout);