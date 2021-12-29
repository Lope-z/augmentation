function [XX1,YY1] = z_nh(x,y,bc,jg)

    x1 = x;
    y1 = y;
    
    x2 = [];
    y2 = [];

    k = 1;
    for i = 2:length(x1)
        if ((x(i)-x1(k)) > bc)
            k = k+1;
            x2(k) = x(i);
            y2(k) = y(i);
        end
    end
    
    [z, ~] = createFit(x, y);

  
    d1x = min(x):jg:max(x);d1y = z(d1x);
    XX1 = d1x;YY1 = d1y';
    
    hold on
    h = plot(z);set(h,'Color','k','LineWidth',1.5)


end


function [fitresult, gof] = createFit(x, y)

[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
ft = fittype( 'smoothingspline' );
opts = fitoptions( 'Method', 'SmoothingSpline' );
opts.SmoothingParam = 0.999922309698004;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );
end

