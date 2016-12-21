% foot_lifting_proof.m
% Andrew P. Sabelhaus
% This script tests out some theories related to the co-planarity
% of four feet of a quadruped, dependent on rotations of its spine.

clear all;
close all
clc;

% The parameters of the box-quadruped
l = 0.34;
w = 0.12;
h = 0.27;

% The initial vectors of its four feet
a = [-w/2; l/2; -h];
b = [w/2; l/2; -h];
c = [-w/2; -l/2; -h];
d = [w/2; -l/2; -h];

% Three rotation matrices for each axis:
% theta, gamma, phi
t = 27*(pi/180);
g = 4*(pi/180); %this is the one that's expected to cause out-of-plane motion.
p = 19*(pi/180);

% Rotating around the x-axis by theta
Rx = [  1,       0,         0; ...
        0,       cos(t),    -sin(t); ...
        0,       sin(t),    cos(t)];

% rotating around the y-axis by gamma
Ry = [  cos(g),  0,         sin(g); ...
        0,       1,         0; ...
        -sin(g)  0,         cos(g)];

% rotating around the z-axis by phi
Rz = [  cos(p),  -sin(p),   0; ...
        sin(p),  cos(p),    0; ...
        0,       0,         1];
     
% Full rotation, if needed.
R = Rz*Ry*Rx;

% First, basic planarity, no rotations.
ab = b-a;
ac = c-a;
ad = d-a;
% Planar if the following equals zero
planar1 = ad'*(cross(ab, ac))

% Next, planarity under saggital bending (x-axis).
% rotate the two front feet:
a2 = Rx*a;
b2 = Rx*b;
% The vectors between feet are now
a2b2 = b2-a2;
a2c = c - a2;
a2d = d - a2;
% Planar if the following equals zero
planar2 = a2d'*(cross(a2b2, a2c))

% Third, planarity under coronal bending (z-axis).
a3 = Rz*a;
b3 = Rz*b;
% The vectors between feet are now
a3b3 = b3-a3;
a3c = c - a3;
a3d = d - a3;
% Planar if the following equals zero
planar3 = a3d'*(cross(a3b3, a3c))

% Check to confirm: bending around the y-axis
% DOES in fact break planarity.
a4 = Ry*a;
b4 = Ry*b;
% The vectors between feet are now
a4b4 = b4-a4;
a4c = c - a4;
a4d = d - a4;
% Planar if the following equals zero
planar4 = a4d'*(cross(a4b4, a4c))

% Finally, the major contribution of this work:
% Does bending in both x and z break planarity?
a5 = Rz*Rx*a;
b5 = Rz*Rx*b;
% The vectors between feet are now
a5b5 = b5-a5;
a5c = c - a5;
a5d = d - a5;
% Planar if the following equals zero
planar5 = a5d'*(cross(a5b5, a5c))
% I guess not!

% BUT, what if the back legs move in a symmetric manner?
% E.g, if the total spine rotation is 2*t, or 2*g, ...
% My guess is that this won't do anything. Rotating the back
% legs should just consist of a coordinate transformation,
% e.g. rotate the reference frame and everything stays the same.
% But maybe not though, ...
c2 = Rz*Rx*c;
d2 = Rz*Rx*d;
% The vectors between feet are now
a5b5 = b5-a5;
a5c2 = c2 - a5;
a5d2 = d2 - a5;
% Planar if the following equals zero
planar6 = a5d2'*(cross(a5b5, a5c2))
% Actually, this seems to be true (at least to machine
% precision error.) Huh.

% ^NOTE: the above is incorrect, see qpedspine3Smove, where
%  we show that the rotation for the rear feet has to be the negative of
%  what I have above in this script file.














