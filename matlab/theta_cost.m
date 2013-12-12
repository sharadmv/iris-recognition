function [cost] = theta_cost(dist, theta)

if dist <= theta
    cost = 1;
else
    cost = -1;
end
