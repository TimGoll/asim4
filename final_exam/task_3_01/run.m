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

task_params.noise_1 = 0;
task_params.noise_1_f = 0;
task_params.noise_1_start = 0;
task_params.noise_1_start_b = 8;

task_params.noise_2 = 1;
task_params.noise_2_f = 1;
task_params.noise_2_start = 0;
task_params.noise_2_start_b = 8;

%delta_1 = 0.707;

%k_1 = 125.47;
%p1_1 = 2.77;
%p2_1 = 0.3659;

%task_params.P1 = p1_1^2 / (4 * k_1 * delta_1^2);
%task_params.I1 = p2_1 * p1_1^2 / (4 * k_1 * delta_1^2);
%task_params.I1 = 0;

tau_star = 0.2;

b_0 = 165.81;
a_1 = 1.351;
a_0 = 0.4741;

% TEST
%task_params.P1 = a_1 / (b_0 * tau_star);
%task_params.I1 = a_0 / (b_0 * tau_star);
%task_params.D1 = 1 / (b_0 * tau_star);

% TEST 2
task_params.P1 = 2 * a_1 / (b_0 * tau_star);
task_params.I1 = 2 * a_0 / (b_0 * tau_star);
task_params.D1 = 1 / (b_0 * tau_star);

disp("P: " + task_params.P1);
disp("I: " + task_params.I1);
disp("D: " + task_params.D1);

delta_2 = 0.707;
                  % noisy  - sine   - jumps
k_2 = 586.9;      % 586.9  - 675.49 -
p1_2 = 11.89;     % 11.89  - 11.67  -
p2_2 = 0.3653;    % 0.3653 - 0.4316 -

task_params.P2 = p1_2^2 / (4 * k_2 * delta_2^2);
task_params.I2 = p2_2 * p1_2^2 / (4 * k_2 * delta_2^2);
task_params.D2 = 0;
% 
tau_star_dis = 0.015;
N_dis = 10;
task_params.Ts_dis = tau_star_dis / N_dis;

% run simulation
simOut = simulate('SMAWing_3_01_PID', do_rerun);
time = simOut.get('time');
u1 = simOut.get('u1');
u2 = simOut.get('u2');
theta_1 = simOut.get('theta_1');
theta_1_dis = simOut.get('theta_1_dis'); 
theta_2 = simOut.get('theta_2');
theta_1_ref = simOut.get('theta1_ref');
theta_2_ref = simOut.get('theta2_ref');

paw({time}, {theta_1}, {'theta_1'}, 'time [s]', 'theta', task_name, 'equilibrium_theta1_discrete_controller_N=10', plot_path, true, true, {''}, 'southwest');
paw({time}, {u1}, {'u_1'}, 'time [s]', 'u [W]', task_name, 'equilibrium_u1_discrete_controller_N=10', plot_path, true, true, {''}, 'southwest');
paw({time, time, time}, {theta_1, theta_1_ref, theta_1_dis}, {'theta_1','theta_{1,ref}','theta_{1,dis}'}, 'time [s]', 'theta', task_name, 'equilibrium_theta1_discrete_controller_N=10_comparison', plot_path, true, true, {'','',''}, 'southeast');

%paw({time}, {theta_2}, {'theta_2'}, 'time [s]', 'theta', task_name, 'equilibrium_theta2_v2_PID_step', plot_path, true, true, {''}, 'southwest');
%paw({time}, {u2}, {'u_2'}, 'time [s]', 'u [W]', task_name, 'equilibrium_u2_v2_noise_PID_step', plot_path, true, true, {''}, 'southwest');
%paw({time, time}, {theta_2, theta_2_ref}, {'theta_2','theta_{2,ref}'}, 'time [s]', 'theta', task_name, 'equilibrium_theta2_v2_PID_step_ref', plot_path, true, true, {'',''}, 'southeast');
