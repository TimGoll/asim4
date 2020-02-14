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
%task_params.I = 1.2;

% run simulation
simOut = simulate('SMAWing_02', do_rerun);
time = simOut.get('time');
J_SMA_1A = simOut.get('J_SMA_1A');
J_SMA_1B = simOut.get('J_SMA_1B');
J_SMA_2A = simOut.get('J_SMA_2A');
J_SMA_2B = simOut.get('J_SMA_2B');
theta_1 = simOut.get('theta_1');
theta_2 = simOut.get('theta_2');

paw({time, time, time, time}, {J_SMA_1A, J_SMA_1B, J_SMA_2A, J_SMA_2B}, {'J_{SMA,1A}', 'J_{SMA,1B}', 'J_{SMA,2A}', 'J_{SMA,2B}'}, 'time [s]', 'J_{SMA} [W]', task_name, 'J_SMA_1_and_2', plot_path, true, true,{'--','',':','-.'},'southwest');
paw({time, time}, {J_SMA_1A, J_SMA_1B}, {'J_{SMA,1A}', 'J_{SMA,1B}'}, 'time [s]', 'J_{SMA} [W]', task_name, 'J_SMA_1_a_and_b', plot_path, true, true,{'--',''},'southwest');
paw({time, time}, {J_SMA_2A, J_SMA_2B}, {'J_{SMA,2A}', 'J_{SMA,2B}'}, 'time [s]', 'J_{SMA} [W]', task_name, 'J_SMA_2_a_and_b', plot_path, true, true,{'--',''},'southwest');
paw({time, time}, {theta_1, theta_2}, {'theta_1', 'theta_2'}, 'time [s]', 'theta', task_name, 'theta_1_and_2', plot_path, true, true,{'',''},'southwest');
paw({time, time}, {theta_1}, {'theta_1'}, 'time [s]', 'theta', task_name, 'theta_1', plot_path, true, true,{''},'southwest');
paw({time, time}, {theta_2}, {'theta_2'}, 'time [s]', 'theta', task_name, 'theta_2', plot_path, true, true,{''},'southwest');
