function plot_spine( d )
%plot_spine Plots a straight-line approx of a spine on the current figure
%   Inputs: 
%       d is a 2D array of X,Y,Z positions at one instant in time for each vertebrae in a spine.
%           Has 3 rows, X,Y,Z, and n columns, for n vertebrae.

% Loop over the columns, and plot a line between each of them.
% By going off-by-1, we'll plot a line between the i and i+1 vertebrae.
for i=1:(size(d,2)-1)
    % Plot a line between these two points
    % d(i) is a column vector of the position of the ith vertebra
    line([d(1,i); d(1,i+1)], [d(2,i); d(2,i+1)], [d(3,i); d(3,i+1)]);
end

%title( strcat('Spine plot for ', num2str(size(d,2)), ' vertebrae') );
drawnow;


end

