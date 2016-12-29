function [ a2, b2, c2, d2 ] = qpedspineContManipmove(K, phi, s, plot_on, front_only, l, w, h)
% qpedspine3Smove.m Calculates the foot locations of a quadruped with a Continuum Manipulator spine
%   This function calculates the location of the feet of a quadruped robot
%   with a constant-radius continuum manipulator as its spine.
%   The quadruped starting position is assumed to be a "rectangular box", where
%   the four feet are the bottom four nodes of the box, and the center of the spine
%   is in the middle of the top surface of the box.
% 
%   Inputs:
%       K (kappa), the curvature of the spine. K = 1/r, where r is the radius of curvature.
%           This parameter rotates the spine endpoint around the Z-axis.
%       phi, the angle of the plane containing the arc. This is what rotates the spine around the X-axis.
%           This angle should be in radians.
%       s, the arc length of the curve. This draws out the curve from 0 to L, the total length of the spine.
%           This parameter is treated also as L0, the initial length of the spine.
%           Specifically, the initial location of the endpoint of the spine is at (0, +s, 0).
%       plot_on, flag to turn on plotting the spine location in a new figure window
%       front_only, a flag that controls if the spine has both a front portion and a 
%           rear portion. If this flag is on, there is only a spine from 0 to +s,
%           but if this flag is off, then there is a spine from -s to +s along the y-axis.
%           This will be used to explore questions about planarity of the feet.
%           TO-DO: what would rotation mean in the context of this transformation>
%       l, the initial length of the front/rear section of the robot, not including spine (y-direction)
%       w, the initial width of the robot (x-direction)
%       h, the initial height of the robot (z-direction)
%
%   Dependencies:
%       T_constK_rotated.m, function that generates the transformation matrix for a continuum 
%       manipulator (e.g. a constant-radius curve), with the above-described coordinate system.

% Note that this kinematics script uses the location of the center of the spine
% as the origin, (0,0,0).
% Also, note that the total length of the robot with no spine bending is l+s (or l+2*s if
% front_only == 0).

% First, calculate the initial locations of the four feet, with respect
% to the start of the "front section." This does not account for the length of the spine.
% Looking from the back of the robot,
% Front left:
a = [-w/2; l/2; -h];
% Front right:
b = [w/2; l/2; -h];
% Rear left:
c = [-w/2; -l/2; -h];
% Rear right:
d = [w/2; -l/2; -h];

% Note that each of these need an additional coordinate to
% be multiplied by a homogenous transformation matrix.
% Each of these should be 4x1.
a = [a; 1];
b = [b; 1];
c = [c; 1];
d = [d; 1];

% Since we are not accounting for the spine length in these foot positions,
% we can use the transformation T directly on the above points, instead of
% having to calculate some offset, [0; -s; 0] or something like that.

% NOT DOING THE FOLLOWING:
% % Also, since the continuum manipulator spine
% % has the front body at some offset, since part of the "front"
% % is really the spine fully extended,
% % we need to offset each of the feet by this amount.
% % Otherwise the spine will be asymetric.
% %offset = [0; -s; 0; 1];
% % ...note that we're including the homogenous coordinate here.
% % (TO-DO: what's the proper name for this "1"?)

% The transformation matrix for the front feet will be 
T_f = T_constK_rotated([K, phi, s]);

% Move the front feet:
a2 = T_f*a;
b2 = T_f*b;

% For now, the back feet will not move.
% TO-DO: try this with a [0; -s; 0] offset for the back feet.
c2 = c;
d2 = d;

% If the back feet should be attached to a spine and moved too:
if ~front_only
    % fill this in later.
end

% The old, 3S joint calculations for the back feet:
% if ~front_only
%     % Note that we need an opposite rotation for the 
%     % rear two feet. Each of the angles needs to be
%     % negated.
%     % Let's make three more rotation matrices so we can re-use
%     % them later in the plotting section, too.
%     
%     % Rotating around the x-axis by -theta
%     t_rear = -t;
%     Rx_rear = [  1,       0,         0; ...
%             0,       cos(t_rear),    -sin(t_rear); ...
%             0,       sin(t_rear),    cos(t_rear)];
% 
%     % rotating around the y-axis by -gamma
%     g_rear = -g;
%     Ry_rear = [  cos(g_rear),  0,         sin(g_rear); ...
%             0,       1,         0; ...
%             -sin(g_rear)  0,         cos(g_rear)];
% 
%     % rotating around the z-axis by -phi
%     p_rear = -p;
%     Rz_rear = [  cos(p_rear),  -sin(p_rear),   0; ...
%             sin(p_rear),  cos(p_rear),    0; ...
%             0,       0,         1];
%     % The combined rotation matrix for the rear feet is
%     R_rear = Rz_rear*Ry_rear*Rx_rear;
%     
%     % Finall, move the two feet.
%     c2 = R_rear*c;
%     d2 = R_rear*d;
% end

% Then, if a plot should be created,
if plot_on
    % We need to plot the "body" of the quadruped, too.
    % Let's do that as a series of straight lines representing
    % the spine, shoulders, and hips.
    % Create the points what we want to draw lines between, then 
    % transform them the same way as the feet.
    % NOTE that here we use the [0; 0; 0; 1] homogenous augmentation.
    % The three shoulder points are:
    e = [-w/2; l/2; 0; 1];
    f = [0; l/2; 0; 1];
    i = [w/2; l/2; 0; 1];
    % The three hip points are:
    j = [-w/2; -l/2; 0; 1];
    k = [0; -l/2; 0; 1];
    m = [w/2; -l/2; 0; 1];
    % Rotate each of these points,
    % noting that we must use the R matrix for the front
    % legs/body and the R_rear matrix for the rear legs/body.
    e2 = T_f*e;
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
    title_string = strcat('Qped with k,phi,s=(',num2str(K),',', ...
        num2str(phi*180/pi),',',num2str(s),'), fonly=',num2str(front_only));
    title(title_string);
    xlabel('x, width');
    ylabel('y, length');
    zlabel('z, height');
end

% end function.
end








