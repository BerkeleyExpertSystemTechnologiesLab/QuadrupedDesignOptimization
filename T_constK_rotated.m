function T = T_constK_rotated( p )
%T_constK.m Create the transformation matrix T for a continuum manipulator with constant curvature (K).
%   This function implements eqn.(2) in the Webster and Jones 2010 IJRR paper,
%   but in a different coordinate system: this is used for the spine curve for a quadruped.
%   It takes in a set of arc parameters p and outputs the transformation matrix T.
%   This assumes a constant-curvature (aka, constant radius) curve.
%   Inputs:
%       p, a column vector in 3D, with the the three arc parameters of:
%           K (kappa), the curvature of the manipulator. K = 1/r, where r is the radius of curvature.
%               This parameter rotates the endpoint of the curve around the Z-axis.
%           phi, the angle of the plan containing the arc. This is what rotates the curve around the X-axis.
%           s, the arc length of the curve. This draws out the curve from 0 to L, the total length of the curve.
%           This parameter is treated also as L0, the initial length of the curve.
%           Specifically, the initial location of the endpoint of the curve is at (0, +s, 0).
%       *Note that this "p" is not the "p" of the W&J 2010 paper in eqn.(1), which is the (x,y,z) position of the tip of the robot.

% First, check on the size of p.
assert( size(p, 1) == 3, 'Invalid size of p: must be 3 rows.');
assert( size(p, 2) == 1, 'Invalid size of p: must be 1 column (since p is a column vector.');

% pick out K, phi, and s for sake of writing the equations correctly.
% (TO-DO: directly reference p(i) inside the matrix, that will be faster.)
K = p(1);
phi = p(2);
s = p(3);

% Then, the homogenous transformation matrix is the following.
% Note that this is similar to the T from the 2010 IJRR paper,
% but instead of that eqn, is:
% T = [ Rx(phi), 0; 0, 1] * [Rz(theta), "p"; 0, 1]
% ...where "p" is the endpoint of the tip of the spine.
% This accounts for the change in coordinate system.

% With a +z rotation included:
% T = [ cos(K*s),             -sin(K*s),          0,              (1-cos(K*s))/K; ...
%       cos(phi)*sin(K*s),     cos(phi)*cos(K*s), -sin(phi),      (cos(phi)*sin(K*s))/K; ...
%       sin(phi)*sin(K*s),     sin(phi)*cos(K*s), cos(phi),       (sin(phi)*sin(K*s))/K; ...
%       0,                     0,                 0,              1];

% With a -z rotation included:
T = [ cos(K*s),              sin(K*s),          0,              (1-cos(K*s))/K; ...
     -cos(phi)*sin(K*s),     cos(phi)*cos(K*s), -sin(phi),      (cos(phi)*sin(K*s))/K; ...
     -sin(phi)*sin(K*s),     sin(phi)*cos(K*s), cos(phi),       (sin(phi)*sin(K*s))/K; ...
      0,                     0,                 0,              1];

% end function.
  
end

















