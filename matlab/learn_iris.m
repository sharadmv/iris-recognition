% Finds the hamming distance THRESHHOLD which minimizes iris recognition error
% on samples in IRIS_PATH.
%function [threshhold, false_positives, false_negatives, distances] = ...
%        learn_iris(iris_path)

%cd(iris_path);
cd('/home/r/Documents/berkeley/cs280/iris-recognition/processed/MMU');

% For each eye, use first four images for training, and last image for test.


% For each eye in training set
%   Calculate hamming distance to self and all other eyes
n_subjects = 46;
n_images = 4;
n = n_subjects * n_images;

distances = zeros(n, n);
for i = 1:n
    subject_i = floor((i-1)/n_images) + 1;
    if mod(i,n_images) == 0
        image_i = n_images;
    else
        image_i = mod(i, n_images);
    end

    if subject_i == 4 || subject_i == 35
        continue;
    end

    i_iris = imread(sprintf('%d/left/%d.bmp',subject_i,image_i));
    i_code = generate_code(i_iris);

    for j = i:n
        subject_j = floor((j-1)/n_images) + 1;
        if mod(j,n_images) == 0
            image_j = n_images;
        else
            image_j = mod(j, n_images);
        end

        fprintf('Computing distances for %d.%d and %d.%d\n', ...
                subject_i, image_i, subject_j, image_j);
        if subject_j == 4 || subject_j == 35
            continue;
        end

        j_iris = imread(sprintf('%d/left/%d.bmp',subject_j,image_j));
        j_code = generate_code(j_iris);

        dist = hamming_distance(i_code, j_code);
        distances((subject_i-1)*n_images+image_i, ...
                  (subject_j-1)*n_images+image_j) = dist;
    end
end
save('distances.mat', 'distances');


% For theta = min_valid_dist : max_valid_dist
%   Calculate cost = match(i,i) + match(i,j), with
%       match(i,j) = { d_{ij} <= theta, 1
%                     else,            -1
% Pick theta with minimum cost
threshhold = 0;
min_cost = inf;
for theta = foo:bar % TODO
    cost = -1;

    for i = 1:n
        if i == 4 || i == 35
            continue;
        end

        for j = i:n
            cost = cost + theta_cost(distances(i,j), theta);
        end
    if cost < min_cost
        threshhold = theta;
        min_cost = cost;
end


% Test on train set and report error
false_positives = 0;
false_negatives = 0;

for subject_i = 1:n_subjects
    i_iris = imread(sprintf('%d/left/5.bmp',subject_i));
    i_code = generate_code(i_iris);

    for subject_j = 1:n_subjects
        for image_j = 1:n_images
            j_iris = imread(sprintf('%d/left/%d.bmp',subject_j,image_j));
            j_code = generate_code(j_iris);

            dist = hamming_distance(i_code, j_code);

            if dist < threshhold && subject_i ~= subject_j
                false_positives = false_positives + 1;
            elseif dist > threshhold && subject_i == subject_j
                false_negatives = false_negatives + 1;
            end
        end
    end
end
