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
task_params.u2 = 1;

task_params.init_theta1 = 0;
task_params.init_theta2 = 0;
task_params.init_TE = 293;

% pid values
tau_star = 0.2;

b_0 = 165.81;
a_1 = 1.351;
a_0 = 0.4741;

task_params.P1 = 2 * a_1 / (b_0 * tau_star);
task_params.I1 = 2 * a_0 / (b_0 * tau_star);
task_params.D1 = 1 / (b_0 * tau_star);

delta_2 = 0.707;

k_2 = 586.9;
p1_2 = 11.89;
p2_2 = 0.3653;

task_params.P2 = p1_2^2 / (4 * k_2 * delta_2^2);
task_params.I2 = p2_2 * p1_2^2 / (4 * k_2 * delta_2^2);
task_params.D2 = 0;

% run simulation
simOut = simulate('SMAWing_4_01', do_rerun, 'v1');
v1_time = simOut.get('time');
v1_theta1ref = simOut.get('theta1_ref');
v1_theta2ref = simOut.get('theta2_ref');
v1_theta1 = simOut.get('theta_1');
v1_theta2 = simOut.get('theta_2');

task_params.init_theta1 = 0;
task_params.init_theta2 = 0;
task_params.init_TE = 313;

simOut = simulate('SMAWing_4_01', do_rerun, 'v2');
v2_time = simOut.get('time');
v2_theta1ref = simOut.get('theta1_ref');
v2_theta2ref = simOut.get('theta2_ref');
v2_theta1 = simOut.get('theta_1');
v2_theta2 = simOut.get('theta_2');

task_params.init_theta1 = 0.001;
task_params.init_theta2 = 0.001;
task_params.init_TE = 313;

simOut = simulate('SMAWing_4_01', do_rerun, 'v3');
v3_time = simOut.get('time');
v3_theta1ref = simOut.get('theta1_ref');
v3_theta2ref = simOut.get('theta2_ref');
v3_theta1 = simOut.get('theta_1');
v3_theta2 = simOut.get('theta_2');

paw({v1_time, v1_time, v2_time, v3_time}, {v1_theta1ref, v1_theta1, v2_theta1, v3_theta1}, {'theta_{1,ref}', 'theta_{1,normal}', 'theta_{1,noise(TE)}', 'theta_{1,noise(all)}'}, 'time [s]', 'theta', task_name, 'theta1_with_noise_comparison', plot_path, true, true, {':', '', '', ''}, 'southwest');
paw({v1_time, v1_time, v2_time, v3_time}, {v1_theta2ref, v1_theta2, v2_theta2, v3_theta2}, {'theta_{2,ref}', 'theta_{2,normal}', 'theta_{2,noise(TE)}', 'theta_{1,noise(all)}'}, 'time [s]', 'theta', task_name, 'theta2_with_noise_comparison', plot_path, true, true, {':', '', '', ''}, 'southwest');
