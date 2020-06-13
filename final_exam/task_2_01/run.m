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

% RUN 1
task_params.u1 = 0;
task_params.u2 = 1;
task_params.J_max = 2;
task_params.epsilon = 5;

simOut = simulate('SMAWing_2_01', do_rerun, 'v1');
u2_v1_time = simOut.get('time');
u2_v1_ref = simOut.get('ref');
u2_v1_theta_1 = simOut.get('theta_1');
u2_v1_theta_2 = simOut.get('theta_2');

disp("part 1 finished");

% RUN 2
task_params.u1 = 0;
task_params.u2 = 1;
task_params.J_max = 2;
task_params.epsilon = 10;

simOut = simulate('SMAWing_2_01', do_rerun, 'v2');
u2_v2_time = simOut.get('time');
u2_v2_ref = simOut.get('ref');
u2_v2_theta_1 = simOut.get('theta_1');
u2_v2_theta_2 = simOut.get('theta_2');

disp("part 2 finished");

% RUN 3
task_params.u1 = 0;
task_params.u2 = 1;
task_params.J_max = 2;
task_params.epsilon = 25;

simOut = simulate('SMAWing_2_01', do_rerun, 'v3');
u2_v3_time = simOut.get('time');
u2_v3_ref = simOut.get('ref');
u2_v3_theta_1 = simOut.get('theta_1');
u2_v3_theta_2 = simOut.get('theta_2');

disp("part 3 finished");

% RUN 4
task_params.u1 = 0;
task_params.u2 = 1;
task_params.J_max = 2;
task_params.epsilon = 50;

simOut = simulate('SMAWing_2_01', do_rerun, 'v4');
u2_v4_time = simOut.get('time');
u2_v4_ref = simOut.get('ref');
u2_v4_theta_1 = simOut.get('theta_1');
u2_v4_theta_2 = simOut.get('theta_2');

disp("part 4 finished");

% RUN 1
task_params.u1 = 1;
task_params.u2 = 0;
task_params.J_max = 2;
task_params.epsilon = 5;

simOut = simulate('SMAWing_2_01', do_rerun, 'v5');
u1_v1_time = simOut.get('time');
u1_v1_ref = simOut.get('ref');
u1_v1_theta_1 = simOut.get('theta_1');
u1_v1_theta_2 = simOut.get('theta_2');

disp("part 5 finished");

% RUN 2
task_params.u1 = 1;
task_params.u2 = 0;
task_params.J_max = 2;
task_params.epsilon = 10;

simOut = simulate('SMAWing_2_01', do_rerun, 'v6');
u1_v2_time = simOut.get('time');
u1_v2_ref = simOut.get('ref');
u1_v2_theta_1 = simOut.get('theta_1');
u1_v2_theta_2 = simOut.get('theta_2');

disp("part 6 finished");

% RUN 3
task_params.u1 = 1;
task_params.u2 = 0;
task_params.J_max = 2;
task_params.epsilon = 25;

simOut = simulate('SMAWing_2_01', do_rerun, 'v7');
u1_v3_time = simOut.get('time');
u1_v3_ref = simOut.get('ref');
u1_v3_theta_1 = simOut.get('theta_1');
u1_v3_theta_2 = simOut.get('theta_2');

disp("part 7 finished");

% RUN 4
task_params.u1 = 1;
task_params.u2 = 0;
task_params.J_max = 2;
task_params.epsilon = 50;

simOut = simulate('SMAWing_2_01', do_rerun, 'v8');
u1_v4_time = simOut.get('time');
u1_v4_ref = simOut.get('ref');
u1_v4_theta_1 = simOut.get('theta_1');
u1_v4_theta_2 = simOut.get('theta_2');

disp("part 8 finished");

% PLOT
paw({u2_v1_time, u2_v1_time, u2_v2_time, u2_v3_time, u2_v4_time}, {u2_v1_ref, u2_v1_theta_2, u2_v2_theta_2, u2_v3_theta_2, u2_v4_theta_2}, {'theta_{2,ref}', 'theta_{2,\epsilon=5}', 'theta_{2,\epsilon=10}', 'theta_{2,\epsilon=25}', 'theta_{2,\epsilon=50}'}, 'time [s]', 'theta', task_name, 'sliding_mode_u2_variation', plot_path, true, true, {':', '', '', '', ''}, 'southwest');
paw({u2_v1_time, u2_v1_time, u2_v2_time, u2_v3_time, u2_v4_time}, {u2_v1_ref, u2_v1_theta_2, u2_v2_theta_2, u2_v3_theta_2, u2_v4_theta_2}, {'theta_{2,ref}', 'theta_{2,\epsilon=5}', 'theta_{2,\epsilon=10}', 'theta_{2,\epsilon=25}', 'theta_{2,\epsilon=50}'}, 'time [s]', 'theta', task_name, 'sliding_mode_u2_variation_no_legend', plot_path, false, true, {':', '', '', '', ''}, 'southwest');

paw({u1_v1_time, u1_v1_time, u1_v2_time, u1_v3_time, u1_v4_time}, {u1_v1_ref, u1_v1_theta_1, u1_v2_theta_1, u1_v3_theta_1, u1_v4_theta_1}, {'theta_{1,ref}', 'theta_{1,\epsilon=5}', 'theta_{1,\epsilon=10}', 'theta_{1,\epsilon=25}', 'theta_{1,\epsilon=50}'}, 'time [s]', 'theta', task_name, 'sliding_mode_u1_variation', plot_path, true, true, {':', '', '', '', ''}, 'southwest');
paw({u1_v1_time, u1_v1_time, u1_v2_time, u1_v3_time, u1_v4_time}, {u1_v1_ref, u1_v1_theta_1, u1_v2_theta_1, u1_v3_theta_1, u1_v4_theta_1}, {'theta_{1,ref}', 'theta_{1,\epsilon=5}', 'theta_{1,\epsilon=10}', 'theta_{1,\epsilon=25}', 'theta_{1,\epsilon=50}'}, 'time [s]', 'theta', task_name, 'sliding_mode_u1_variation_no_legend', plot_path, false, true, {':', '', '', '', ''}, 'southwest');
