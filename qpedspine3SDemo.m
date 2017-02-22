% qpedspine3SDemo.m
% Copyright 2016 Andrew P. Sabelhaus and
% the Berkeley Emergent Space Tensegrities Lab
% This function calls qpedspine3SMove to do a demo of
% the quadruped with an ideal ball-joint spine.

% prepare the workspace
clear all;
close all;
clc;

% Declare the constants for this demo

% For the spine itself:
%       t, theta, rotation in the x-direction (saggital bending), radians
%       g, gamma, rotation in the y-direction (axial rotaion), radians
%       p, phi, rotation in the z-direction (coronal bending), radians
t = pi/8;
g = 0;
p = pi/9;

% For the quadruped body:
l = 0.34;
w = 0.12;
h = 0.27;

% Other configuration parameters
front_only = 1;
plot_on = 1;

% Call the function that simulates the spine after movement:
[ a2, b2, c2, d2 ] = qpedspine3SMove(t, g, p, plot_on, front_only, l, w, h);

% Check planarity
disp('Are planar:');
are_planar(a2, b2, c2, d2)
