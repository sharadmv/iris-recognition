%% RUN THIS SCRIPT TO TRAIN IRIS
% Computes mean over a specific number of training images

%% Left Eye
close all;
clear all;
num_training = 3;
for i = 1:46
    if i == 4 || i == 35
        iris_data_left{i} = [];
        continue;
    end
    files = dir(strcat('MMU/',int2str(i),'/left/*.bmp'));
    for j = 1:num_training
        strcat('MMU/',int2str(i),'/left/',files(j).name)
        iris{j} = segment_iris(strcat('MMU/',int2str(i),'/left/',files(j).name));
    end
    zero_counts = ones(31,250).*3;
    for j = 1:num_training
        tmp_iris = iris{j};
        zero_counts(tmp_iris == 0) = zero_counts(tmp_iris == 0)-1;
    end
    sum_iris = zeros(31,250);
    for j=1:num_training
        sum_iris = iris{j} + sum_iris;
    end
    sum_iris = sum_iris./zero_counts;
    sum_iris(isnan(sum_iris)) = 0;
    iris_data_left{i} = sum_iris;
end
save('iris_data_left','iris_data_left');



%% Right Eye
close all;
clear all;
num_training = 3;
for i = 1:46
    if i == 4 || i == 35
        iris_data_right{i} = [];
        continue;
    end
    files = dir(strcat('MMU/',int2str(i),'/right/*.bmp'));
    for j = 1:num_training
        strcat('MMU/',int2str(i),'/right/',files(j).name)
        iris{j} = segment_iris(strcat('MMU/',int2str(i),'/right/',files(j).name));
    end
    zero_counts = ones(31,250).*3;
    for j = 1:num_training
        tmp_iris = iris{j};
        zero_counts(tmp_iris == 0) = zero_counts(tmp_iris == 0)-1;
    end
    sum_iris = zeros(31,250);
    for j=1:num_training
        sum_iris = iris{j} + sum_iris;
    end
    sum_iris = sum_iris./zero_counts;
    sum_iris(isnan(sum_iris)) = 0;
    iris_data_right{i} = sum_iris;
end
save('iris_data_right','iris_data_right');