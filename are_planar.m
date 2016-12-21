function [ planar, crossdot_result ] = are_planar(a, b, c, d)
% are_planar.m Determines if four points in 3D space line on the same plane
%   This function calculates if four points in 3D space are co-planar,
%   by calculating ad dot (cross(ab, ac)).
%   If this value is zero (to machine precision),
%   then the four vectors are co-planar.

ab = b-a;
ac = c-a;
ad = d-a;
crossdot_result = ad'*cross(ab, ac);

% Some small tolerance value
epsilon = 1e-16;

if abs(crossdot_result) < epsilon
    planar = 1;
else
    planar = 0;
end

end

