function [x3,y3] = nh_hcl_z(x,y,center_point)

    ind = find((-pi<=x) & (x<pi));
    x1 = x(ind);
    y1 = y(ind);

    [x2,y2] = pol2cart(x1,y1);

    x3 = x2 + center_point(1);
    y3 = y2 + center_point(2);
    
end