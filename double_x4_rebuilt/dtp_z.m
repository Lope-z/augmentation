function [i2_1,i2_2,i2_3,i2_4,i3_1,i3_2,i3_3,i3_4,uu1,Cee,Ce,Cee1,Cee2, C] = dtp_z(root_path1,root_path2,p)
%% input
% root_path：
% p：
%% output
% i2_1,i2_2,i2_3,i2_4：
% i3_1,i3_2,i3_3,i3_4：
% uu1：
% Cee：
% Ce：
% Cee1：
% Cee2：
% C：

%%
imgdir = strcat(p.folder,'\', p.name);
[~,B] = fileparts(imgdir);
C = B(1:length(B)-2);

mz1 = strcat(root_path1,'ori_result1\', C, '_1.png');
i2_1 = z_zdltqy(imfill(imbinarize(imread(mz1)),'holes'));mn1(1,:) = [size(i2_1,2),size(i2_1,1)];
mz2 = strcat(root_path1,'ori_result1\', C, '_2.png');
i2_2 = z_zdltqy(imfill(imbinarize(imread(mz2)),'holes'));mn1(2,:) = [size(i2_2,2),size(i2_2,1)];
mz3 = strcat(root_path1,'ori_result1\', C, '_3.png');
i2_3 = z_zdltqy(imfill(imbinarize(imread(mz3)),'holes'));mn1(3,:) = [size(i2_3,2),size(i2_3,1)];
mz4 = strcat(root_path1,'ori_result1\', C, '_4.png');
i2_4 = z_zdltqy(imfill(imbinarize(imread(mz4)),'holes'));mn1(4,:) = [size(i2_4,2),size(i2_4,1)];


mz1 = strcat(root_path2,'ori_result2\', C, '_1.png');
i3_1 = imread(mz1);
mz2 = strcat(root_path2,'ori_result2\', C, '_2.png');
i3_2 = imread(mz2);
mz3 = strcat(root_path2,'ori_result2\', C, '_3.png');
i3_3 = imread(mz3);
mz4 = strcat(root_path2,'ori_result2\', C, '_4.png');
i3_4 = imread(mz4);
mn2(1,:) = [size(i3_1,2),size(i3_1,1)];


uu1 = imread(strcat(root_path1,'ori_task\', C, '.png'));
Cee = importdata(strcat(root_path1,'zxd_mat\',C,'.mat')); 
Ce = imread(strcat(root_path1,'ori_mask\', C, '.png'));


Cee1(1,1) = (mn1(1,1)+1)/2; Cee1(1,2) = (mn1(1,2)+1)/2; 
Cee1(2,1) = (mn1(2,1)+1)/2; Cee1(2,2) = (mn1(2,2)+1)/2; 
Cee1(3,1) = (mn1(3,1)+1)/2; Cee1(3,2) = (mn1(3,2)+1)/2; 
Cee1(4,1) = (mn1(4,1)+1)/2; Cee1(4,2) = (mn1(4,2)+1)/2;

Cee2(1,1) = (mn2(1,1)+1)/2; Cee2(1,2) = (mn2(1,2)+1)/2; 



i2_1 = z_hyzjx(i2_1,Cee1(1,:));
i2_2 = z_hyzjx(i2_2,Cee1(2,:));
i2_3 = z_hyzjx(i2_3,Cee1(3,:));
i2_4 = z_hyzjx(i2_4,Cee1(4,:));
end


function I7 = z_zdltqy(I5)

I6 = bwlabel(I5);                
stats = regionprops(I6,'Area');    
area = cat(1,stats.Area);
index = find(area == max(area));       
I7 = ismember(I6,index);          
end

function I7 = z_hyzjx(I5,u)

I6 = [I5(:,1:u(1)-1),I5(:,u(1)),I5(:,u(1):size(I5,2))];
I7 = [I6(1:u(2)-1,:);I6(u(2),:);I6(u(2):size(I5,1),:)];
end