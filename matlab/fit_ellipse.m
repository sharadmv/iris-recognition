function fit_ellipse()
%TEST Summary of this function goes here
%   Detailed explanation goes here
close all;

%% CHANGE IMAGE HERE FOR TESTING

% I = imread('MMU2/470204.bmp');
% I = imread('MMU2/340202.bmp');
I = imread('MMU2/270202.bmp');
% I = imread('MMU2/470201.bmp');
% I = imread('MMU2/540204.bmp');

%% FIND PUPIL
gray = rgb2gray(I);
BW1 = ~im2bw(gray, 0.1);
BW2 = ~bwareaopen(~bwareaopen(BW1,400),400);
imshow(BW2);
[centers,radii,metric] = imfindcircles(BW2,[10 30]);
pupil_radius = radii(1,1);
pupil_center = [centers(1,1) centers(1,2)];

%% FIND IRIS
% find edges
BW3 = edge(gray,'canny',.1,2);
BW4 = bwareaopen(BW3,10);
figure,imshow(BW4);
figure,imshow(gray);

% shoot rays at every degree outwards from pupil and stuff
ray_buffer = pupil_radius+10;
ray_pts = zeros(360,2);
for i=1:360
    if (i>45 && i<=135) || (i>180 && i<=360) % only shoot rays between 1-45 and 135-180
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
iris_radii

end



% sum reward function
function value = ellipse_fit(center, radii, projected_pts)
distances = zeros(360,1);
ellipse_pts = zeros(360,2);
% shoot rays at every degree outwards from the center but make it an ellipse given [a b]=radii
% then at each degree ray shot out, compute distance from the same ray shot out
% from the original image, but stopped when it hit an edge
% essentially comparing an ellipse of known parameters to the pts found
% from the rays
% this function, with fminsearch, returns the radii of an ellipse that
% gives the smallest sum distances between the pts
% SSD gives worse performance
for i=1:360
    if (i>45 && i<=135) || (i>180 && i<=360)
        continue;
    end
    ray_dir = [cos(degtorad(i)) sin(degtorad(i))];
    ray_dir = ray_dir/norm(ray_dir);
    ellipse_pts(i,:) = [center(1)+ray_dir(1)*radii(1) center(2)+ray_dir(2)*radii(2)];
    distance = pdist(cat(1,ellipse_pts(i,:),projected_pts(i,:)));
    distances(i,1) = distance
end
value = sum(distances);
end