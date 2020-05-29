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

p_c = 0.3;
T_c = 0.874;

%task_params.P = 0.3;
%task_params.I = 0;
%task_params.D = 0;

%task_params.P = 0.45 * p_c;
%task_params.I = 0.54 * p_c / T_c;
%task_params.D = 0;

task_params.P = 0.6 * p_c;
task_params.I = 0.4 * p_c / T_c;
task_params.D = 1 * p_c * T_c;
%task_params.I = 0;

disp("P: " + task_params.P);
disp("I: " + task_params.I);
disp("D: " + task_params.D);

% run simulation
simOut = simulate('SMAWing_04b_u1_PID', do_rerun);
time = simOut.get('time');
u1 = simOut.get('u1');
u2 = simOut.get('u2');
theta_1 = simOut.get('theta_1');
theta_2 = simOut.get('theta_2');
theta_ref = simOut.get('theta_ref');

paw({time, time}, {theta_1, theta_ref}, {'theta_1', 'theta_{1,ref}'}, 'time [s]', 'theta', task_name, 'ziegler_nichols_theta1_controller', plot_path, true, true, {'', ''}, 'southwest');
paw({time}, {u2}, {'u_1'}, 'time [s]', 'u [W]', task_name, 'ziegler_nichols_u1_controlled', plot_path, true, true, {''}, 'southwest');