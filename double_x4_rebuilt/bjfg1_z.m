function dh_zb1 = bjfg1_z(i2_1,i2_2,i2_3,i2_4,Cee1,Cee,MN)


i1 = flip(flip(i2_1(1:Cee1(1,2), 1:Cee1(1,1))),2);d_FI1(:,:,1) = i1(1:MN(1)-Cee(2)+1,1:MN(2)-Cee(1)+1);
i2 = flip(i2_1(1:Cee1(1,2), Cee1(1,1)+1:size(i2_1,2)));d_FI1(:,:,2)= i2(1:MN(1)-Cee(2)+1,1:MN(2)-Cee(1)+1);
i3 = flip(i2_1(Cee1(1,2)+1:size(i2_1,1), 1:Cee1(1,1)),2);d_FI1(:,:,3) = i3(1:MN(1)-Cee(2)+1,1:MN(2)-Cee(1)+1);
i4 = i2_1(Cee1(1,2)+1:size(i2_1,1), Cee1(1,1)+1:size(i2_1,2));d_FI1(:,:,4)= i4(1:MN(1)-Cee(2)+1,1:MN(2)-Cee(1)+1);



i1 = flip(i2_2(1:Cee1(2,2), 1:Cee1(2,1)));d_FI2(:,:,1) = i1(1:MN(1)-Cee(2)+1,size(i1,2)-(Cee(1)-1)+1:size(i1,2));
i2 = flip(flip(i2_2(1:Cee1(2,2), Cee1(2,1)+1:size(i2_2,2))),2);d_FI2(:,:,2) = i2(1:MN(1)-Cee(2)+1,size(i2,2)-(Cee(1)-1)+1:size(i2,2));
i3 = i2_2(Cee1(2,2)+1:size(i2_2,1), 1:Cee1(2,1));d_FI2(:,:,3) = i3(1:MN(1)-Cee(2)+1,size(i3,2)-(Cee(1)-1)+1:size(i3,2));
i4 = flip(i2_2(Cee1(2,2)+1:size(i2_2,1), Cee1(2,1)+1:size(i2_2,2)),2);d_FI2(:,:,4) = i4(1:MN(1)-Cee(2)+1,size(i4,2)-(Cee(1)-1)+1:size(i4,2));


i1 = i2_3(1:Cee1(3,2), 1:Cee1(3,1));d_FI3(:,:,1) = i1(size(i1,1) - (Cee(2)-1) + 1 : size(i1,1),size(i1,2)-(Cee(1)-1)+1:size(i1,2));
i2 = flip(i2_3(1:Cee1(3,2), Cee1(3,1)+1:size(i2_3,2)),2);d_FI3(:,:,2) = i2(size(i2,1) - (Cee(2)-1) + 1 : size(i2,1),size(i2,2)-(Cee(1)-1)+1:size(i2,2));
i3 = flip(i2_3(Cee1(3,2)+1:size(i2_3,1), 1:Cee1(3,1)));d_FI3(:,:,3) = i3(size(i3,1) - (Cee(2)-1) + 1 : size(i3,1),size(i3,2)-(Cee(1)-1)+1:size(i3,2));
i4 = flip(flip(i2_3(Cee1(3,2)+1:size(i2_3,1), Cee1(3,1)+1:size(i2_3,2))),2);d_FI3(:,:,4) = i4(size(i4,1) - (Cee(2)-1) + 1 : size(i4,1),size(i4,2)-(Cee(1)-1)+1:size(i4,2));


i1 = flip(i2_4(1:Cee1(4,2), 1:Cee1(4,1)),2);d_FI4(:,:,1) = i1(size(i1,1) - (Cee(2)-1) + 1 : size(i1,1),1:MN(2)-Cee(1)+1);
i2 = i2_4(1:Cee1(4,2), Cee1(4,1)+1:size(i2_4,2));d_FI4(:,:,2) = i2(size(i2,1) - (Cee(2)-1) + 1 : size(i2,1),1:MN(2)-Cee(1)+1);
i3 = flip(flip(i2_4(Cee1(4,2)+1:size(i2_4,1), 1:Cee1(4,1))),2);d_FI4(:,:,3) = i3(size(i3,1) - (Cee(2)-1) + 1 : size(i3,1),1:MN(2)-Cee(1)+1);
i4 = flip(i2_4(Cee1(4,2)+1:size(i2_4,1), Cee1(4,1)+1:size(i2_4,2)));d_FI4(:,:,4) = i4(size(i4,1) - (Cee(2)-1) + 1 : size(i4,1),1:MN(2)-Cee(1)+1);



d_ZF = [d_FI3,d_FI4;d_FI2,d_FI1];
d_zb1 = tqby_z(d_ZF);
dh_zb1 = [d_zb1{1};d_zb1{2};d_zb1{3};d_zb1{4}]-[Cee(1) Cee(2)];

end


function zb = tqby_z(d_FI)



    i3_1 = edge(d_FI(:,:,1),'sobel');
    i3_2 = edge(d_FI(:,:,2),'sobel');
    i3_3 = edge(d_FI(:,:,3),'sobel');
    i3_4 = edge(d_FI(:,:,4),'sobel');

    

    [b1,~] = bwboundaries(i3_1,'noholes');bd_1 = b1{1};bd_1(:,[1,2]) = fliplr(bd_1(:,[1,2]));
    [b2,~] = bwboundaries(i3_2,'noholes');bd_2 = b2{1};bd_2(:,[1,2]) = fliplr(bd_2(:,[1,2]));
    [b3,~] = bwboundaries(i3_3,'noholes');bd_3 = b3{1};bd_3(:,[1,2]) = fliplr(bd_3(:,[1,2]));
    [b4,~] = bwboundaries(i3_4,'noholes');bd_4 = b4{1};bd_4(:,[1,2]) = fliplr(bd_4(:,[1,2]));

   
    zb{1} = bd_1;zb{2} = bd_2;zb{3} = bd_3;zb{4} = bd_4;


end
