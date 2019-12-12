clc;
clear ALL;
close ALL;
warning ('off','all');

% load parameter
Parameter_PC2;

% init task
path_arr = strsplit(mfilename('fullpath'), {'/', '\'});
task_name = string(path_arr(end-1));
disp('running exam_' + task_name);

% set extra variables
task_params = struct;
%task_params.I = 1.2;

% run simulation
simOut = sim('SMAWing', 'SimulationMode', 'normal');
