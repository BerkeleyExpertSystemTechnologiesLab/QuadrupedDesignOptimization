function T = T_constK( p )
%T_constK.m Create the transformation matrix T for a continuum manipulator with constant curvature (K).
%   This function implements eqn.(2) in the Webster and Jones 2010 IJRR paper.
%   It takes in a set of arc parameters p and outputs the transformation matrix T.
%   This assumes a constant-curvature (aka, constant radius) curve.
%   Inputs:
%       p, a column vector in 3D, with the the three arc parameters of:
%           K (kappa), the curvature of the robot. K = 1/r, where r is the radius of curvature.
%           phi, the angle of the plan containing the arc. This is what rotates the robot around the Z-axis.
%           s, the arc length of the curve. This draws out the curve from 0 to L, the total length, and represents rotation around the Y-axis.
%       *Note that this "p" is not the "p" of the W&J 2010 paper in eqn.(1), which is the (x,y,z) position of the tip of the robot.

% First, check on the size of p.
assert( size(p, 1) == 3, 'Invalid size of p: must be 3 rows.');
assert( size(p, 2) == 1, 'Invalid size of p: must be 1 column (since p is a column vector.');

% pick out K, phi, and s for sake of writing the equations correctly.
% (TO-DO: directly reference p(i) inside the matrix, that will be faster.)
K = p(1);
phi = p(2);
s = p(3);

% Then, the homogenous transformation matrix is
T = [ cos(phi)*cos(K*s),    -sin(phi),  cos(phi)*sin(K*s),  (cos(phi)*(1-cos(K*s)))/K; ...
      sin(phi)*cos(K*s),     cos(phi),  sin(phi)*sin(K*s),  (sin(phi)*(1-cos(K*s)))/K; ...
     -sin(K*s),              0,         cos(K*s),           (sin(K*s))/K; ...
      0,                     0,         0,                  1];

% end function.
  
end

