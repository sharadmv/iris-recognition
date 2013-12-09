function iris = localize_iris(filename)
%LOCALIZE_IRIS find pupil and iris in the given image
%   ARGUMENTS
%       filename - location of image file
%   RETURNS 1x5 array of information on the located eye
%       eye_information(1:2) - center of pupil
%       eye_information(3) - radius of pupil
%       eye_information(4:5) = [a b] - radii of detected iris ellipse

%% CHANGE IMAGE HERE FOR TESTING

I = imread(filename);
% I = imread('MMU2/470204.bmp');
% I = imread('MMU2/340202.bmp');
% I = imread('MMU2/270202.bmp');
% I = imread('MMU2/470201.bmp');
% I = imread('MMU2/540204.bmp');

%% FIND PUPIL
gray = rgb2gray(I);
BW1 = ~im2bw(gray, 0.1);
BW2 = ~bwareaopen(~bwareaopen(BW1,400),400);
[centers,radii,metric] = imfindcircles(BW2,[10 30]);
pupil_radius = radii(1,1);
pupil_center = [centers(1,1) centers(1,2)];

%% FIND IRIS
% Find edges
BW3 = edge(gray,'canny',.1,2);
BW4 = bwareaopen(BW3,10);
figure,imshow(gray);

% Shoot rays at every degree outwards from pupil and stuff
ray_buffer = pupil_radius+10;
ray_pts = zeros(360,2);
for i=1:360
    if (i>45 && i<=135) || (i>180 && i<=360) % Only shoot rays between 1-45 and 135-180
        continue;
    end
    ray_dir = [cos(degtorad(i)) sin(degtorad(i))];
    ray_dir = ray_dir/norm(ray_dir);
    hit_edge = 0;
    ray_pts(i,:) = pupil_center+ray_dir.*ray_buffer;
    while hit_edge == 0 && floor(ray_pts(i,2)) < size(BW4,1) &&  floor(ray_pts(i,1)) < size(BW4,2)
        ray_pts(i,:) = ray_pts(i,:)+ray_dir;
        hit_edge = BW4(floor(ray_pts(i,2)),floor(ray_pts(i,1))) || BW4(floor(ray_pts(i,2))+sign(ray_dir(2)),floor(ray_pts(i,1))) || BW4(floor(ray_pts(i,2)),floor(ray_pts(i,1))+sign(ray_dir(1)));
    end
    draw_ellipse(ray_pts(i,1),ray_pts(i,2),1,1,'b');
end
draw_ellipse(pupil_center(1),pupil_center(2),1,1,'b');
draw_ellipse(pupil_center(1),pupil_center(2),pupil_radius,pupil_radius,'b');

%% FIT ELLIPSE
iris_radii = fminsearch(@(radii) ellipse_fit([pupil_center(1) pupil_center(2)], radii, ray_pts), [50 50]);
draw_ellipse(pupil_center(1),pupil_center(2),iris_radii(1),iris_radii(2),'b');
eye_information = horzcat(pupil_center,pupil_radius,iris_radii);

%% TRANSFORM CIRCLE
iris_ellipse = gray((pupil_center(2)-ceil(iris_radii(2))):(pupil_center(2)+ceil(iris_radii(2))),(pupil_center(1)-ceil(iris_radii(1))):(pupil_center(1)+ceil(iris_radii(1))));
iris_circle = imresize(iris_ellipse, [size(iris_ellipse,1) size(iris_ellipse,1)]);

%% RECTANGULARIZE
iris_circle = double(iris_circle)/255.0;
iris_rectangle = ImToPolar(iris_circle,pupil_radius/iris_radii(2),1,40,250);
iris = iris_rectangle(5:35,:);
% iris = iris_rectangle;
figure,imshow(iris);

% %% Filter noise
% iris_line = iris(17,:);
% iris_shade = median(iris_line);
% iris_shade
% % dark_areas = ~im2bw(iris_rectangle, iris_shade-0.2*iris_shade);
% % light_areas = im2bw(iris_rectangle, iris_shade+0.2*(1-iris_shade));
% % figure,imshow(light_areas);
% % figure,imshow(dark_areas);
% 
% filtered_rectangle = xor(im2bw(iris, iris_shade-0.1),im2bw(iris, iris_shade+0.1));
% figure,imshow(edge(filtered_rectangle));
% 
% % figure,imshow(filtered_rectangle);
% % filtered_rectangle = ~bwareaopen(~bwareaopen(filtered_rectangle,400),400);
% % figure,imshow(filtered_rectangle);
end



% sum reward function
function value = ellipse_fit(center, radii, projected_pts)
distances = zeros(360,1);
ellipse_pts = zeros(360,2);
% Shoot rays at every degree outwards from the center but make it an ellipse given [a b]=radii
% then at each degree ray shot out, compute distance from the same ray shot out
% from the original image, but stopped when it hit an edge
% essentially comparing an ellipse of known parameters to the pts found
% from the rays
% This function, with fminsearch, returns the radii of an ellipse that
% gives the smallest sum distances between the pts
% SSD gives worse performance
for i=1:360
    if (i>45 && i<=135) || (i>180 && i<=360)
        continue;
    end
    ray_dir = [cos(degtorad(i)) sin(degtorad(i))];
    ray_dir = ray_dir/norm(ray_dir);
    ellipse_pts(i,:) = [center(1)+ray_dir(1)*radii(1) center(2)+ray_dir(2)*radii(2)];
    ray_distance = pdist(cat(1,center,projected_pts(i,:)));
    if ray_distance > 40.0 && ray_distance < 70.0
        distance = pdist(cat(1,ellipse_pts(i,:),projected_pts(i,:)));
        distances = cat(1,distances,distance.^2);
    end
end
% distances = sort(distances);
% value = sum(distances(23:67));
value = sum(distances);
end