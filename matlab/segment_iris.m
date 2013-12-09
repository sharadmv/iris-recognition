function segment_iris()
%SEGMENT_IRIS Summary of this function goes here
%   Detailed explanation goes here
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

close all;
cd MMU2
files = dir('*.bmp');
    for j=1:size(files,1)
        cd ..
        iris = localize_iris(strcat('MMU2/',files(j).name));
        cd MMU2
        imwrite(iris,strcat(files(j).name,'r','.bmp'));
    end
    cd ..


% localize_iris('MMU/2/right/bryanr1.bmp');
% localize_iris('MMU/2/right/bryanr2.bmp');
% localize_iris('MMU/2/right/bryanr3.bmp');
% localize_iris('MMU/2/right/bryanr4.bmp');
% localize_iris('MMU/2/right/bryanr5.bmp');

end

