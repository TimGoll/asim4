clc;
clear ALL;
close ALL;
warning ('off','all');

% load parameter
Parameter_PC2

% get model
ueq_init = 0;

% init task
path_arr = strsplit(mfilename('fullpath'), {'/', '\'});
task_name = string(path_arr(end-1));
disp('running ' + task_name);

% set extra variables
task_params = struct;
task_params.J = 0.125;
task_params.T = 293;
task_params.F = 0;
task_params.noise = 0.1; %0.02 
task_params.noise_f = 20;
task_params.noise_start = 0.4;



% run simulation
simOut = sim('SMA_spring', 'SimulationMode', 'normal');
u = simOut.get('joule');
y = simOut.get('displacement');
t = simOut.get('time');

u_0 = u(40:end) - u(39);
y_0 = y(40:end) - y(39);

% 2. 3 poles, 0 zeroes reaches 95%
% 3. J_amp = 0.1 --> 3 poles, 0 zeroes reaches 65.5%, 2 poles, 1 zero
% reaches 91%