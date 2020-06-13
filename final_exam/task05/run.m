clc;
%clear ALL;
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
task_params.u1 = 0;
task_params.u2 = 1;

task_params.noise_1 = 0;
task_params.noise_1_f = 0;
task_params.noise_1_start = 0;

task_params.noise_2 = 1;
task_params.noise_2_f = 1;
task_params.noise_2_start = 0;
task_params.noise_2_start_b = 8;

% PARAMS u1
tau_star = 0.2;

b_0 = 165.81;
a_1 = 1.351;
a_0 = 0.4741;

task_params.b_0_1 = b_0;
task_params.a_0_1 = a_0;
task_params.a_1_1 = a_1;

task_params.P1 = 2 * a_1 / (b_0 * tau_star);
task_params.I1 = 2 * a_0 / (b_0 * tau_star);
task_params.D1 = 1 / (b_0 * tau_star);

% PARAMS u2
delta = 0.707;
                % noisy  - sine   - jumps
k = 586.9;      % 586.9  - 675.49 -
p1 = 11.89;     % 11.89  - 11.67  -
p2 = 0.3653;    % 0.3653 - 0.4316 -

task_params.b_0_2 = k;
task_params.a_0_2 = p1*p2;
task_params.a_1_2 = p1+p2;

task_params.P2 = p1^2 / (4 * k * delta^2);
task_params.I2 = p2 * p1^2 / (4 * k * delta^2);
task_params.D2 = 0;

% enable / disable
task_params.u1 = 1;
tasl_params.u2 = 0;

% run simulation
simOut = simulate('SMAWing_03_PID', do_rerun);
time = simOut.get('time');
u1 = simOut.get('u1');
u2 = simOut.get('u2');
theta_1 = simOut.get('theta_1');
theta_2 = simOut.get('theta_2');
theta1_ref = simOut.get('theta1_ref'); 
theta2_ref = simOut.get('theta2_ref');

%paw({time}, {theta_2}, {'theta_2'}, 'time [s]', 'theta', task_name, 'equilibrium_theta2_v2_PID_trajectory', plot_path, true, true, {''}, 'southwest');
%paw({time}, {u2}, {'u_2'}, 'time [s]', 'u [W]', task_name, 'equilibrium_u2_v2_noise_PID_step', plot_path, true, true, {''}, 'southwest');
%paw({time , time}, {theta_2, theta2_ref}, {'theta_2','theta_{2,ref}'}, 'time [s]', 'theta', task_name, 'equilibrium_theta2_thetaref_v2_PID_trajjectory', plot_path, true, true, {'',''}, 'southwest');

%paw({time}, {theta_1}, {'theta_1'}, 'time [s]', 'theta', task_name, 'equilibrium_theta1_v3_PID_trajectory', plot_path, true, true, {''}, 'southwest');
%paw({time}, {u1}, {'u_1'}, 'time [s]', 'u [W]', task_name, 'equilibrium_u1_v3_noise_PID_step', plot_path, true, true, {''}, 'southwest');
%paw({time , time}, {theta_1, theta1_ref}, {'theta_1','theta_{1,ref}'}, 'time [s]', 'theta', task_name, 'equilibrium_theta1_thetaref_v3_PID_trajectory', plot_path, true, true, {'',''}, 'southwest');

% change PID zo ZN system
p_c = 0.3;
T_c = 0.874;

task_params.P1 = 0.6 * p_c;
task_params.I1 = 0.4 * p_c / T_c;
task_params.D1 = 1 * p_c * T_c;

% run simulation
simOut_2 = simulate('SMAWing_03_PID', do_rerun);
time_2 = simOut_2.get('time');
u1_2 = simOut_2.get('u1');
u2_2 = simOut_2.get('u2');
theta_1_2 = simOut_2.get('theta_1');
theta_2_2 = simOut_2.get('theta_2');
theta1_ref_2 = simOut_2.get('theta1_ref'); 
theta2_ref_2 = simOut_2.get('theta2_ref');

%paw({time}, {theta_2}, {'theta_2'}, 'time [s]', 'theta', task_name, 'equilibrium_theta2_v2_PID_trajectory', plot_path, true, true, {''}, 'southwest');
%paw({time}, {u2}, {'u_2'}, 'time [s]', 'u [W]', task_name, 'equilibrium_u2_v2_noise_PID_step', plot_path, true, true, {''}, 'southwest');
%paw({time , time}, {theta_2, theta2_ref}, {'theta_2','theta_{2,ref}'}, 'time [s]', 'theta', task_name, 'equilibrium_theta2_thetaref_v2_PID_trajjectory', plot_path, true, true, {'',''}, 'southwest');

%paw({time_2}, {theta_1_2}, {'theta_1'}, 'time [s]', 'theta', task_name, 'equilibrium_theta1_zini_v3_PID_trajectory', plot_path, true, true, {''}, 'southwest');
%paw({time_2}, {u1_2}, {'u_1'}, 'time [s]', 'u [W]', task_name, 'equilibrium_u1_zini_v3_noise_PID_step', plot_path, true, true, {''}, 'southwest');
%paw({time_2 , time_2}, {theta_1_2, theta1_ref_2}, {'theta_1','theta_{1,ref}'}, 'time [s]', 'theta', task_name, 'equilibrium_theta1_zini_thetaref_v3_PID_trajectory', plot_path, true, true, {'',''}, 'southwest');

%paw({time_2 , time_2, time}, {theta1_ref_2, theta_1_2, theta_1}, {'theta_{1,ref}','theta_1_{ZiNi}','theta_1_{model}'}, 'time [s]', 'theta', task_name, 'equilibrium_theta1_thetaref_v3_comparison', plot_path, true, true, {':','',''}, 'southwest');