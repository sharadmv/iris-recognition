function [is_left_eye,curr_id] = match_iris(iris)
%MATCH_IRIS Summary of this function goes here
%   Detailed explanation goes here
test_iris = compute_features(iris);
load('features_left');
load('features_right');
is_left_eye = 0;
curr_id = -1;
curr_comparison_value = inf;
for i=1:46
    if i == 4 || i == 35
        continue;
    end
    comparison_value = match_distance(test_iris, features_left{i});
    if comparison_value < curr_comparison_value
        curr_comparison_value = comparison_value;
        curr_id = i;
        is_left_eye = 1;
    end
    comparison_value = match_distance(test_iris, features_right{i});
    if comparison_value < curr_comparison_value
        curr_comparison_value = comparison_value;
        curr_id = i;
        is_left_eye = 0;
    end
end
if curr_id == -1
    fprintf('Iris rejected.')
end
end