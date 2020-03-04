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
task_params.J1 = 0;
task_params.J2 = 0;
task_params.u1 = 0;
task_params.u2 = 1;
task_params.J_max = 2;
task_params.epsilon = 1;

% run simulation
simOut = simulate('SMAWing_2_01', do_rerun);
time = simOut.get('time');
ref = simOut.get('ref');
theta_1 = simOut.get('theta_1');
theta_2 = simOut.get('theta_2');

paw({time, time}, {ref, theta_2}, {'theta_{2,ref}', 'theta_{2,pos}'}, 'time [s]', 'theta', task_name, 'sliding_mode_e=1', plot_path, true, true, {':', ''}, 'southwest');
