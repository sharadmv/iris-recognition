function fit_circle()
%TEST Summary of this function goes here
%   Detailed explanation goes here
close all;
% I = imread('MMU2/470204.bmp');
% I = imread('MMU2/340202.bmp');
I = imread('MMU2/270202.bmp');
% I = imread('MMU2/470201.bmp');
% I = imread('MMU2/540204.bmp');
gray = rgb2gray(I);
BW1 = ~im2bw(gray, 0.1);
BW2 = ~bwareaopen(~bwareaopen(BW1,400),400);
[centers,radii,metric] = imfindcircles(BW2,[10 300]);
draw_circle(centers(1,1),centers(1,2),radii(1,1));
pupil_radius = radii(1,1);
pupil_center = [centers(1,1) centers(1,2)];


BW3 = edge(gray,'canny',.1,5);
BW4 = bwareaopen(BW3,10);
figure,imshow(BW4);
figure,imshow(gray);
%[centers,radii,metric] = imfindcircles(BW4,[10 1000]);

% shoot rays at ever 5 degrees outwards from pupil and stuff
ray_buffer = pupil_radius+10;
ray_pts = zeros(72,2);
for i=1:72
    ray_dir = [cos(degtorad(5*i)) sin(degtorad(5*i))];
    ray_dir = ray_dir/norm(ray_dir);
    hit_edge = 0;
    ray_pts(i,:) = pupil_center+ray_dir.*ray_buffer;
    while hit_edge == 0 && floor(ray_pts(i,2)) < size(BW4,1) &&  floor(ray_pts(i,1)) < size(BW4,2)
        ray_pts(i,:) = ray_pts(i,:)+ray_dir;
        hit_edge = BW4(floor(ray_pts(i,2)),floor(ray_pts(i,1))) || BW4(floor(ray_pts(i,2))+sign(ray_dir(2)),floor(ray_pts(i,1))) || BW4(floor(ray_pts(i,2)),floor(ray_pts(i,1))+sign(ray_dir(1)));
    end
    draw_circle(ray_pts(i,1),ray_pts(i,2),1);
end
draw_circle(pupil_center(1),pupil_center(2),1);
% iris_radius = fit_best_circle([pupil_center(1) pupil_center(2)],ray_pts);
% rad = 45;
% draw_circle(pupil_center(1),pupil_center(2),rad);
% reward = circle_fit([pupil_center(1) pupil_center(2)], rad, ray_pts);
% reward
iris_radius = fminbnd(@(rad) circle_fit([pupil_center(1) pupil_center(2)], rad, ray_pts), 20, 100)
draw_circle(pupil_center(1),pupil_center(2),iris_radius);
draw_circle(pupil_center(1),pupil_center(2),pupil_radius);



% ray_coord = [floor(pupil_center(1)+pupil_radius+10),floor(pupil_center(2))] %10 pixel buffer
% hit_edge = 0;
% while hit_edge == 0
%     hit_edge = BW4(ray_coord(1),ray_coord(2)) || BW4(ray_coord(1)+1,ray_coord(2)) || BW4(ray_coord(1),ray_coord(2)+1);
%     ray_coord = [ray_coord(1)+1,ray_coord(2)+1];
% end
% ray = distance(ray_coord,pupil_center);
% figure,imshow(gray);
% drawCircle(pupil_center(1),pupil_center(2),ray);

end

function draw_circle(x,y,r)
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
hold on;
h = plot(xunit, yunit);
hold off;
end

% exponential reward
% function value = circle_fit(center, radius, projected_pts)
% value = 0;
% circle_pts = zeros(72,2);
% for i=1:72
%     ray_dir = [cos(degtorad(5*i)) sin(degtorad(5*i))];
%     ray_dir = ray_dir/norm(ray_dir);
%     circle_pts(i,:) = center+ray_dir.*radius;
%     distance = pdist(cat(1,circle_pts(i,:),projected_pts(i,:)));
%     value = value+nthroot(distance,100);
% end
% end

% median reward
function value = circle_fit(center, radius, projected_pts)
distances = zeros(72,1);
circle_pts = zeros(72,2);
for i=1:72
    ray_dir = [cos(degtorad(5*i)) sin(degtorad(5*i))];
    ray_dir = ray_dir/norm(ray_dir);
    circle_pts(i,:) = center+ray_dir.*radius;
    distance = pdist(cat(1,circle_pts(i,:),projected_pts(i,:)));
    distances(i,1) = round(distance);
end
value = median(distances);
end