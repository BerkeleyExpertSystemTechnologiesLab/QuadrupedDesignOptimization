function [ s ] = parseNTRTCompoundRigidData( logfile_base, logfile_timestamp, make_plots )
%parseNTRTCompoundRigidData.m
%   Parses and plots the data from a single run of the
%   NASA Tensegrity Robotics Toolkit's AppSpineKinematicsTest
%   Andrew P. Sabelhaus
%   Berkeley Emergent Space Tensegrities Lab
%   Jan. 11, 2017
%
%   @param[in] logfile_base, a string. Same string as is passed in to tgDataManager in NTRT.
%       For the spine kinematics test, this will be ~/NTRTsim_logs
%   @param[in] logfile_timestamp, also a string, of the timestamp that's used in the name of the logfiles.
%       See the log files themselves for information about the timestamp structure: it's both the date and time.
%   @param[in] make_plots, a flag that controls creation of graphs of the data or not
%   @retvar[out] s, a cell array will all the compound rigid body data nicely organized.

% First, construct the paths to the spine data.
s.path = strcat( logfile_base, logfile_timestamp, '.txt');

% The dimensions to use in csvread: 
% For n many vertebrae,
n = 6;

% There are 7 columns per compound body, 3 x position, 3 x orientation, and mass.
col = 7;
% Thus, with time as the first column, the total number of columns is
num_col = 1 + n*col;

% Call csvread:
% Data starts at the third row (row two.)
s.data = csvread( s.path, 2, 0);

% The number of samples is the number of rows that were read in.
num_samples = size(s.data, 1);

% Quick edit: it seems that an extra column exists in this data, since the
% NTRT data logger ends with a comma at the end.
s.data = s.data(:,1:end-1);

% Calculate the column indices for the x,y,z positions of each vertebrae.
% These are, respectively, the 1,2,3 columns out of the 7 per vertebra.
% Adjust over by 1 due to the time column at the front.
s.x_col = [2:col:num_col];
s.y_col = [3:col:num_col];
s.z_col = [4:col:num_col];

% Initialize the plot
figure;
hold on;

if( make_plots )
    % Track the data we'll create
    s.d = [];
    % Pick out the vectors of data for each 
    % The outer loop should be over the rows of the data, 
    % since we'll be plotting one position of the spine at at time.
    for i=1:num_samples
        % Put together the 2D matrix that's needed for plot_spine.
        % It is an xyz column vector for each vertebra.
        d = zeros(3, n);
        
        % Plug in the columns.
        for j=1:n
            % For example, X data is at the ith row and the x_col(j)-th column.
            d(:,j) = [s.data(i, s.x_col(j)); s.data(i, s.y_col(j)); ...
                s.data(i, s.z_col(j))];
        end
        
        % Save the data.
        s.d(:,:,i) = d;
        
        % Plot this sample.
        plot_spine(d);
    end
    
    title('Spine plot');
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    

end




