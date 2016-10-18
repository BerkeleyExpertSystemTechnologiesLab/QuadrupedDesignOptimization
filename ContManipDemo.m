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

% Define the curvature and angle of the plane of the arc
% in arbitrary units (length) and degrees (phi)
r = 0.2;
% Curvature is the inverse of radius
K = 1/r;
phi_deg = 60;
% Change phi to radians (since it's easier to intuitively understand in degrees, first.)
phi = phi_deg * pi/180;

% The total length of the curve:
L = 0.18;
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

% Let's store all the resulting points along the curve of the manipulator.
% with each 3D vector being a column vector:
manip_points = zeros(3, num_points);

% DEBUGGING: store all the matrices T also, just to see what this looks like.
% T is always a 4x4 matrix.
T_i = zeros(4, 4, num_points);

% Iterate over all the points along the curve of the manipulator, get the T
% for that point, and store the resulting location of the centerline.
% check how long this takes:
tic;
for i=1:num_points
    % Calculate T for this point
    T = T_constK( [K; phi; s_range(i)]);
    % Store T appropriately
    T_i(:,:,i) = T;
    % Calculate the location of the centerline
    % Note that the homogenous transformation matrix takes a 3D vector
    % with a 1 appended to the end (an "affine transformation.")
    point_i = T * [point; 1];
    % Store the point, removing the unecessary 1 at the end.
    manip_points(:,i) = point_i(1:3);
end

% How long did this take?
toc;

% Plot the centerline in 3D:
plot3( manip_points(1,:), manip_points(2,:), manip_points(3,:), 'r');
grid on;
axis equal;





