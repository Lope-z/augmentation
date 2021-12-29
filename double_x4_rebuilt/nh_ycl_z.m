function [e_theta, e_rho] = nh_ycl_z(x1,x5,qz)


    [b1_theta,b1_rho] = cart2pol(x1(:,1), x1(:,2));
    [b_theta,b_rho] = xzx4_z(b1_theta,b1_rho);

    
    [a1_theta5,a1_rho5] = cart2pol(x5(:,1), x5(:,2));
    [a_theta5,a_rho5] = xzEx4_z(a1_theta5,a1_rho5);
  

    
    b1 = intersect(find(a_theta5>=-pi),find(a_theta5<-pi+qz));bb1 = a_theta5(b1);cc1 = a_rho5(b1);
    b3 = intersect(find(a_theta5>(-pi/2-qz)),find(a_theta5<(-pi/2+qz)));bb3 = a_theta5(b3);cc3 = a_rho5(b3);
    b5 = intersect(find(a_theta5>-qz),find(a_theta5<qz));bb5 = a_theta5(b5);cc5 = a_rho5(b5);
    b7 = intersect(find(a_theta5>(pi/2-qz)),find(a_theta5<(pi/2+qz)));bb7 = a_theta5(b7);cc7 = a_rho5(b7);
    b9 = intersect(find(a_theta5>(pi-qz)),find(a_theta5<=pi));bb9 = a_theta5(b9);cc9 = a_rho5(b9);
    
    b2 = intersect(find(b_theta>=(-pi+qz)),find(b_theta<=(-pi/2-qz)));bb2 = b_theta(b2);cc2 = b_rho(b2);
    b4 = intersect(find(b_theta>=(-pi/2+qz)),find(b_theta<=-qz));bb4 = b_theta(b4);cc4 = b_rho(b4);   
    b6 = intersect(find(b_theta>=qz),find(b_theta<=(pi/2-qz)));bb6 = b_theta(b6);cc6 = b_rho(b6);
    b8 = intersect(find(b_theta>=(pi/2+qz)),find(b_theta<=pi-qz));bb8 = b_theta(b8);cc8 = b_rho(b8);
    
    c_theta = [bb1;bb2;bb3;bb4;bb5;bb6;bb7;bb8;bb9];
    c_rho = [cc1;cc2;cc3;cc4;cc5;cc6;cc7;cc8;cc9];
    

    
    d_theta = [c_theta - 2*pi;c_theta;c_theta + 2*pi];
    d_rho = [c_rho;c_rho;c_rho];


    [e_theta,ind] = sort(d_theta);
    e_rho = d_rho(ind);
    
    figure()
    plot(e_theta, e_rho,'b.')
    hold on
    plot(bb1,cc1,'g.');hold on;plot(bb3,cc3,'g.');hold on;plot(bb5,cc5,'g.');hold on;plot(bb7,cc7,'g.');hold on;plot(bb9,cc9,'g.');
    hold on;plot(bb2,cc2,'r.');hold on;plot(bb4,cc4,'r.');hold on;plot(bb6,cc6,'r.');hold on;plot(bb8,cc8,'r.');
    xlim([-3*pi 3*pi])
    ylim([60 120])
    
end

function [b_theta,b_rho] = xzx4_z(b_theta,b_rho)
    b1 = intersect(find(b_theta>(pi/36)),find(b_theta<(pi/2-pi/36)));
    bb1 = sum(b_theta(b1));
    if bb1 == 0
        x = 0:0.01:pi/2;
        y = zeros(size(x));
        b_theta = [b_theta;x'];
        b_rho = [b_rho;y'];
    end
    
    b2 = intersect(find(b_theta>(pi/2+pi/36)),find(b_theta<(pi-pi/36)));
    bb2 = sum(b_theta(b2));
    if bb2 == 0
        x = pi/2:0.01:pi;
        y = zeros(size(x));
        b_theta = [b_theta;x'];
        b_rho = [b_rho;y'];        
    end
    b3 = intersect(find(b_theta>(-pi+pi/36)),find(b_theta<(-pi/2-pi/36)));
    bb3 = sum(b_theta(b3));
    if bb3 == 0
        x = -pi:0.01:-pi/2;
        y = zeros(size(x));
        b_theta = [b_theta;x'];
        b_rho = [b_rho;y'];        
    end   
    b4 = intersect(find(b_theta>(-pi/2+pi/36)),find(b_theta<(-pi/36)));
    bb4 = sum(b_theta(b4));
    if bb4 == 0
        x = -pi/2:0.01:0;
        y = zeros(size(x));
        b_theta = [b_theta;x'];
        b_rho = [b_rho;y'];        
    end
end

function [a_theta5,rho5] = xzEx4_z(a_theta5,rho5)

 b1 = intersect(find(a_theta5>(-pi/4+pi/36)),find(a_theta5<(pi/4-pi/36)));
    bb1 = sum(a_theta5(b1));
    if bb1 == 0
        x = -pi/4:0.01:pi/4;
        y = zeros(size(x));
        a_theta5 = [a_theta5;x'];
        rho5 = [rho5;y'];
    end
    
    b2 = intersect(find(a_theta5>(pi/4+pi/36)),find(a_theta5<(3*pi/4-pi/36)));
    bb2 = sum(a_theta5(b2));
    if bb2 == 0
        x = pi/4:0.01:3*pi/4;
        y = zeros(size(x));
        a_theta5 = [a_theta5;x'];
        rho5 = [rho5;y'];        
    end
    b3 = intersect(find(a_theta5>(-3*pi/4+pi/36)),find(a_theta5<(-pi/4-pi/36)));
    bb3 = sum(a_theta5(b3));
    if bb3 == 0
        x = -3*pi/4:0.01:-pi/4;
        y = zeros(size(x));
        a_theta5 = [a_theta5;x'];
        rho5 = [rho5;y'];        
    end   
    b4 = intersect(find(a_theta5>(3*pi/4+pi/72)),find(a_theta5<(pi-pi/72)));
    bb4 = sum(a_theta5(b4));
    if bb4 == 0
        x = 3*pi/4:0.01:pi;
        y = zeros(size(x));
        a_theta5 = [a_theta5;x'];
        rho5 = [rho5;y'];        
    end
    b5 = intersect(find(a_theta5>(-pi+pi/72)),find(a_theta5<(-3*pi/4-pi/72)));
    bb5 = sum(a_theta5(b5));
    if bb5 == 0
        x = -pi:0.01:-3*pi/4;
        y = zeros(size(x));
        a_theta5 = [a_theta5;x'];
        rho5 = [rho5;y'];        
    end
    
end