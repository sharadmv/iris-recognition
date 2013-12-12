% Calculates the hamming DISTANCE between two binary strings CODE1 and CODE2.
function [distance] = hamming_distance(code1, code2)

[~, n] = size(code1);
[~, n2] = size(code2);
if n ~= n2
    disp('Cannot compute Hamming Distance; codes of different lengths.');
    distance = -1;
    return;
end

distance = sum(xor(code1, code2));
