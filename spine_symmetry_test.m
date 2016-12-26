%% spine_symmetry_test.m
% Copyright 2016 Drew (Andrew P.) Sabelhaus
% and the Berkeley Emergent Space Tensegrities Lab
% This script plays around with various symmetry properties of an actuated spine.
% In particular, testing of fixed-frame versus
% moving-frame combined bending.
% Are any of these equivalent to the "symmetric" bending shown in
% qpedspine3Smove.m, which has the quadruped's feet planar?

clear all;
close all;
clc;

%% Two-D moving frame.

% Claim: in 2D, a bending by theta around the single spine axis
% is equivalent to symmetric bending for front and back legs, 
% each by theta/2. This requires the quadruped be allowed to
% "fall down" since even though planarity is preserved, the 
% spine would be rotated slightly in the global reference frame.

% Let's do this symbolically.
% We'll have some length L that defines the "front" of the
% spine as well as the "rear" of the spine, e.g., three nodes
% where the system rotates around the center node.
syms L theta real;

% With the point-spine at the origin,
% the front and rear nodes lie along the y-axis.
f = [0; L];
r = [0; -L];

% The rotation matrix for the front section will be
R = rotxy(theta);

% The new location of the front section:
f2 = R*f;

% Then, let's rotate the whole system by -theta/2.
% This should have the bisecting vector between the two
% spine segments align with the +y axis.
R2 = rotxy(-theta/2);

% The new rotated positions are
f3 = R2*f2;
r3 = R2*r;

% Compare to the "symmetric" rotation,
% where the rear is rotated by -theta/2
% and the front is rotated by +theta/2.
R4 = rotxy(theta/2);
f4 = R4*f;
r4 = R2*r;

% Simplify f3 and we get that f3 == f4, as expected
% from linear algebra. still worth showing.

%% 3D fixed frame.

% Because we can run this script in sections,
% let's re-prepare the workspace.
% The 2D cas isn't interesting enough to keep around.

clear all;
close all;
clc;

% We'll have some length L that defines the "front" of the
% spine as well as the "rear" of the spine, e.g., three nodes
% where the system rotates around the center node.
% Note here we need theta (around x), gamma (around y),
% and phi (around z) rotation angles.
syms L theta gamma phi real;

% With the point-spine at the origin,
% the front and rear nodes are located
% along the y-axis.
f = [0; L; 0];
r = [0; -L; 0];

% First rotation: around the z-axis.
% The spine should still be in the x-y plane.
% This corresponds to bending in the coronal plane.
% Use a custom function, since the built-in
% MATLAB rotz does not appear to accept symbolic variables.
f2 = rotz_sym(phi)*f;

% Second rotation: around the x-axis.
% (This corresponds to bending in the saggital plane.)
f3 = rotx_sym(theta)*f2;

% Is this the same as rotation around x then z,
% instead of z then x? Answer is no I think.
f4 = rotz_sym(phi)*rotx_sym(theta)*f;













