% 1. and 2. high points are about indetival, low points are different
% 3. low points are about identical, high points are different

clc;
clear ALL;
close ALL;
warning ('off','all');

% load parameter
Parameter

% get model
ueq_init = 1250;
Model_linearization

% init task
path_arr = strsplit(mfilename('fullpath'), {'/', '\'});
task_name = string(path_arr(end-1));
disp('running ' + task_name);

% set extra variables
task_params = struct;
task_params.voltage_high = ueq;
task_params.voltage_low = ueq - 100; %10, 100, 1000
task_params.voltage_period = 5;
task_params.voltage_delay = 2.5;
task_params.voltage_duty = 50;
task_params.fore = 0.1;

% run simulation
simOut = sim('DE_LBS_mass_5', 'SimulationMode', 'normal');