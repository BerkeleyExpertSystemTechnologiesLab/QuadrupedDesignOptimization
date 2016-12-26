function [ result ] = rotxy( theta )
%rotxy.m Generates the 2D rotation matrix
%   Creates the in-plane, xy, 2D rotation matrix for
%   a rotation of theta counter-clockwise.
%   See, for example, wikipedia article:
%   https://en.wikipedia.org/wiki/Rotation_matrix
%   Copyright 2016 Drew (Andrew P.) Sabelhaus,
%   Berkeley Emergent Space Tensegrities lab

result = [cos(theta),       -sin(theta); ...
          sin(theta),       cos(theta)];

end

