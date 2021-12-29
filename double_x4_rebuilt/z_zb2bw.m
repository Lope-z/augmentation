function I1 = z_zb2bw(ex,ey,MN)


    I = uint8(zeros(MN(1),MN(2)));
    for i = 1:length(ex)
        I(round(ey(i)),round(ex(i))) = 255;
    end

    
    BW = imdilate(I,strel('square',10)); %# dilation
    BW = imfill(BW,'holes');             %# fill inside silhouette
    BW = imerode(BW,strel('square',10));  %# erode

    
    I1 = uint8(imfill(BW,'holes'));
end
