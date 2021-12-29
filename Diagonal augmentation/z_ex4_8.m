clear all
close all
clc

root_path='C:\Users\Lope\Desktop\data\ori\';
mat_path='C:\Users\Lope\Desktop\data\mat\';

flag = 1;%0 refers to one channel，1 refers to three channels
mkdir(strcat(root_path,'E_x4_img'));
files=dir(strcat(root_path,'*.png'));

for k=1:numel(files)
    imgdir=strcat(files(k).folder,'\', files(k).name);
    [A,B]=fileparts(imgdir);
    savedir=strcat(A,'\E_x4_img\',B ,'_');     
    I=imread(imgdir);
    img=uint8(I);
    img_width=size(img,1);
    img_length=size(img,2);
    
    zxd = importdata(strcat(mat_path, B , '.mat'));
    center_length = zxd(1);
    center_width = zxd(2);
    another_length = img_length - center_length;
    another_width = img_width - center_width;
    
    max_S = max([center_length,another_length + 1,center_width,another_width + 1]);
    
    image_max = uint8(zeros([2*max_S-1, 2*max_S-1]));
    image_max(max_S-center_width+1:max_S+another_width,...
              max_S-center_length+1:max_S+another_length) = img;       

    center_value = image_max(max_S,max_S);
    image_max1 = image_max;
    image_max1(max_S,max_S) = 0;
    
    II1 = image_max1;
    U1 = diag(diag(II1));
    P1 = triu(II1); 
    Q1 = II1 - P1;
    P1 = P1 - U1;
    UU1 = flip(U1,2);
    UU2 = triu(UU1);
    UU3 = UU1-UU2;
    U1 = flip(UU2,2);
    U4 = flip(UU3,2);
    
    II2 = flip(P1,2);
    U2 = diag(diag(II2));
    P2 = flip(triu(II2)-U2,2); 
    Q2 = flip(II2 - triu(II2),2);
    U2 = flip(U2,2);
    
    II3 = flip(Q1,2);
    U3 = diag(diag(II3));
    P3 = flip(triu(II3)-U3,2); 
    Q3 = flip(II3 - triu(II3),2);
    U3 = flip(U3,2);
      
    WW4 = Q2;
    WW5 = Q2';
    WW7 = flip(flip(Q2,2));
    WW6 = WW7';
       
    I5 = WW4 + WW5 + WW6 + WW7 + center_value + U4 + U2 + flip(flip(U4,2)) + flip(flip(U2,2));
    
    if flag == 1
        I6 = z_channel(I5);
    end
    line1 = cat( 2, savedir,num2str(1), '.png');
    imwrite(I6,line1);
        
    WW4 = Q3';
    WW5 = Q3;
    WW6 = flip(flip(Q3),2);
    WW7 = WW6';
    
    I5 = WW4 + WW5 + WW6 + WW7 + center_value + U4 + U3 + flip(flip(U4,2)) + flip(flip(U3,2));
       
    if flag == 1
        I6 = z_channel(I5);
    end
    line1 = cat( 2, savedir,num2str(2), '.png');
    imwrite(I6,line1);
    
    
    WW6 = P3';
    WW7 = P3;
    WW4 = flip(flip(P3),2);
    WW5 = WW4';

    I5 = WW4 + WW5 + WW6 + WW7 + center_value + U1 + U3 + flip(flip(U1,2)) + flip(flip(U3,2));
       
    if flag == 1
        I6 = z_channel(I5);
    end
    line1 = cat( 2, savedir,num2str(3), '.png');
    imwrite(I6,line1);
    
    WW6 = P2;
    WW7 = P2';
    WW5 = flip(flip(P2),2);
    WW4 = WW5';
    
    I5 = WW4 + WW5 + WW6 + WW7 + center_value + U1 + U2 + flip(flip(U1,2)) + flip(flip(U2,2));
       
    if flag == 1
        I6 = z_channel(I5);
    end
    line1 = cat( 2, savedir,num2str(4), '.png');
    imwrite(I6,line1);
    
end
