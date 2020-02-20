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

task_params.noise_1 = 0;
task_params.noise_1_f = 0;
task_params.noise_1_start = 0;

task_params.noise_2 = 1;
task_params.noise_2_f = 1;
task_params.noise_2_start = 0;
task_params.noise_2_start_b = 8;

% run simulation
% MODEL BASED PID
delta = 0.707;
                % noisy  - sine   - jumps
k = 586.9;      % 586.9  - 675.49 -
p1 = 11.89;     % 11.89  - 11.67  -
p2 = 0.3653;    % 0.3653 - 0.4316 -

task_params.P = p1^2 / (4 * k * delta^2);
task_params.I = p2 * p1^2 / (4 * k * delta^2);
task_params.D = 0;

simOut_t3 = simulate('SMAWing_03_PID', do_rerun);
time_t3 = simOut_t3.get('time');
theta_2_t3 = simOut_t3.get('theta_2');
theta_ref_t3 = simOut_t3.get('theta_ref');

% ZIEGLER NICHOLS BASED PID
p_c = 0.6;
T_c = 0.26;

task_params.P = 0.6 * p_c;
task_params.I = 1.2 * p_c / T_c;
task_params.D = 0.075 * p_c * T_c;

simOut_t4 = simulate('SMAWing_04b_PID', do_rerun);
time_t4 = simOut_t4.get('time');
theta_2_t4 = simOut_t4.get('theta_2');
theta_ref_t4 = simOut_t4.get('theta_ref');

paw({time_t3, time_t4, time_t3}, {theta_ref_t3, theta_2_t4, theta_2_t3}, {'theta_{2,ref}', 'theta_{2,ZiNi}', 'theta_{2,model}'}, 'time [s]', 'theta', task_name, 'ziegler_nichols_theta2_controlled', plot_path, true, true, {':', '', ''}, 'southwest');
