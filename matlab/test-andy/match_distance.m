function distance = match_distance(features_iris1, features_iris2)
%MATCH_DISTANCE Summary of this function goes here
%   Detailed explanation goes here

%% Set all noisy areas (eyelashes/skin) to 0
% iris1(iris2==0) = 0;
% iris2(iris1==0) = 0;

%% Compute distance between feature vectors (sum differences)
distance = sum(abs(features_iris1 - features_iris2));

end