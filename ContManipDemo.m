% ContManipDemo.m
% Drew (Andrew P.) Sabelhaus
% Berkeley Emergent Space Tensegrities Lab 2016
% This script calculates the positions and renders a continuum manipulator
% based on the kinematics of the Webster & Jones 2010 IJRR paper.
% This will be used to represent the spine of a quadruped in later work.

% Set up the workspace
clear all;
close all;
clc;
% The total length of the curve:
L = 0.25;
%L = 0.6;

% Define the curvature and angle of the plane of the arc
% in arbitrary units (length) and degrees (phi)
r = 0.2;
% Curvature is the inverse of radius
K = 1/r;
phi_deg = 60;
%phi_deg = 0;
% Change phi to radians (since it's easier to intuitively understand in degrees, first.)
phi = phi_deg * pi/180;

% This script does a discrete approximation of the curve.
% Choose the number of discrete points:
num_points = 100;
% A series of arc lengths along this curve:
s_range = linspace(0, L, num_points);

% For plotting: we'd like to translate and rotate a single point along the curve
% of the manipulator. The centerline of the manipulator will be the origin, transformed
% according to this procedure.
% So, the point to translate will be:
point = [0; 0; 0];
% note that later, we can transform arbitrary points and make a 3D body of the robot,
% not just plotting the centerline.

% Translate a bunch of points on a circle along the curve.
radius = 0.05;
num_circle_points = 50;
theta = linspace(0, 2*pi, 50);
circle = [radius * cos(theta); radius * sin(theta)];

% Let's store all the resulting points along the curve of the manipulator.
% with each 3D vector being a column vector:
manip_points = zeros(3, num_points);

% Store the resulting circles as they're translated.
% Note that even though "circle" is in the 2D X-Y plane,
% the resulting point is in 3D and has a z-component.
circle_results = zeros(3, num_circle_points, num_points);

% DEBUGGING: store all the matrices T also, just to see what this looks like.
% T is always a 4x4 matrix.
T_i = zeros(4, 4, num_points);

% Iterate over all the points along the curve of the manipulator, get the T
% for that point, and store the resulting location of the centerline.
% check how long this takes:
tic;
for i=1:num_points
    % Calculate T for this point
    % FOR THE ORIGINAL COORDINATE SYSTEM
    %T = T_constK( [K; phi; s_range(i)]);
    % FOR THE ROTATED COORDINATE SYSTEM
    T = T_constK_rotated( [K; phi; s_range(i)]);
    % Store T appropriately
    T_i(:,:,i) = T;
    % Calculate the location of the centerline
    % Note that the homogenous transformation matrix takes a 3D vector
    % with a 1 appended to the end (an "affine transformation.")
    point_i = T * [point; 1];
    % translate the circle
    for j=1:num_circle_points
        % the resulting point for the j-th point along the circle will be
        % FOR THE ORIGINAL COORDINATE SYSTEM
        %circle_point_temp = T * [circle(1,j); circle(2,j); 0; 1];
        % FOR THE ROTATED COORDINATE SYSTEM
        circle_point_temp = T * [circle(1,j); 0; circle(2,j); 1];
        % store this point
        circle_results(:,j,i) = circle_point_temp(1:3);
    end
    % Store the point, removing the unecessary 1 at the end.
    manip_points(:,i) = point_i(1:3);
end

% How long did this take?
toc;

% Plot the centerline in 3D:
plot3( manip_points(1,:), manip_points(2,:), manip_points(3,:), 'r');
grid on;
axis equal;
hold on;
% Plot the circles at each point along the translation:
for i=1:num_points
    % the circle is 
    plot3(circle_results(1,:,i), circle_results(2,:,i), circle_results(3,:,i), 'b');
end

% Label the plot.
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Continuum manipulator demo');





