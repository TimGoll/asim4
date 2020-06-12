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

% ------------------------

task_params.init_theta1 = 0;
task_params.init_theta2 = 0;
task_params.init_TE = 293;
task_params.u1 = 1;
task_params.u2 = 0;

% run simulation
simOut = simulate('SMAWing_4_01', do_rerun, 'v1');
u1_v1_time = simOut.get('time');
u1_v1_theta1ref = simOut.get('theta1_ref');
u1_v1_theta2ref = simOut.get('theta2_ref');
u1_v1_theta1 = simOut.get('theta_1');
u1_v1_theta2 = simOut.get('theta_2');

disp("finished number 1");

% ------------------------

task_params.init_theta1 = 0;
task_params.init_theta2 = 0;
task_params.init_TE = 313;
task_params.u1 = 1;
task_params.u2 = 0;

simOut = simulate('SMAWing_4_01', do_rerun, 'v2');
u1_v2_time = simOut.get('time');
u1_v2_theta1ref = simOut.get('theta1_ref');
u1_v2_theta2ref = simOut.get('theta2_ref');
u1_v2_theta1 = simOut.get('theta_1');
u1_v2_theta2 = simOut.get('theta_2');

disp("finished number 2");

% ------------------------

task_params.init_theta1 = 0;
task_params.init_theta2 = 0;
task_params.init_TE = 333;
task_params.u1 = 1;
task_params.u2 = 0;

simOut = simulate('SMAWing_4_01', do_rerun, 'v3');
u1_v3_time = simOut.get('time');
u1_v3_theta1ref = simOut.get('theta1_ref');
u1_v3_theta2ref = simOut.get('theta2_ref');
u1_v3_theta1 = simOut.get('theta_1');
u1_v3_theta2 = simOut.get('theta_2');

disp("finished number 3");

% ------------------------

task_params.init_theta1 = 0;
task_params.init_theta2 = 0;
task_params.init_TE = 273;
task_params.u1 = 1;
task_params.u2 = 0;

simOut = simulate('SMAWing_4_01', do_rerun, 'v4');
u1_v4_time = simOut.get('time');
u1_v4_theta1ref = simOut.get('theta1_ref');
u1_v4_theta2ref = simOut.get('theta2_ref');
u1_v4_theta1 = simOut.get('theta_1');
u1_v4_theta2 = simOut.get('theta_2');

disp("finished number 4");

% ------------------------

task_params.init_theta1 = 0.0001;
task_params.init_theta2 = 0.0001;
task_params.init_TE = 293;
task_params.u1 = 1;
task_params.u2 = 0;

simOut = simulate('SMAWing_4_01', do_rerun, 'v5');
u1_v5_time = simOut.get('time');
u1_v5_theta1ref = simOut.get('theta1_ref');
u1_v5_theta2ref = simOut.get('theta2_ref');
u1_v5_theta1 = simOut.get('theta_1');
u1_v5_theta2 = simOut.get('theta_2');

disp("finished number 5");

% ------------------------

task_params.init_theta1 = 0.001;
task_params.init_theta2 = 0.001;
task_params.init_TE = 293;
task_params.u1 = 1;
task_params.u2 = 0;

simOut = simulate('SMAWing_4_01', do_rerun, 'v6');
u1_v6_time = simOut.get('time');
u1_v6_theta1ref = simOut.get('theta1_ref');
u1_v6_theta2ref = simOut.get('theta2_ref');
u1_v6_theta1 = simOut.get('theta_1');
u1_v6_theta2 = simOut.get('theta_2');

disp("finished number 6");

% ------------------------

task_params.init_theta1 = 0.01;
task_params.init_theta2 = 0.01;
task_params.init_TE = 293;
task_params.u1 = 1;
task_params.u2 = 0;

simOut = simulate('SMAWing_4_01', do_rerun, 'v7');
u1_v7_time = simOut.get('time');
u1_v7_theta1ref = simOut.get('theta1_ref');
u1_v7_theta2ref = simOut.get('theta2_ref');
u1_v7_theta1 = simOut.get('theta_1');
u1_v7_theta2 = simOut.get('theta_2');

disp("finished number 7");

