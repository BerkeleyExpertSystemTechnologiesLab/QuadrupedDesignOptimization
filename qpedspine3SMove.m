function [ a2, b2, c2, d2 ] = qpedspine3SMove(t, g, p, plot_on, front_only, l, w, h)
% qpedspine3Smove.m Calculates the foot locations of a quadruped with a 3S spine joint
%   This function calculates the location of the feet of a quadruped robot
%   with an ideal 3-DOF spherical joint at its spine.
%   The quadruped starting position is assumed to be a "rectangular box", where
%   the four feet are the bottom four nodes of the box, and the spine
%   joint is in the middle of the top surface of the box.
%   Inputs:
%       t, theta, rotation in the x-direction (saggital bending)
%       g, gamma, rotation in the y-direction (axial rotaion)
%       p, phi, rotation in the z-direction (coronal bending)
%       plot_on, flag to turn on plotting the spine location in a new figure window
%       front_only, a flag that controls if the front feet alone are rotated, or 
%           if the back feet are rotated in the same way as the front feet. 
%           This will be used to explore questions about planarity of the feet,
%           specifically, why does it seem that planarity holds for t,p ~= 0 && ~front_only,
%           whereas it seems to not hold for t,p ~=0 && front_only?
%       l, the initial length of the robot (y-direction)
%       w, the initial width of the robot (x-direction)
%       h, the initial height of the robot (z-direction)

% Note that this kinematics script uses the location of the spherical spine joint
% as the origin, (0,0,0).

% First, calculate the initial locations of the four feet.
% Looking from the back of the robot,
% Front left:
a = [-w/2; l/2; -h];
% Front right:
b = [w/2; l/2; -h];
% Rear left:
c = [-w/2; -l/2; -h];
% Rear right:
d = [w/2; -l/2; -h];

% Then, calculate the three transformation matrices, one for each of
% the spherical joint angles.

% Rotating around the x-axis by theta
% Positive t is clockwise rotation
Rx = [  1,       0,         0; ...
        0,       cos(t),    -sin(t); ...
        0,       sin(t),    cos(t)];

% rotating around the y-axis by gamma
Ry = [  cos(g),  0,         sin(g); ...
        0,       1,         0; ...
        -sin(g)  0,         cos(g)];

% rotating around the z-axis by phi
% Positive p is counterclockwise rotation
Rz = [  cos(p),  -sin(p),   0; ...
        sin(p),  cos(p),    0; ...
        0,       0,         1];
     
% The combined total rotation matrix.
R = Rz*Ry*Rx;

% Rotate the front feet.
a2 = R*a;
b2 = R*b;

% Calculate the positions of the back two feet.
% initialize to the original position,
% then change if needed.
c2 = c;
d2 = d;
if ~front_only
    % Note that we need an opposite rotation for the 
    % rear two feet. Each of the angles needs to be
    % negated.
    % Let's make three more rotation matrices so we can re-use
    % them later in the plotting section, too.
    
    % Rotating around the x-axis by -theta
    t_rear = -t;
    Rx_rear = [  1,       0,         0; ...
            0,       cos(t_rear),    -sin(t_rear); ...
            0,       sin(t_rear),    cos(t_rear)];

    % rotating around the y-axis by -gamma
    g_rear = -g;
    Ry_rear = [  cos(g_rear),  0,         sin(g_rear); ...
            0,       1,         0; ...
            -sin(g_rear)  0,         cos(g_rear)];

    % rotating around the z-axis by -phi
    p_rear = -p;
    Rz_rear = [  cos(p_rear),  -sin(p_rear),   0; ...
            sin(p_rear),  cos(p_rear),    0; ...
            0,       0,         1];
    % The combined rotation matrix for the rear feet is
    R_rear = Rz_rear*Ry_rear*Rx_rear;
    
    % Finall, move the two feet.
    c2 = R_rear*c;
    d2 = R_rear*d;
end

% Then, if a plot should be created,
if plot_on
    % We need to plot the "body" of the quadruped, too.
    % Let's do that as a series of straight lines representing
    % the spine, shoulders, and hips.
    % Create the points what we want to draw lines between, then 
    % transform them the same way as the feet.
    % The three shoulder points are:
    e = [-w/2; l/2; 0];
    f = [0; l/2; 0];
    i = [w/2; l/2; 0];
    % The three hip points are:
    j = [-w/2; -l/2; 0];
    k = [0; -l/2; 0];
    m = [w/2; -l/2; 0];
    % Rotate each of these points,
    % noting that we must use the R matrix for the front
    % legs/body and the R_rear matrix for the rear legs/body.
    e2 = R*e;
    f2 = R*f;
    i2 = R*i;
    % the rear points are only rotated if the 
    % back feet are rotated also, needs to stay consistent
    % with the feet locations.
    j2 = j;
    k2 = k;
    m2 = m;
    if ~front_only
        j2 = R_rear*j;
        k2 = R_rear*k;
        m2 = R_rear*m;
    end
    % Now, make the plot.
    figure;
    hold on;
    % The front legs.
    % a2 to e2
    line([a2(1); e2(1)], [a2(2); e2(2)], [a2(3); e2(3)]);
    % b2 to i2
    line([b2(1); i2(1)], [b2(2); i2(2)], [b2(3); i2(3)]);
    % The front body.
    % e2 to i2
    line([e2(1); i2(1)], [e2(2); i2(2)], [e2(3); i2(3)]);
    % f2 to origin (center of the spine.)
    line([f2(1); 0], [f2(2); 0], [f2(3); 0]);
    % The rear legs.
    % c2 to j2
    line([c2(1); j2(1)], [c2(2); j2(2)], [c2(3); j2(3)]);
    % d2 to m2
    line([d2(1); m2(1)], [d2(2); m2(2)], [d2(3); m2(3)]);
    % The rear body.
    % j2 to m2
    line([j2(1); m2(1)], [j2(2); m2(2)], [j2(3); m2(3)]);
    % k2 to origin (center of the spine.)
    line([k2(1); 0], [k2(2); 0], [k2(3); 0]);
    % clean up the plot
    %axis equal;
    title_string = strcat('Qped with t,g,p=(',num2str(t*180/pi),',', ...
        num2str(g*180/pi),',',num2str(p*180/pi),'), fonly=',num2str(front_only));
    title(title_string);
    xlabel('x, width');
    ylabel('y, length');
    zlabel('z, height');
end

% end function.
end








