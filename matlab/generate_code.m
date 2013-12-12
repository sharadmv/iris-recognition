% Given an IRIS in rectangular coordinates, calculates the average direction
% of the gradient for blocks, maps that to two bits, and strings the bits
% into one IRISCODE.
function [iriscode] = generate_code(iris)

[r, c] = size(iris);

w = 5;
h = 2;

n_col = c/w;
n_row = r/h;

iriscode = zeros(1, n_row*n_col*2);

[gmag, gdir] = imgradient(iris);

for i = 1:n_row
    for j = 1:n_col
        if i == n_row
            cur_patch = gdir(1+(i-1)*h:i*h+1, 1+(j-1)*w:j*w);
        else
            cur_patch = gdir(1+(i-1)*h:i*h, 1+(j-1)*w:j*w);
        end

        mean_dir = mean(mean(cur_patch));
        [b1, b2] = grad_dir(mean_dir);

        iriscode(1, (i-1)*n_col*2 + 2*j) = b1;
        iriscode(1, (i-1)*n_col*2 + 2*j + 1) = b2;
    end
end
