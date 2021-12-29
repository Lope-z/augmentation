clear all
close all
clc


%%  Input parameters
 

class_z = 2; %0 means two merging, 1 means vertical and horizontal, 2 means diagonal

qz = 20 * pi /180;

jg = 0.001;
bc = 0.002;

if class_z ==0
    root_path='.\DATA2\';
    files=dir(strcat(root_path1,'ori_result\*.png')); 
    save_path = strcat(root_path1,'predict_result_all\');
elseif class_z ==1
    root_path='.\DATA2\';
    files=dir(strcat(root_path,'ori_result\*.png'));
    save_path = strcat(root_path,'predict_result\');
elseif class_z ==2
    root_path='.\DATA2\';   
    files=dir(strcat(root_path,'ori_result\*.png'));
    save_path = strcat(root_path,'predict_result\');
end

%%
for p = 0:length(files)/4-1
    
    if class_z == 0
        [x4_mask_1,x4_mask_2,x4_mask_3,x4_mask_4,...
            x4_mask1_1,x4_mask1_2,x4_mask1_3,x4_mask1_4,...
            ori_img,center_point,ground_truth,...
            four_center_point,four_center_point1,pic_name] = dtp_z(root_path1,root_path2, files(4*p + 1));
        
        disp(pic_name);
        fprintf("-------------\n");
        
        x4_zb1_1 = bjfg1_z(x4_mask_1,x4_mask_2,x4_mask_3,x4_mask_4,four_center_point,center_point,size(ground_truth));
        x4_zb2_1 = bjfg2_z(x4_mask1_1,x4_mask1_2,x4_mask1_3,x4_mask1_4,four_center_point1);
       
        [jzb_theta, jzb_rho] = nh_ycl_z(x4_zb1_1,x4_zb2_1,qz);
        
    elseif class_z ==1
        
        [x4_mask_1,x4_mask_2,x4_mask_3,x4_mask_4,...
            ori_img,center_point,ground_truth,...
            four_center_point,pic_name] = dtp1_z(root_path, files(4*p + 1));
        
        disp(pic_name);
        fprintf("-------------\n");
        
        x4_zb1_1 = bjfg1_z(x4_mask_1,x4_mask_2,x4_mask_3,x4_mask_4,four_center_point,center_point,size(ground_truth));
        
        [jzb_theta, jzb_rho] = nh_ycl_z1(x4_zb1_1);
        
    elseif class_z ==2
        
        [x4_mask1_1,x4_mask1_2,x4_mask1_3,x4_mask1_4,...
            ori_img,center_point,ground_truth,...
            four_center_point1,pic_name] = dtp2_z(root_path, files(4*p + 1));
        
        disp(pic_name);
        fprintf("-------------\n");
        
        x4_zb2_1 = bjfg2_z(x4_mask1_1,x4_mask1_2,x4_mask1_3,x4_mask1_4,four_center_point1);
        
        
        [jzb_theta, jzb_rho] = nh_ycl_z2(x4_zb2_1);
    end
    
    [jzb_theta1, jzb_rho1] = z_nh(jzb_theta, jzb_rho,bc, jg);

    [pmask_zb_x,pmask_zb_y] = nh_hcl_z(jzb_theta1, jzb_rho1,center_point);

    figure();
    imshow(ori_img);
    hold on
    plot(pmask_zb_x,pmask_zb_y,'r.')
    
    
    predict_mask = z_zb2bw(pmask_zb_x,pmask_zb_y,size(ori_img));

    gt_1 = find(ground_truth>0);
    pm_1 = find(predict_mask>0);
    
    show_img = uint8([]);
    show_img_1 = ori_img(:,:,1);show_img_1(gt_1) = 255; show_img(:,:,1) = show_img_1;
    show_img_2 = ori_img(:,:,1);show_img(:,:,2) = show_img_2;
    show_img_3 = ori_img(:,:,1);show_img_3(pm_1) = 255;show_img(:,:,3) = show_img_3;
    
    figure();imshow(predict_mask);
   figure();
    subplot(221);imshow(ori_img);subplot(222);imshow(predict_mask);
    subplot(223);imshow(ground_truth*255);subplot(224);imshow(show_img);
    
    str = strcat(save_path,pic_name,'.png');
    imwrite(predict_mask,str)

end


