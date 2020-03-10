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

p_c_1 = 0.19;
T_c_1 = 1.144;

% TUNE 0
%task_params.P1 = 0.6 * p_c_1;
%task_params.I1 = 1.2 * p_c_1 / T_c_1;
%task_params.D1 = 0.075 * p_c_1 * T_c_1;

% TUNE 1
%task_params.P1 = 0.8 * p_c_1;
%task_params.I1 = 1.2 * p_c_1 / T_c_1;
%task_params.D1 = 0.2 * p_c_1 * T_c_1;

% TUNE 2
%task_params.P1 = 0.75 * p_c_1;
%task_params.I1 = 1.2 * p_c_1 / T_c_1;
%task_params.D1 = 0.3 * p_c_1 * T_c_1;

% TUNE 3
%task_params.P1 = 0.4 * p_c_1;
%task_params.I1 = 1.2 * p_c_1 / T_c_1;
%task_params.D1 = 0.1 * p_c_1 * T_c_1;

% TUNE 4
task_params.P1 = 0.1 * p_c_1;
task_params.I1 = 1.2 * p_c_1 / T_c_1;
task_params.D1 = 0.3 * p_c_1 * T_c_1;

p_c_2 = 0.6;
T_c_2 = 0.26;

task_params.P2 = 1 * p_c_2;
task_params.I2 = 1.2 * p_c_2 / T_c_2;
task_params.D2 = 0.25 * p_c_2 * T_c_2;

%task_params.P = 0.6 * p_c;
%task_params.I = 1.2 * p_c / T_c;
%task_params.D = 0.075 * p_c * T_c;

% run simulation
simOut = simulate('SMAWing_04_PID', do_rerun);
time = simOut.get('time');
u1 = simOut.get('u1');
u2 = simOut.get('u2');
theta_1 = simOut.get('theta_1');
theta_2 = simOut.get('theta_2');
theta_ref = simOut.get('theta_ref');

paw({time, time}, {theta_1, theta_ref}, {'theta_1', 'theta_{1,ref}'}, 'time [s]', 'theta', task_name, 'ziegler_nichols_theta1_pid_tune4', plot_path, true, true, {':', ''}, 'southwest');
paw({time}, {u1}, {'u_1'}, 'time [s]', 'u [W]', task_name, 'ziegler_nichols_u1_tune4', plot_path, true, true, {''}, 'southwest');