clc;
clear ALL;
close ALL;
warning ('off','all');

% load parameter
Parameter;

% init task
path_arr = strsplit(mfilename('fullpath'), {'/', '\'});
task_name = string(path_arr(end-1));
disp('running ' + task_name);

% set extra variables
task_params = struct;
task_params.I = 0;
task_params.D = 0;
task_params.P = 13e7;
task_params.type = 1;

% run simulation
simOut = sim('DE_mass', 'SimulationMode', 'normal');
%u = simOut.get('joule');
%y = simOut.get('displacement');
%t = simOut.get('time');
