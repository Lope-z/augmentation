clear all
close all
clc

N=4;
root_path='C:\Users\Lope\Desktop\data\ori\';
mat_path='C:\Users\Lope\Desktop\data\mat\';


flag = 1;%0 refers to one channel，1 refers to three channels
mkdir(strcat(root_path,'x4_img'));
files=dir(strcat(root_path,'*.png'));

for k=1:numel(files)
    imgdir=strcat(files(k).folder,'\', files(k).name);
    [A,B]=fileparts(imgdir);
    savedir=strcat(A,'\x4_img\',B ,'_');     
    I=imread(imgdir);
    img=double(I(:,:,1));
    img_width=size(img,1);
    img_length=size(img,2);
    
    zxd = importdata(strcat(mat_path, B , '.mat'));
    center_length = zxd(1);
    center_width = zxd(2);
    
  
    for quadrant=1:4
        switch quadrant
            case 1
              line1 = cat( 2, savedir,num2str(1), '.png');
              MN = [img_length - center_length;img_width - center_width];
              if MN(1)>MN(2)
                  I0 = uint8(zeros(MN(1)+1,MN(1)+1));
                  I0(1:MN(2)+1,:) = I(center_width:img_width,center_length:img_length);
              else
                  I0 = uint8(zeros(MN(2)+1,MN(2)+1));
                  I0(:,1:MN(1)+1) = I(center_width:img_width,center_length:img_length);
              end
              tform=maketform('affine',[-1 0 0;0 1 0;0 0 1]);
              I1=imtransform(I0,tform,'nearest');
              tform2=maketform('affine',[1 0 0;0 -1 0;0 0 1]);
              I2=imtransform(I0,tform2,'nearest');
              tform3=maketform('affine',[-1 0 0;0 -1 0;0 0 1]);
              I3=imtransform(I0,tform3,'nearest');
              I4 = [I3,I2;I1,I0];
              if flag==0
                  I5 = z_qu_r_c(I4); 
              else
                  I5 = z_channel(z_qu_r_c(I4));  
              end
              imwrite(I5,line1);
            case 2
              line1 = cat( 2, savedir,num2str(2), '.png');
              MN = [center_length-1;img_width - center_width];
              if MN(1)>MN(2)
                  I0 = uint8(zeros(MN(1),MN(1)));
                  I0(1:MN(2)+1,:) = I(center_width:img_width,1:center_length-1);
              else
                  I0 = uint8(zeros(MN(2)+1,MN(2)+1));
                  I0(:,MN(2)-MN(1)+2:MN(2)+1) = I(center_width:img_width,1:center_length-1);
              end             
              tform=maketform('affine',[-1 0 0;0 1 0;0 0 1]);
              I1=imtransform(I0,tform,'nearest');
              tform2=maketform('affine',[1 0 0;0 -1 0;0 0 1]);
              I2=imtransform(I1,tform2,'nearest');
              tform3=maketform('affine',[-1 0 0;0 -1 0;0 0 1]);
              I3=imtransform(I1,tform3,'nearest');
              I4 = [I3,I2;I0,I1];
              if flag==0
                  I5 = z_qu_r_c(I4); 
              else
                  I5 = z_channel(z_qu_r_c(I4));    
              end
              imwrite(I5,line1);
            case 3
              line1 = cat( 2, savedir,num2str(3), '.png');
              MN = [center_length-1;center_width-1];
              if MN(1)>MN(2)
                  I0 = uint8(zeros(MN(1),MN(1)));
                  I0(MN(1)-MN(2)+1:MN(1),:) = I(1:center_width-1,1:center_length-1);
              else
                  I0 = uint8(zeros(MN(2),MN(2)));
                  I0(:,MN(2)-MN(1)+1:MN(2)) = I(1:center_width-1,1:center_length-1);
              end 
              tform=maketform('affine',[-1 0 0;0 1 0;0 0 1]);
              I1=imtransform(I0,tform,'nearest');
              tform2=maketform('affine',[1 0 0;0 -1 0;0 0 1]);
              I2=imtransform(I0,tform2,'nearest');
              tform3=maketform('affine',[-1 0 0;0 -1 0;0 0 1]);
              I3=imtransform(I0,tform3,'nearest');
              I4 = [I0,I1;I2,I3];
              if flag==0
                  I5 = z_qu_r_c(I4); 
              else
                  I5 = z_channel(z_qu_r_c(I4));    
              end
              imwrite(I5,line1);
            case 4
              line1 = cat( 2, savedir,num2str(4), '.png');
              MN = [img_length-center_length;center_width-1];
              if MN(1)>MN(2)
                  I0 = uint8(zeros(MN(1)+1,MN(1)+1));
                  I0(MN(1)-MN(2)+2:MN(1)+1,:) = I(1:center_width-1,center_length:img_length);
              else
                  I0 = uint8(zeros(MN(2),MN(2)));
                  I0(:,1:MN(1)+1) = I(1:center_width-1,center_length:img_length);
              end 
              tform=maketform('affine',[-1 0 0;0 1 0;0 0 1]);
              I1=imtransform(I0,tform,'nearest');
              tform2=maketform('affine',[1 0 0;0 -1 0;0 0 1]);
              I2=imtransform(I0,tform2,'nearest');
              tform3=maketform('affine',[-1 0 0;0 -1 0;0 0 1]);
              I3=imtransform(I0,tform3,'nearest');
              I4 = [I1,I0;I3,I2];
              if flag==0
                  I5 = z_qu_r_c(I4); 
              else
                  I5 = z_channel(z_qu_r_c(I4));    
              end
              imwrite(I5,line1);
        end
    end
end
