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
task_params.u1 = 0;
task_params.u2 = 1;

p_c = 0.6;
T_c = 0.26;

%task_params.P = 0.45 * p_c;
%task_params.I = 0.54 * p_c / T_c;
%task_params.D = 0;

task_params.P = 0.6 * p_c;
task_params.I = 1.2 * p_c / T_c;
task_params.D = 0.075 * p_c * T_c;

                % noisy  - sine   - jumps
k = 586.9;      % 586.9  - 675.49 -
p1 = 11.89;     % 11.89  - 11.67  -
p2 = 0.3653;    % 0.3653 - 0.4316 -

task_params.b_0 = k;
task_params.a_0 = p1*p2;
task_params.a_1 = p1+p2;

% run simulation
simOut = simulate('SMAWing_07_PID', do_rerun);
time = simOut.get('time');
u1 = simOut.get('u1');
u2 = simOut.get('u2');
theta_1 = simOut.get('theta_1');
theta_2 = simOut.get('theta_2');
theta_ref = simOut.get('theta_ref'); 

paw({time}, {theta_2}, {'theta_2'}, 'time [s]', 'theta', task_name, 'equilibrium_theta1_v2_PID_trajectory', plot_path, true, true, {''}, 'southwest');
paw({time}, {u2}, {'u_2'}, 'time [s]', 'u [W]', task_name, 'equilibrium_u2_v2_noise_PID_step', plot_path, true, true, {''}, 'southwest');
paw({time , time}, {theta_2, theta_ref}, {'theta_2','theta_{ref}'}, 'time [s]', 'theta', task_name, 'equilibrium_theta1_thetaref_v2_PID_trajjectory', plot_path, true, true, {'',''}, 'southwest');
