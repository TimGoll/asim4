%% INFO
% run by executing "task <number>"

%% TASK NUMBERS
% 1 - 

%% FUNCTION

function [task_params] = task(number) 
	% clear workspace
	clc;
	clear ALL;
	close ALL;
	warning ('off','all');

	% set extra variables
	task_params = struct;

	if number == "1"
		runPath("task01");
	end

	% pid based on models_v1
	if number == "2_u1_v1"
		task_params.J1 = 0;
		task_params.J2 = 0;
		task_params.u1 = 1;
		task_params.u2 = 0;

		tau_star = 0.2;

		b_0 = 165.81;
		a_1 = 1.351;
		a_0 = 0.4741;

		task_params.P1 = a_1 / (b_0 * tau_star);
		task_params.I1 = a_0 / (b_0 * tau_star);
		task_params.D1 = 1 / (b_0 * tau_star);

		task_params.P2 = 0;
		task_params.I2 = 0;
		task_params.D2 = 0;

		runPath("task03");
	end
	
	if number == "2_u1_v2"
		task_params.J1 = 0;
		task_params.J2 = 0;
		task_params.u1 = 1;
		task_params.u2 = 0;

		tau_star = 0.2;

		b_0 = 165.81;
		a_1 = 1.351;
		a_0 = 0.4741;

		task_params.P1 = 2 * a_1 / (b_0 * tau_star);
		task_params.I1 = 2 * a_0 / (b_0 * tau_star);
		task_params.D1 = 1 / (b_0 * tau_star);
		
		task_params.P2 = 0;
		task_params.I2 = 0;
		task_params.D2 = 0;

		runPath("task03");
	end
	
	if number == "2_u2_v1"
		task_params.J1 = 0;
		task_params.J2 = 0;
		task_params.u1 = 0;
		task_params.u2 = 1;

		delta_2 = 0.707;
						  % noisy  - sine   - jumps
		k_2 = 586.9;      % 586.9  - 675.49 -
		p1_2 = 11.89;     % 11.89  - 11.67  -
		p2_2 = 0.3653;    % 0.3653 - 0.4316 -

		task_params.P1 = 0;
		task_params.I1 = 0;
		task_params.D1 = 0;
		
		task_params.P2 = p1_2^2 / (4 * k_2 * delta_2^2);
		task_params.I2 = p2_2 * p1_2^2 / (4 * k_2 * delta_2^2);
		task_params.D2 = 0;

		%runPath("task03");
    end
    
    assignin('base', "task_params", task_params);
end

function [] = runPath(path)
	% init task
	path_arr = strsplit(mfilename('fullpath'), {'/', '\'});
	path_arr(end) = [];
	base_path = strjoin(path_arr, '/');
	
	cd (base_path + "/" + path + "/");
	run;
	cd ../;
end
