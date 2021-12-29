function [e_theta, e_rho] = nh_ycl_z2(x5)


    
    [a_theta5,rho5] = cart2pol(x5(:,1), x5(:,2));
    
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



    d_theta = [a_theta5 - 2*pi;a_theta5;a_theta5 + 2*pi];
    d_rho = [rho5;rho5;rho5];


    [e_theta,ind] = sort(d_theta);
    e_rho = d_rho(ind);
    
    figure()
    plot(e_theta, e_rho,'b.')
    hold on
    plot(a_theta5, rho5,'r.')
    xlim([-3*pi 3*pi])
    ylim([60 120])
end