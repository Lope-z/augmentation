function [i3_1,i3_2,i3_3,i3_4,uu1,Cee,Ce,Cee2, C] = dtp2_z(root_path,p)
%% input
% root_path
% p
%% output

% i3_1,i3_2,i3_3,i3_4：
% uu1：
% Cee
% Ce：
% Cee2：
% C：

%%
imgdir = strcat(p.folder,'\', p.name);
[~,B] = fileparts(imgdir);
C = B(1:length(B)-2);


mz1 = strcat(root_path,'ori_result2\', C, '_1.png');
i3_1 = imread(mz1);
mz2 = strcat(root_path,'ori_result2\', C, '_2.png');
i3_2 = imread(mz2);
mz3 = strcat(root_path,'ori_result2\', C, '_3.png');
i3_3 = imread(mz3);
mz4 = strcat(root_path,'ori_result2\', C, '_4.png');
i3_4 = imread(mz4);
mn2(1,:) = [size(i3_1,2),size(i3_1,1)];

uu1 = imread(strcat(root_path,'ori_task\', C, '.png'));
Cee = importdata(strcat(root_path,'zxd_mat\',C,'.mat')); 
Ce = imread(strcat(root_path,'ori_mask\', C, '.png'));


Cee2(1,1) = (mn2(1,1)+1)/2; Cee2(1,2) = (mn2(1,2)+1)/2; 


end
