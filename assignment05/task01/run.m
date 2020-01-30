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
tau_star = 0.015;
N = 20;

mode = 'forward euler';

% set extra variables
task_params = struct;
task_params.I = a_0 / (tau_star * b_0);
task_params.D = 0;
task_params.P = 1 / (tau_star * b_0);

task_params.sine_A = 0.0005;
task_params.sine_f = 1;
task_params.sine_bias = 0.103;

task_params.J_max = 0.25;
task_params.epsilon = 0.00005;

task_params.Ts = tau_star / N;

simOut = sim('SMA_spring', 'SimulationMode', 'normal');
time = simOut.get('t');
disp = simOut.get('l');
input = simOut.get('input');

paw({time_sliding, time_sliding}, {disp, input}, {'displacement', 'input'}, 'time [s]', 'diplacement [m]', task_name, 'pid' + mode, plot_path, true, true);

