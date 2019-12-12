%% Structure parameters

l1 = 0.1;
l2 = 0.1;
r1 = 1.25e-3;
r2 = 1.25e-3;
m1 = 1e-2;
m2 = 1e-2;
I1 = 1/12*m1*l1^2;
I2 = 1/12*m2*l2^2;
b1 = 0.7e-3;
b2 = 0.7e-3;
N = 10;
Delta = 0.080*0.03;

%% SMA parameters

params_PC2 = struct;

params_PC2.internal_loops_flag = 0;             %   If 1 it simulates internal loops, if 0 it neglects them
params_PC2.internal_rate_flag = 0;              %   If 1 it calculates transformation rate internally, if 0 it calculates transformaton rate externally

params_PC2.Ea 			= 35.0e9;				%	Austenite modulus of elasticity		[N/m^2]
params_PC2.Em			= 25.0e9;				%	Martensite modulus of elasticity	[N/m^2]
params_PC2.epsilonT 	= 0.045;				%	"epsilon T"	transformation strain	[-]
params_PC2.T0 			= 293;	             	%	temperature T0 for computing sigmaA_T		[K]

params_PC2.Vd 			= 5e-23;           		% 	volume of a layer					[m^3]
params_PC2.tau_x 		= 1e-2;					%	"tau x" (re:vibration frequency)	[s]
params_PC2.kb 			= 1.380649e-23;	   	 	%	Boltzman constant					[J/K]

params_PC2.alpha 		= 450;					%	convection coefficient				[W/(m^2*K)]
params_PC2.cv 			= 0.4e3;				%	Heat capacity						[J/(kg*K)]
params_PC2.rho 			= 6500;					%	density								[kg/m^3]
params_PC2.latentHpls 	= 22e3*params_PC2.rho;		% 	Latent heat of phase transformation 	[J/m^3]
params_PC2.latentHmns 	= 22e3*params_PC2.rho;		% 	Latent heat of phase transformation 	[J/m^3]

params_PC2.r0 			= 12.5e-6;				%	wire radius							[m]
params_PC2.L0 			= 80e-3;					%	wire length							[m]

params_PC2.T0R          = 293;                  %   reference temperature for computing R	[K]
params_PC2.rho0A        = 8.9e-7;               %   resistivity of austenite            [Ohm*m]
params_PC2.rho0Mp       = 10.2e-7;              %   resistivity of martensite plus   	[Ojm*m]
params_PC2.rho0Mm       = 10.2e-7;              %   resistivity of martensite minus     [Ojm*m]
params_PC2.alphaA       = 2e-4;                 %   temperature dependence of austenite [1/K]
params_PC2.alphaMp      = 3e-4;                 %   temperature dependence of austenite [1/K]
params_PC2.alphaMm      = 3e-4;                 %   temperature dependence of austenite [1/K]
params_PC2.poisson      = 0.3;                  %   Poisson's ratio                     [-]

%% SMA polycrystalline model parameters

% Compute hysteresis master curves

E_AL = 6.1393e+07;
E_AR = -1.1802e+08;
E_AC = -2.4562e+08;
sigma_AB = 2.9040e+08;
lambda_AL = 694.5429;
lambda_AR = 14.9047;

E_ML = 5.2815e+07;
E_MR = -4.3518e+07;
E_MC = -7.5099e+07;
sigma_MB = 3.2004e+08;
lambda_ML = 69.4120;
lambda_MR = 1.5736e+03;


sigma_AS_0 = 0;
sigma_AS_0p5 = 7e6;
sigma_AS_1 = 6e6;
slope_AS_0p5 = 1;
lambda_ASL = 50;
lambda_ASR = 20;
x0_ASL = -0.1;
x0_ASR = 0.95;


sigma_MS_0 = 0;
sigma_MS_0p5 = 7e6;
sigma_MS_1 = 6e6;
slope_MS_0p5 = 1;
lambda_MSL = 50;
lambda_MSR = 20;
x0_MSL = -0.1;
x0_MSR = 0.95;


AAS = [1/(1+exp(-lambda_ASL*(-x0_ASL))) 1/(1+exp(lambda_ASR*(-x0_ASR))) 0 1; 
    1/(1+exp(-lambda_ASL*(0.5-x0_ASL))) 1/(1+exp(lambda_ASR*(0.5-x0_ASR))) 0.5 1;
    1/(1+exp(-lambda_ASL*(1-x0_ASL))) 1/(1+exp(lambda_ASR*(1-x0_ASR))) 1 1;
    lambda_ASL*exp(-lambda_ASL*(0.5 - x0_ASL))/(1 + exp(-lambda_ASL*(0.5 - x0_ASL)))^2 -lambda_ASR*exp(-lambda_ASR*(0.5 - x0_ASR))/(1 + exp(-lambda_ASR*(0.5 - x0_ASR)))^2 1 0];
BAS = [sigma_AS_0 sigma_AS_0p5 sigma_AS_1 slope_AS_0p5]';
XAS = AAS\BAS;
E_ASL = XAS(1);
E_ASR = XAS(2); 
E_ASC = XAS(3);
sigma_bias_AS = XAS(4);