% ------------------------
% ------------------------

task_params.init_theta1 = 0;
task_params.init_theta2 = 0;
task_params.init_TE = 293;
task_params.u1 = 0;
task_params.u2 = 1;

% run simulation
simOut = simulate('SMAWing_4_01', do_rerun, 'v8');
u2_v1_time = simOut.get('time');
u2_v1_theta1ref = simOut.get('theta1_ref');
u2_v1_theta2ref = simOut.get('theta2_ref');
u2_v1_theta1 = simOut.get('theta_1');
u2_v1_theta2 = simOut.get('theta_2');

disp("finished number 8");

% ------------------------

task_params.init_theta1 = 0;
task_params.init_theta2 = 0;
task_params.init_TE = 313;
task_params.u1 = 0;
task_params.u2 = 1;

simOut = simulate('SMAWing_4_01', do_rerun, 'v9');
u2_v2_time = simOut.get('time');
u2_v2_theta1ref = simOut.get('theta1_ref');
u2_v2_theta2ref = simOut.get('theta2_ref');
u2_v2_theta1 = simOut.get('theta_1');
u2_v2_theta2 = simOut.get('theta_2');

disp("finished number 9");

% ------------------------

task_params.init_theta1 = 0;
task_params.init_theta2 = 0;
task_params.init_TE = 333;
task_params.u1 = 0;
task_params.u2 = 1;

simOut = simulate('SMAWing_4_01', do_rerun, 'v10');
u2_v3_time = simOut.get('time');
u2_v3_theta1ref = simOut.get('theta1_ref');
u2_v3_theta2ref = simOut.get('theta2_ref');
u2_v3_theta1 = simOut.get('theta_1');
u2_v3_theta2 = simOut.get('theta_2');

disp("finished number 10");

% ------------------------

task_params.init_theta1 = 0;
task_params.init_theta2 = 0;
task_params.init_TE = 273;
task_params.u1 = 0;
task_params.u2 = 1;

simOut = simulate('SMAWing_4_01', do_rerun, 'v11');
u2_v4_time = simOut.get('time');
u2_v4_theta1ref = simOut.get('theta1_ref');
u2_v4_theta2ref = simOut.get('theta2_ref');
u2_v4_theta1 = simOut.get('theta_1');
u2_v4_theta2 = simOut.get('theta_2');

disp("finished number 11");

% ------------------------

task_params.init_theta1 = 0.0001;
task_params.init_theta2 = 0.0001;
task_params.init_TE = 293;
task_params.u1 = 0;
task_params.u2 = 1;

simOut = simulate('SMAWing_4_01', do_rerun, 'v12');
u2_v5_time = simOut.get('time');
u2_v5_theta1ref = simOut.get('theta1_ref');
u2_v5_theta2ref = simOut.get('theta2_ref');
u2_v5_theta1 = simOut.get('theta_1');
u2_v5_theta2 = simOut.get('theta_2');

disp("finished number 12");

% ------------------------

task_params.init_theta1 = 0.001;
task_params.init_theta2 = 0.001;
task_params.init_TE = 293;
task_params.u1 = 0;
task_params.u2 = 1;

simOut = simulate('SMAWing_4_01', do_rerun, 'v13');
u2_v6_time = simOut.get('time');
u2_v6_theta1ref = simOut.get('theta1_ref');
u2_v6_theta2ref = simOut.get('theta2_ref');
u2_v6_theta1 = simOut.get('theta_1');
u2_v6_theta2 = simOut.get('theta_2');

disp("finished number 13");

% ------------------------

task_params.init_theta1 = 0.01;
task_params.init_theta2 = 0.01;
task_params.init_TE = 293;
task_params.u1 = 0;
task_params.u2 = 1;

simOut = simulate('SMAWing_4_01', do_rerun, 'v14');
u2_v7_time = simOut.get('time');
u2_v7_theta1ref = simOut.get('theta1_ref');
u2_v7_theta2ref = simOut.get('theta2_ref');
u2_v7_theta1 = simOut.get('theta_1');
u2_v7_theta2 = simOut.get('theta_2');

disp("finished number 14");

% ------------------------



