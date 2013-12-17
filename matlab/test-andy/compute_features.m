function feature_value = compute_features(iris)
%COMPUTE_FEATURES Summary of this function goes here
%   Detailed explanation goes here

%% METHOD 1 - Sums of 5x5 block pixel intensities averaged
B = im2col(iris,[5,5]);
feature_value = [];
for i=1:size(B,2)
    feature_value = cat(2,feature_value,mean(B(:,i)));
end

%% METHOD 2 - Gradient Mag/Dir Histograms
% [Gmag,Gdir] = imgradient(iris);
% feature_value = zeros(1,10);
% for row=1:size(iris,1)
%     for column=1:size(iris,2)
%         index = round((Gdir(row,column)+180)/40)+1;
%         feature_value(index) = feature_value(index) + Gmag(row,column);
%     end
% end
% feature_value = feature_value./norm(feature_value);

%% METHOD 3 - Raw pixel intensities
% feature_value = imresize(iris, [1 31*250]);

end