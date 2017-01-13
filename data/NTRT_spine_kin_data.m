% NTRT_spine_kin_data.m
% A helper script file that takes in data from 
% the NASA Tensegrity Robotics Toolkit simulations of the ULTRA Spine
% in kinematic bending.
%   Andrew P. Sabelhaus
%   Berkeley Emergent Space Tensegrities Lab

% Clean up the workspace
clear all;
close all;
clc;

% Add the path to the hline and vline functions.
% @TODO make this more robust!
%addpath('./hline_vline');

% The log file base path:
% (hard-coded to Drew's computer)
logfile_base = '~/NTRTsim_logs/AppSpineKinematicsTest_';
% The timestamp for the file to read in
% Copied from the name of the log file itself
% First run with bending and a fixed :
%logfile_timestamp = '01112017_141027';
% With a much slower sampling rate, and the controller turning on at 3 sec:
logfile_timestamp = '01122017_172522_edited';
% A flag to control making plots or not
make_plots = 1;

% Call the parser function
s = parseNTRTCompoundRigidData(logfile_base, logfile_timestamp, make_plots);
