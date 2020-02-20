clc;
clear ALL;
close ALL;
warning ('off','all');

do_rerun = true;

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
task_params.u1 = 1;
task_params.u2 = 0;

task_params.noise_1 = 1;
task_params.noise_1_f = 1;
task_params.noise_1_start = 0;
task_params.noise_1_start_b = 8;

task_params.noise_2 = 1;
task_params.noise_2_f = 1;
task_params.noise_2_start = 0;
task_params.noise_2_start_b = 8;

% run simulation
simOut = simulate('SMAWing_03', do_rerun);
time = simOut.get('time');
u1 = simOut.get('u1');
u2 = simOut.get('u2');
theta_1 = simOut.get('theta_1');
theta_2 = simOut.get('theta_2');
theta_ref = simOut.get('theta_ref');

paw({time}, {theta_1}, {'theta_1'}, 'time [s]', 'theta', task_name, 'equilibrium_theta1_v2_PID_step', plot_path, true, true, {''}, 'southwest');
paw({time}, {u1}, {'u_1'}, 'time [s]', 'u [W]', task_name, 'equilibrium_u1_v2_noise_PID_step', plot_path, true, true, {''}, 'southwest');
%paw({time, time}, {theta_2, theta_ref}, {'theta_2','theta_{ref}'}, 'time [s]', 'theta', task_name, 'equilibrium_theta1_v2_PID_step_ref', plot_path, true, true, {'',''}, 'southeast');
