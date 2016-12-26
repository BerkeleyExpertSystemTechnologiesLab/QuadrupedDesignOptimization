function [ result ] = rotz_sym( phi )
%rotxy.m Generates the 3D rotation matrix around the z-axis
%   Creates the 3D rotation matrix for rotations around the z-axis,
%   a rotation of phi counter-clockwise.
%   See, for example, wikipedia article:
%   https://en.wikipedia.org/wiki/Rotation_matrix
%   Copyright 2016 Drew (Andrew P.) Sabelhaus,
%   Berkeley Emergent Space Tensegrities lab

result = [cos(phi),     -sin(phi),    0; ...
          sin(phi),     cos(phi),     0; ...
          0,            0,            1];

end