AMS = [1/(1+exp(-lambda_MSL*(-x0_MSL))) 1/(1+exp(lambda_MSR*(-x0_MSR))) 0 1; 
    1/(1+exp(-lambda_MSL*(0.5-x0_MSL))) 1/(1+exp(lambda_MSR*(0.5-x0_MSR))) 0.5 1;
    1/(1+exp(-lambda_MSL*(1-x0_MSL))) 1/(1+exp(lambda_MSR*(1-x0_MSR))) 1 1;
    lambda_MSL*exp(-lambda_MSL*(0.5 - x0_MSL))/(1 + exp(-lambda_MSL*(0.5 - x0_MSL)))^2 -lambda_MSR*exp(-lambda_MSR*(0.5 - x0_MSR))/(1 + exp(-lambda_MSR*(0.5 - x0_MSR)))^2 1 0];
BMS = [sigma_MS_0 sigma_MS_0p5 sigma_MS_1 slope_MS_0p5]';
XMS = AMS\BMS;
E_MSL = XMS(1);
E_MSR = XMS(2); 
E_MSC = XMS(3);
sigma_bias_MS = XMS(4);


params_PC2.E_AL = E_AL;
params_PC2.E_AR = E_AR;
params_PC2.E_AC = E_AC;
params_PC2.sigma_AB = sigma_AB;
params_PC2.lambda_AL = lambda_AL;
params_PC2.lambda_AR = lambda_AR;

params_PC2.E_ML = E_ML;
params_PC2.E_MR = E_MR;
params_PC2.E_MC = E_MC;
params_PC2.sigma_MB = sigma_MB;
params_PC2.lambda_ML = lambda_ML;
params_PC2.lambda_MR = lambda_MR;

params_PC2.lambda_ASL = lambda_ASL;
params_PC2.lambda_ASR = lambda_ASR;
params_PC2.x0_ASL = x0_ASL;
params_PC2.x0_ASR = x0_ASR;

params_PC2.lambda_MSL = lambda_MSL;
params_PC2.lambda_MSR = lambda_MSR;
params_PC2.x0_MSL = x0_MSL;
params_PC2.x0_MSR = x0_MSR;

params_PC2.E_ASL = E_ASL;
params_PC2.E_ASR = E_ASR; 
params_PC2.E_ASC = E_ASC;
params_PC2.sigma_bias_AS = sigma_bias_AS;

params_PC2.E_MSL = E_MSL;
params_PC2.E_MSR = E_MSR; 
params_PC2.E_MSC = E_MSC;
params_PC2.sigma_bias_MS = sigma_bias_MS;


% xp_array = 0:0.001:1;
% sigma_A = xp_array*0;
% sigma_M = xp_array*0;
% sigma_scal_T = xp_array*0;
% for i = 1:length(xp_array)
%    sigma_A(i) = params_PC2.E_AL*log(1 + params_PC2.lambda_AL*xp_array(i)) + params_PC2.E_AR*log(1 + params_PC2.lambda_AR*(1 - xp_array(i))) + params_PC2.E_AC*xp_array(i) + params_PC2.sigma_AB;
%    sigma_M(i) = params_PC2.E_ML*log(1 + params_PC2.lambda_ML*xp_array(i)) + params_PC2.E_MR*log(1 + params_PC2.lambda_MR*(1 - xp_array(i))) + params_PC2.E_MC*xp_array(i) + params_PC2.sigma_MB;
% 
%    if sigma_A(i) < 0
%        sigma_A(i) = 0; 
%     end
%     if sigma_M(i) > sigma_A(i)
%         sigma_M(i) = sigma_A(i);
%     elseif sigma_M(i) < 0
%         sigma_M(i) = 0;
%     end
%     
%     sigma_scal_T(i) = max(0,E_ASL/(1 + exp(-lambda_ASL*(xp_array(i) - x0_ASL))) + E_ASR/(1 + exp(lambda_ASR*(xp_array(i) - x0_ASR))) + E_ASC*xp_array(i) + sigma_bias_AS);
%         
% end
% 
% sigma_A(1) = 0;
% i = 2;
% while sigma_A(i) == sigma_A(i-1)
%     i = i + 1;
% end
% if i > 2
%     sigma_A(1:i) = 0:sigma_A(i)/(i-1):sigma_A(i);
% end
% 
% sigma_M(end) = sigma_A(end);
% i = 2;
% while sigma_M(i) == sigma_M(i-1)
%     i = i + 1;
% end
% if i > 2
%     sigma_M(1:i) = 0:sigma_M(i)/(i-1):sigma_M(i);
% end
% 
% subplot(2,1,1);
% plot(xp_array,sigma_A,'b',xp_array,sigma_M,'r','LineWidth',2);
% subplot(2,1,2);
% plot(xp_array,sigma_scal_T,'b','LineWidth',2);

%% Initial conditions

initConds_PC2 = struct;		% initial conditions

initConds_PC2.xp0 		= 0.5;               % 	Initial phase fraction x+
initConds_PC2.xm0 		= 0.0;                	%	Initial phase fraction x-
initConds_PC2.T0 		= 293;                  % 	Initial temperature of wire
