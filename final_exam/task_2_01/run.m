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

% run simulation
simOut = simulate('SMAWing_07_PID', do_rerun);
time_t7 = simOut.get('time');

%paw({time_t6, time_t7, time_t6}, {theta_ref_t6, theta_2_t7, theta_2_t6}, {'theta_{2,ref}', 'theta_{2,ZiNi}', 'theta_{2,model}'}, 'time [s]', 'theta', task_name, 'ziegler_nichols_theta2_controlled', plot_path, true, true, {':', '', ''}, 'southwest');
