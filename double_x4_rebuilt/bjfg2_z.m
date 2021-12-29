function dh_zb1 = bjfg2_z(i2_1,i2_2,i2_3,i2_4,Cee1)


i1 = ff_z(i2_1,1);
i2 = ff_z(i2_2,2);
i3 = ff_z(i2_3,3);
i4 = ff_z(i2_4,4);


d_FI1 = i1 + i2 + i3 + i4;


d_zb1 = tqby_z(d_FI1);dh_zb1 = [d_zb1{1};d_zb1{2};d_zb1{3};d_zb1{4}]-[Cee1(1) Cee1(2)];


end



function zb = ff_z(II,c_class)

    II1 = II;
    U1 = diag(diag(II1));
    P1 = triu(II1); 
    Q1 = II1 - P1 + U1 ;
    

    II2 = flip(P1,2);
    U2 = diag(diag(II2));
    P2 = flip(triu(II2),2); 
    Q2 = flip(II2 - triu(II2) + U2 ,2);
    

    II3 = flip(Q1,2);
    U3 = diag(diag(II3));
    P3 = flip(triu(II3),2); %3    
    Q3 = flip(II3 - triu(II3) + U3,2);%2
   
    if c_class == 1 
        WW4 = Q2;
        WW5 = Q3';
        WW6 = flip(P2,2);WW6 = flip(WW6',2);
        WW7 = flip(flip(P3,2));
    elseif c_class == 2
        WW4 = Q3;
        WW5 = Q2';
        WW6 = flip(P3,2);WW6 = flip(WW6',2);
        WW7 = flip(flip(P2,2));
    elseif c_class == 3
        WW4 = P3;
        WW5 = P2';
        WW6 = flip(Q3,2);WW6 = flip(WW6',2);
        WW7 = flip(flip(Q2,2));
    elseif c_class == 4
        WW4 = P2;
        WW5 = P3';
        WW6 = flip(Q2,2);WW6 = flip(WW6',2);
        WW7 = flip(flip(Q3,2));
    end   
    
    zb(:,:,1) = WW4;zb(:,:,2) = WW5;zb(:,:,3) = WW6;zb(:,:,4) = WW7;
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