paw({u1_v1_time, u1_v1_time, u1_v2_time, u1_v3_time}, {u1_v1_theta1ref, u1_v1_theta1, u1_v2_theta1, u1_v3_theta1}, {'theta_{1,ref}', 'theta_{1,T=293K}', 'theta_{1,T=313K}', 'theta_{1,T=333K}'}, 'time [s]', 'theta', task_name, 'theta1_u1_TE_with_noise_comparison', plot_path, true, true, {':', '', '', ''}, 'southwest');
paw({u1_v1_time, u1_v1_time, u1_v5_time, u1_v6_time}, {u1_v1_theta1ref, u1_v1_theta1, u1_v5_theta1, u1_v6_theta1}, {'theta_{1,ref}', 'theta_{1,\tau=0m}', 'theta_{1,\tau=0.0001m}', 'theta_{1,\tau=0.001m}'}, 'time [s]', 'theta', task_name, 'theta1_u1_tau_with_noise_comparison', plot_path, true, true, {':', '', '', ''}, 'southwest');

paw({u2_v1_time, u2_v1_time, u2_v2_time, u2_v3_time}, {u2_v1_theta2ref, u2_v1_theta2, u2_v2_theta2, u2_v3_theta2}, {'theta_{2,ref}', 'theta_{2,T=293K}', 'theta_{2,T=313K}', 'theta_{2,T=333K}'}, 'time [s]', 'theta', task_name, 'theta2_u2_TE_with_noise_comparison', plot_path, true, true, {':', '', '', ''}, 'southwest');
paw({u2_v1_time, u2_v1_time, u2_v5_time, u2_v6_time}, {u2_v1_theta2ref, u2_v1_theta2, u2_v5_theta2, u2_v6_theta2}, {'theta_{2,ref}', 'theta_{2,\tau=0m}', 'theta_{2,\tau=0.0001m}', 'theta_{2,\tau=0.001m}'}, 'time [s]', 'theta', task_name, 'theta2_u2_tau_with_noise_comparison', plot_path, true, true, {':', '', '', ''}, 'southwest');

paw({u1_v1_time, u1_v1_time, u1_v2_time, u1_v3_time}, {u1_v1_theta1ref, u1_v1_theta1, u1_v2_theta1, u1_v3_theta1}, {'theta_{1,ref}', 'theta_{1,T=293K}', 'theta_{1,T=313K}', 'theta_{1,T=333K}'}, 'time [s]', 'theta', task_name, 'theta1_u1_TE_with_noise_comparison_no_legend', plot_path, false, true, {':', '', '', ''}, 'southwest');
paw({u1_v1_time, u1_v1_time, u1_v5_time, u1_v6_time}, {u1_v1_theta1ref, u1_v1_theta1, u1_v5_theta1, u1_v6_theta1}, {'theta_{1,ref}', 'theta_{1,\tau=0m}', 'theta_{1,\tau=0.0001m}', 'theta_{1,\tau=0.001m}'}, 'time [s]', 'theta', task_name, 'theta1_u1_tau_with_noise_comparison_no_legend', plot_path, false, true, {':', '', '', ''}, 'southwest');

paw({u2_v1_time, u2_v1_time, u2_v2_time, u2_v3_time}, {u2_v1_theta2ref, u2_v1_theta2, u2_v2_theta2, u2_v3_theta2}, {'theta_{2,ref}', 'theta_{2,T=293K}', 'theta_{2,T=313K}', 'theta_{2,T=333K}'}, 'time [s]', 'theta', task_name, 'theta2_u2_TE_with_noise_comparison_no_legend', plot_path, false, true, {':', '', '', ''}, 'southwest');
paw({u2_v1_time, u2_v1_time, u2_v5_time, u2_v6_time}, {u2_v1_theta2ref, u2_v1_theta2, u2_v5_theta2, u2_v6_theta2}, {'theta_{2,ref}', 'theta_{2,\tau=0m}', 'theta_{2,\tau=0.0001m}', 'theta_{2,\tau=0.001m}'}, 'time [s]', 'theta', task_name, 'theta2_u2_tau_with_noise_comparison_no_legend', plot_path, false, true, {':', '', '', ''}, 'southwest');

