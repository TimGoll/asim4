% parameter list

params_BIAS.kl = 0;	%    linear spring stiffness [N/m]
params_BIAS.y0l = 0.05;    %    linear spring pre-compression [m]
params_BIAS.m = 0.3;       %    mass [kg]
params_BIAS.g = -9.807;      %    gravitational constant [m/s^2]


params = struct;		% system parameters

params.L1 = 10e-3;              %	DE membrane 1-length		[m]
params.L2 = 100e-3;              %	DE membrane 2-length		[m]
params.L3 = 50e-6;             %	DE membrane 3-length		[m]
params.epsilon_0 = 8.854e-12;  % 	Void permittivity			[F/m]
params.epsilon_r = 2.8;		   %	DE relative permittivity
params.alpha = [2 4 6];               %	DE Ogden model exponents [-]
params.mu = [0.73726 -0.26842 0.04858]*1e6;         %	DE Ogden model coefficient [Pa]
params.kv = [0.59 0.18]*1e6;            % 	DE viscoelastic model stiffness	[Pa]
params.bv = [0.08 0.25]*1e6;            %   DE viscoelastic model damping [Pa*s]
params.bv0 = 6.32e3;                     %   DE viscoelastic model parallel damping [Pa*s]
params.rho = 1e12;                      %	DE resistivity [Ohm*m]
params.Re_s = 50;                       %	Electrodes resistance scaling coefficient [Ohm*m^2]

initConds = struct;		% initial conditions
initConds.y                 = 0.01824716;                           % 	Initial displacement [m]
initConds.y_dot             = 0;                                % 	Initial velocity [m/s]
initConds.epsilon_v 		= (initConds.y - params.L1)/params.L1*ones(size(params.kv));        % 	Initial viscoelastic strain [-]
initConds.q                 = 0;                              % 	Initial charge [C]

