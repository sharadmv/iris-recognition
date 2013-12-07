function draw_ellipse(x,y,a,b,c)
%DRAW_CIRCLE Draws a circle
%   x,y - center of circle
%   a - width of circle
%   b - height of circle
%   c - color of circle
th = 0:pi/50:2*pi;
xunit = a * cos(th) + x;
yunit = b * sin(th) + y;
hold on;
plot(xunit, yunit, c);
hold off;
end
