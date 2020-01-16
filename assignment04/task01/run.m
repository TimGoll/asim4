clc;
clear ALL;
close ALL;
warning ('off','all');

% load parameter
Parameter_PC2;

% init task
path_arr = strsplit(mfilename('fullpath'), {'/', '\'});
task_name = string(path_arr(end-1));
disp('running ' + task_name);

path_arr(end) = [];
path_arr(end) = [];
path_arr = [path_arr 'plots'];
plot_path = strjoin(path_arr, '/');

% internal params
a_0 = 14.93;
b_0 = -0.2891;
tau_star = 0.02;

% set extra variables
task_params = struct;
task_params.I = a_0 / (tau_star * b_0);
task_params.D = 0;
task_params.P = 1 / (tau_star * b_0);

task_params.sine_A = 0.0005;
task_params.sine_f = 1;
task_params.sine_bias = 0.103;

task_params.J_max = 0.25;
task_params.epsilon = 0.005;

% run simulation
simOut = sim('SMA_spring_pid', 'SimulationMode', 'normal');
time_pid = simOut.get('t');
ref = simOut.get('ref');
disp_pid = simOut.get('l');

simOut = sim('SMA_spring_sliding', 'SimulationMode', 'normal');
time_sliding = simOut.get('t');
disp_slide = simOut.get('l');

paw({time_pid, time_pid, time_sliding}, {ref, disp_pid, disp_slide}, {'reference', 'pid', 'sliding mode'}, 'time [s]', 'diplacement [m]', task_name, 'pid_slide', plot_path, true, true);

