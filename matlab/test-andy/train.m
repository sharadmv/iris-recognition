close all;
clear all;
load('iris_data_left');
load('iris_data_right');
for i = 1:46
    if i == 4 || i == 35
        continue;
    end
    features_left{i} = compute_features(iris_data_left{i});
    features_right{i} = compute_features(iris_data_right{i});
end
save('features_left','features_left');
save('features_right','features_right');