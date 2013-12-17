function get_test()
%GET_TRAINING Summary of this function goes here
%   Detailed explanation goes here
close all;
clear all;
for i = 1:46
    if i == 4 || i == 35
        continue;
    end
    i
    files = dir(strcat('MMU/',int2str(i),'/left/*.bmp'));
    for j = 4:5
        iris_test_left{i+46*(j-4)} = segment_iris(strcat('MMU/',int2str(i),'/left/',files(j).name));
    end
    
    files = dir(strcat('MMU/',int2str(i),'/right/*.bmp'));
    for j = 4:5
        iris_test_right{i+46*(j-4)} = segment_iris(strcat('MMU/',int2str(i),'/right/',files(j).name));
    end
end
save('iris_test_left','iris_test_left');
save('iris_test_right','iris_test_right');
end

