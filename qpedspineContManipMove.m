function [ a2, b2, c2, d2 ] = qpedspineContManipMove(K, phi, s, rad, num_points, plot_on, front_only, l, w, h)
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
%       rad, the "radius" of the virtual spine for plotting. This has no effect on the foot simulation,
%           but is used for plotting. See ContManipDemo for a similar use.
%           *NOT USED UNLESS plot_on = 1
%       num_points, the number of points to use for plotting the spine, as a discretization.
%           This function uses num_points to draw small sections of the spine curve, and plots
%           a single circle of radius "rad" at each of these points.
%           *NOT USED UNLESS plot_on = 1
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

% If we are plotting the spine too, create the points now,
% before we create the transformation matrices.
if plot_on
    % This script does a discrete approximation of the spine curve,
    % with num_points segments.
    % A series of arc lengths along this spine curve:
    s_range = linspace(0, s, num_points);

    % Record the new "endpoint" of the spine.
    % Since we're treating w,l,h in reference to the origin,
    % the new spine endpoint will be the origin translated and rotated:
    s_f = [0; 0; 0; 1];
    % note that later, we can transform arbitrary points and make a 3D body of the robot,
    % not just plotting the centerline.

    % Translate a bunch of points on a circle along the curve.
    % These show a nice visualization of the "spine".
    num_cir_pts = 50;
    theta = linspace(0, 2*pi, num_cir_pts);
    % The initial circle exists in the X-Z plane.
    circle = [rad * cos(theta); zeros(1, num_cir_pts); ...
        rad * sin(theta); ones(1, num_cir_pts)];
    
    % Initialize some matrices to store the resulting data.
    % Let's store all the resulting points along the curve of the spine.
    % with each 3D vector being a column vector, plus the coordinate for
    % homogeneity:
    s_pts = zeros(4, num_points);
    
    % Store the resulting circles as they're translated, too.
    circle_results = zeros(4, num_cir_pts, num_points);
end

% Next, perform the actual transformation, for the feet.

% The transformation matrix for the front feet will be 
T_f = T_constK_rotated([K; phi; s]);

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
    % Create the spine visualization.
    % Use the variable "it" for "iterator", since "i"
    % is used below for a vector into a location in the quadruped body.
    for it=1:num_points
        % Calculate T for this point
        T_f_i = T_constK_rotated( [K; phi; s_range(it)]);
        % Calculate the location of the spine centerline
        s_f_i = T_f_i * s_f;
        % translate the circle
        % use "iter" for the indexing variable here.
        for iter=1:num_cir_pts
            circle_point_temp = T_f_i * circle(:,iter);
            % store this point
            circle_results(:,iter,it) = circle_point_temp;
        end
        % Store the point, removing the unecessary 1 at the end.
        s_pts(:,it) = s_f_i;
    end
    
    % Next, plot the spine, given these points that have been calculated.
    figure;
    hold on;
    % Plot the centerline in 3D:
    plot3( s_pts(1,:), s_pts(2,:), s_pts(3,:), 'r');
    % Plot the circles at each point along the translation:
    for it=1:num_points
        % the circle is 
        plot3(circle_results(1,:,it), circle_results(2,:,it), circle_results(3,:,it), 'b');
    end
    
    % The endpoint of the spine should be transformed too:
    s_f = T_f * s_f;
    
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
    % noting that we must use the T_f matrix for the front
    % legs/body and the T_r matrix for the rear legs/body.
    e2 = T_f*e;
    f2 = T_f*f;
    i2 = T_f*i;
    % the rear points are only rotated if the 
    % back feet are rotated also, needs to stay consistent
    % with the feet locations.
    j2 = j;
    k2 = k;
    m2 = m;
    if ~front_only
        % fill this in later.
%         j2 = R_rear*j;
%         k2 = R_rear*k;
%         m2 = R_rear*m;
    end
    % Now, make the plot for the quadruped body.
    % The front legs.
    % a2 to e2
    line([a2(1); e2(1)], [a2(2); e2(2)], [a2(3); e2(3)]);
    % b2 to i2
    line([b2(1); i2(1)], [b2(2); i2(2)], [b2(3); i2(3)]);
    % The front body.
    % e2 to i2
    line([e2(1); i2(1)], [e2(2); i2(2)], [e2(3); i2(3)]);
    % f2 to the endpoint of the front spine
    %line([f2(1); 0], [f2(2); 0], [f2(3); 0]);
    line([f2(1); s_f(1)], [f2(2); s_f(2)], [f2(3); s_f(3)]);
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








