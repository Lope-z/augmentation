function I1 = z_qu_r_c(I1)
%去掉矩阵中的r行c列 

[m,n] = size(I1);
r = m / 2+ 1;
c = n / 2+ 1;

I1(r,:) = [];
I1(:,c) = [];