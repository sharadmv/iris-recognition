% Generates IRISCODE and attempts to find a MATCH for IRIS
function [match, iriscode] = recoginize(iris)

[iriscode] = generate_code(iris);

iris_path = 'TODO';
load(iris_path);    % Loads iriscodes, threshhold

% Find iriscode with minimum hamming distance that is under threshhold.
[n, ~] = size(iriscodes);
match = 0;
min_dist = inf;
for i = 1:n
    cur_code = iriscodes(i, :);
    dist = hamming_distance(iriscode, cur_code);
    if dist < threshhold && dist < min_dist
        match = i;
        min_dist = dist;
    end
end

if match == 0
    sprintf('Match found.');
else
    sprintf('No match found.');
end
