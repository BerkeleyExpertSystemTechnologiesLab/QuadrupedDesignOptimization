% qpedspineContManipDemo.m
% Copyright 2016 Andrew P. Sabelhaus and
% the Berkeley Emergent Space Tensegrities Lab
% This function calls qpedspineContManipMove to do a demo of
% the quadruped spine with constant-radius curvature.

% prepare the workspace
clear all;
close all;
clc;

% Declare the constants for this demo

% For the spine itself:
L = 0.16;
r_curve = 0.2;
%r = 200;
% Curvature is the inverse of radius
K = 1/r_curve;
phi_deg = 30;
%phi_deg = 0;
% Change phi to radians (since it's easier to intuitively understand in degrees, first.)
phi = phi_deg * pi/180;
% For the visualization of the spine:
vis_rad = 0.05;
vis_num_pts = 10;

% For the quadruped body:
l = 0.34;
w = 0.12;
h = 0.27;

% Other configuration parameters
front_only = 1;
plot_on = 1;

% Call the function that simulates the spine after movement:
[ a2, b2, c2, d2 ] = qpedspineContManipMove(K, phi, L, vis_rad, vis_num_pts, plot_on, front_only, l, w, h)
