function [ result ] = rotx_sym( theta )
%rotxy.m Generates the 3D rotation matrix around the x-axis
%   Creates the 3D rotation matrix for rotations around the x-axis,
%   a rotation of theta counter-clockwise.
%   See, for example, wikipedia article:
%   https://en.wikipedia.org/wiki/Rotation_matrix
%   Copyright 2016 Drew (Andrew P.) Sabelhaus,
%   Berkeley Emergent Space Tensegrities lab

result = [1,    0,              0; ...
          0,    cos(theta),     -sin(theta); ...
          0,    sin(theta),     cos(theta)];

end

