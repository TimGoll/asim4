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


% PARAMS u1
tau_star = 0.2;

b_0 = 165.81;
a_1 = 1.351;
a_0 = 0.4741;

task_params.b_0_1 = b_0;
task_params.a_0_1 = a_0;
task_params.a_1_1 = a_1;

task_params.KP1 = 2 * a_1 / (b_0 * tau_star);
task_params.KI1 = 2 * a_0 / (b_0 * tau_star);
task_params.KD1 = 1 / (b_0 * tau_star);

% PARAMS u2
delta = 0.707;
                % noisy  - sine   - jumps
k = 586.9;      % 586.9  - 675.49 -
p1 = 11.89;     % 11.89  - 11.67  -
p2 = 0.3653;    % 0.3653 - 0.4316 -

task_params.b_0_2 = k;
task_params.a_0_2 = p1*p2;
task_params.a_1_2 = p1+p2;

task_params.KP2 = p1^2 / (4 * k * delta^2);
task_params.KI2 = p2 * p1^2 / (4 * k * delta^2);
task_params.KD2 = 0;



% run simulation
simOut = simulate('SMAWing_06_PID', do_rerun);
time = simOut.get('time');
u1 = simOut.get('u1');
u2 = simOut.get('u2');
theta_1 = simOut.get('theta_1');
theta_2 = simOut.get('theta_2');
theta_ref = simOut.get('theta_ref'); 
theta_ref_1 = simOut.get('theta_ref_1'); 

paw({time}, {theta_2}, {'theta_2'}, 'time [s]', 'theta_2', task_name, 'flying_bat_theta_2', plot_path, true, true, {''}, 'southwest');
paw({time}, {u2}, {'u_2'}, 'time [s]', 'u [W]', task_name, 'flying_bat_u2', plot_path, true, true, {''}, 'southwest');
paw({time , time}, {theta_2, theta_ref}, {'theta_2','theta_{ref}'}, 'time [s]', 'theta', task_name, 'flying_bat_theta2_theta_2_ref', plot_path, true, true, {'',''}, 'southwest');
paw({time}, {theta_1}, {'theta_1'}, 'time [s]', 'theta_1', task_name, 'flying_bat_theta_1', plot_path, true, true, {''}, 'southwest');
paw({time}, {u1}, {'u_1'}, 'time [s]', 'u [W]', task_name, 'flying_bat_u1', plot_path, true, true, {''}, 'southwest');
paw({time , time}, {theta_1, theta_ref_1}, {'theta_1','theta_{ref}'}, 'time [s]', 'theta', task_name, 'flying_bat_theta1_theta_1_ref', plot_path, true, true, {'',''}, 'southwest');
paw({time , time, time, time}, {theta_1, theta_ref_1, theta_2, theta_ref}, {'theta_1','theta_{1,ref}','theta_2','theta_{2,ref}'}, 'time [s]', 'theta', task_name, 'flying_bat_theta1_theta_2', plot_path, true, true, {'','','',''}, 'southwest');
