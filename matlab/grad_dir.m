function [b1, b2] = grad_dir(dir)

if dir >= 0 && dir < 90
    b1 = 1;
    b2 = 1;
elseif dir >= 90 && dir < 180
    b1 = 0;
    b2 = 1;
elseif dir < 0 && dir >= -90 
    b1 = 1;
    b2 = 0;
elseif dir < -90 && dir >= -180
    b1 = 0;
    b2 = 0;
else
    disp(dir);
    b1 = 1;
    b2 = 1;
end
