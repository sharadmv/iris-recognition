close all;
clear all;
num_correct = 0;
total_samples = 0;
load('iris_test_left');
load('iris_test_right');
for i = 1:46
    if i == 4 || i == 35
        continue;
    end
    files = dir(strcat('MMU/',int2str(i),'/left/*.bmp'));
    for j = 4:5
        total_samples = total_samples + 1;
        [is_left id] = match_iris(iris_test_left{i+46*(j-4)});
        if is_left == 1
            fprintf('This is the left iris of subject %d.\n', id);
        else
            fprintf('This is the right iris of subject %d.\n', id);
        end
        if is_left == 1 && id == i
            num_correct = num_correct + 1;
        end
    end
    files = dir(strcat('MMU/',int2str(i),'/right/*.bmp'));
    for j = 4:5
        total_samples = total_samples + 1;
        [is_left id] = match_iris(iris_test_right{i+46*(j-4)});
        if is_left == 1
            fprintf('This is the left iris of subject %d.\n', id);
        else
            fprintf('This is the right iris of subject %d.\n', id);
        end
        if is_left == 0 && id == i
            num_correct = num_correct + 1;
        end
    end
end
fprintf('Accuracy: %f\n',(num_correct/total_samples));