function d = z_channel(a)
[m,n]=size(a);%图像长和宽，以及维度信息
c=zeros(m,n);%创建一个零矩阵，用于赋值
c(:,:,1)=a(:,:);%把矩阵a的行和列赋值给矩阵c的第一维
c(:,:,2)=a(:,:);%把矩阵a的行和列赋值给矩阵c的第2维
c(:,:,3)=a(:,:);%把矩阵a的行和列赋值给矩阵c的第3维
d = uint8(c);
