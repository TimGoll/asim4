% clc;
% clear ALL;
% close ALL;
% warning ('off','all');
% 
% do_rerun = true;
% 
% % load parameter
% Parameter_PC2;
% 
% disp(mfilename('fullpath'));
% 
% % init task
% path_arr = strsplit(mfilename('fullpath'), {'/', '\'});
% task_name = string(path_arr(end-1));
% disp('running exam_' + task_name);
% 
% path_arr(end) = [];
% path_arr(end) = [];
% path_arr = [path_arr 'plots'];
% plot_path = strjoin(path_arr, '/');
% 
% 
% task_params.enable_theta_1=0;
% task_params.enable_theta_2=1;
% 
% % PARAMS u1
% tau_star = 0.2;
% 
% b_0 = 165.81;
% a_1 = 1.351;
% a_0 = 0.4741;
% 
% task_params.KP1 = 2 * a_1 / (b_0 * tau_star);
% task_params.KI1 = 2 * a_0 / (b_0 * tau_star);
% task_params.KD1 = 1 / (b_0 * tau_star);
% 
% % PARAMS u2
% delta_2 = 0.707;
%                   
% k_2 = 586.9;     
% p1_2 = 11.89;     
% p2_2 = 0.3653;    
% 
% task_params.P2 = p1_2^2 / (4 * k_2 * delta_2^2);
% task_params.I2 = p2_2 * p1_2^2 / (4 * k_2 * delta_2^2);
% task_params.D2 = 0;
% 
% % run simulation
% simOut = simulate('SMAWing_06_PID', do_rerun);
% time_0 = simOut.get('time');
% u1_0 = simOut.get('u1');
% u2_0 = simOut.get('u2');
% theta_1_0 = simOut.get('theta_1');
% theta_2_0 = simOut.get('theta_2');
% theta_ref_0 = simOut.get('theta_ref'); 
% theta_ref_1_0 = simOut.get('theta_ref_1'); 
% 
% task_params.enable_theta_1=1;
% task_params.enable_theta_2=0;
% 
% disp("finished number 1");
% 
% 
% % run simulation
% simOut = simulate('SMAWing_06_PID', do_rerun);
% time_1 = simOut.get('time');
% u1_1 = simOut.get('u1');
% u2_1 = simOut.get('u2');
% theta_1_1 = simOut.get('theta_1');
% theta_2_1 = simOut.get('theta_2');
% theta_ref_1 = simOut.get('theta_ref'); 
% theta_ref_1_1 = simOut.get('theta_ref_1'); 
% 
% task_params.enable_theta_1=1;
% task_params.enable_theta_2=1;
% 
% disp("finished number 2");
% 
% % run simulation
% simOut = simulate('SMAWing_06_PID', do_rerun);
% time_2 = simOut.get('time');
% u1_2 = simOut.get('u1');
% u2_2 = simOut.get('u2');
% theta_1_2 = simOut.get('theta_1');
% theta_2_2 = simOut.get('theta_2');
% theta_ref_2 = simOut.get('theta_ref'); 
% theta_ref_1_2 = simOut.get('theta_ref_1'); 


paw({time_0 , time_0, time_0}, {theta_ref_0, theta_2_0, theta_2_2}, {'theta_{2,ref}','theta_{2,single}','theta_{2,same time}'}, 'time [s]', 'theta', task_name, 'samecontrol_theta1_theta_2_1', plot_path, true, true, {':','',''}, 'southwest');
paw({time_0 , time_0, time_0}, {theta_ref_1_1, theta_1_1, theta_1_2}, {'theta_{1,ref}','theta_{1,single}','theta_{1,same time}'}, 'time [s]', 'theta', task_name, 'samecontrol_theta1_theta_2', plot_path, true, true, {':','',''}, 'southwest');
paw({time_0 , time_0, time_0}, {theta_ref_0, theta_2_0, theta_2_2}, {'theta_{2,ref}','theta_{2,single}','theta_{2,same time}'}, 'time [s]', 'theta', task_name, 'samecontrol_theta1_theta_2_nolegend_1', plot_path, false, true, {':','',''}, 'southwest');
paw({time_0 , time_0, time_0}, {theta_ref_1_1, theta_1_1, theta_1_2}, {'theta_{1,ref}','theta_{1,single}','theta_{1,same time}'}, 'time [s]', 'theta', task_name, 'samecontrol_theta1_theta_2_nolegend', plot_path, false, true, {':','',''}, 'southwest');
