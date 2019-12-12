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

% internal params
base_p = 13e7;
base_t = 3.166 - 3.1375;

% set extra variables
task_params = struct;
task_params.I = 1.2 * base_p / base_t;
task_params.D = 0.075 * base_p * base_t;
task_params.P = 0.6 * base_p;
task_params.type = 1;

% run simulation
simOut = sim('DE_mass', 'SimulationMode', 'normal');
