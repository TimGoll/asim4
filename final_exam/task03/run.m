clc;
clear ALL;
close ALL;
warning ('off','all');

do_rerun = false;

% load parameter
Parameter_PC2;

disp(mfilename('fullpath'));

% init task
path_arr = strsplit(mfilename('fullpath'), {'/', '\'});
task_name = string(path_arr(end-1));
disp('running exam_' + task_name);

path_arr(end) = [];
path_arr(end) = [];
path_arr = [path_arr 'plots'];
plot_path = strjoin(path_arr, '/');

% set extra variables
task_params = struct;
task_params.u1 = 0;
task_params.u2 = 1;

% run simulation
simOut = simulate('SMAWing_03', do_rerun);
time = simOut.get('time');
u1 = simOut.get('u1');
u2 = simOut.get('u2');
theta_1 = simOut.get('theta_1');
theta_2 = simOut.get('theta_2');

paw({time, time, time}, {u2, theta_1, theta_2}, {'u_2', 'theta_1', 'theta_2'}, 'time [s]', 'u [W] / theta', task_name, 'u_vs_tehat', plot_path, true, true, {'', ':', ':'}, 'northwest');
