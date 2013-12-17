function iris = segment_iris(filename)
%SEGMENT_IRIS Summary of this function goes here
%   Detailed explanation goes here
close all
% iris1 = localize_iris('MMU/2/right/bryanr1.bmp');
% iris2 = localize_iris('MMU/2/right/bryanr2.bmp');
% iris3 = localize_iris('MMU/2/right/bryanr3.bmp');
% iris4 = localize_iris('MMU/2/right/bryanr4.bmp');
% iris5 = localize_iris('MMU/2/right/bryanr5.bmp');
% value = pdist2(iris1,iris2,'manhalanobis')

iris = localize_iris(filename);
figure,imshow(iris);
iris_line = iris(15,:);
iris_shade = median(iris_line);
filtered_rectangle = xor(im2bw(iris, iris_shade-0.2*iris_shade),im2bw(iris, iris_shade+0.2*(1-iris_shade)));
filtered_rectangle = ~bwareaopen(~filtered_rectangle, 100);
% figure,imshow(filtered_rectangle);
iris = min(iris, filtered_rectangle);
% figure,imshow(iris);

%% MMU
% close all;
% cd MMU
% for i = 35:46
%     i
%     cd(int2str(i));
%     cd left
%     files = dir('*.bmp');
%     for j=1:size(files,1)
%         cd ../../..
%         iris = localize_iris(strcat('MMU/',int2str(i),'/left/',files(j).name));
%         cd MMU
%         cd(int2str(i));
%         cd left
%         imwrite(iris,strcat(int2str(j),'.bmp'));
%     end
%     cd ../right
%     files = dir('*.bmp');
%     for j=1:size(files,1)
%         cd ../../..
%         iris = localize_iris(strcat('MMU/',int2str(i),'/right/',files(j).name));
%         cd MMU
%         cd(int2str(i));
%         cd right
%         imwrite(iris,strcat(int2str(j),'.bmp'));
%     end
%     cd ../../
% end
%     cd ..

%% MMU2
% close all
% cd MMU2
% for i=6:100
%     for j=1:2
%         for k=1:5
%             sprintf('MMU2/%0.2d%0.2d%0.2d.bmp',i,j,k)
%             if (str2num(sprintf('%0.2d%0.2d%0.2d',i,j,k)) > 990205)
%                 cd ..
%                 iris = localize_iris(sprintf('MMU2/%0.2d%0.2d%0.2d.bmp',i,j,k));
%                 cd MMU2
%                 if isempty(iris)
%                     continue
%                 end
%                 imwrite(iris,sprintf('%0.2d%0.2d%0.2dr.bmp',i,j,k));
%             end
%         end
%     end
% end
% cd ..


% localize_iris('MMU/2/right/bryanr1.bmp');
% localize_iris('MMU/2/right/bryanr2.bmp');
% localize_iris('MMU/2/right/bryanr3.bmp');
% localize_iris('MMU/2/right/bryanr4.bmp');
% localize_iris('MMU/2/right/bryanr5.bmp');

end

