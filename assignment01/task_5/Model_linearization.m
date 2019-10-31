%% Step 1 - load parameters and define inputs

Parameter

ueq = ueq_init; % Define equilibrium voltage [V]
deq = 0; % Define equilibrium load force [N];
ieq = 1; % In case many equilibrium states exist, select the ieq-th


%% Step 2 - definition of model variables

x1 = sym('x1','real'); % Define a symbolic real variable for state x1
x2 = sym('x2','real'); % Define a symbolic real variable for state x2
x3 = sym('x3','real'); % Define a symbolic real variable for state x3
x4 = sym('x4','real'); % Define a symbolic real variable for state x4
u = sym('u','real'); % Define a symbolic real variable for state u
d = sym('d','real'); % Define a symbolic real variable for state d


%% Step 3 - definition of system state and output functions

f1 = x2; % Define first state equation in symbolic form
f2 = - params_BIAS.kl/params_BIAS.m*(x1 - params_BIAS.y0l) - params_BIAS.g ...
    - params.L1*params.L2*params.L3/params_BIAS.m/x1*( ...
    + params.mu(1)*((x1/params.L1)^(params.alpha(1)) - (x1/params.L1)^(-params.alpha(1))) ...
    + params.mu(2)*((x1/params.L1)^(params.alpha(2)) - (x1/params.L1)^(-params.alpha(2))) ...
    + params.mu(3)*((x1/params.L1)^(params.alpha(3)) - (x1/params.L1)^(-params.alpha(3))) ...
    - params.epsilon_0*params.epsilon_r*(x1/params.L1/params.L3*u)^2 ...
    + params.kv(1)*(x1/params.L1-1-x3) + params.kv(2)*(x1/params.L1-1-x4) ...
    + params.bv0*x2/params.L1) + 1/params_BIAS.m*d; % Define second state equation in symbolic form
f3 = -params.kv(1)/params.bv(1)*x3 + params.kv(1)/params.bv(1)*(x1/params.L1-1); % Define third state equation in symbolic form
f4 = -params.kv(2)/params.bv(2)*x4 + params.kv(2)/params.bv(2)*(x1/params.L1-1); % Define fourth state equation in symbolic form

f = [f1;f2;f3;f4]; % Define state function in vectorial form

h = x1; % Define output equation in symbolic form


%% Step 4 - find equilibrium state

feq = subs(f,{u,d},{ueq,deq}); % Compute the symbolic equation f for specific values of ueq and deq
xeq = vpasolve(feq  == 0,[x1 x2 x3 x4],[params.L1 2*params.L1; -inf inf; 0 inf; 0 inf]); % Numerical solution of f = 0, with interval specified for each variable

ieq = min(ieq,length(xeq.x1)); % If the number of solutions is smaller than ieq, consider the last one
x1eq = double(xeq.x1(ieq)); % Equilibrium position, converted from symbolic in double
x2eq = double(xeq.x2(ieq)); % Equilibrium velocity, converted from symbolic in double
x3eq = double(xeq.x3(ieq)); % Equilibrium viscoelastic strain 1, converted from symbolic in double
x4eq = double(xeq.x4(ieq)); % Equilibrium viscoelastic strain 2, converted from symbolic in double

yeq = double(subs(h,[x1 x2 x3 x4 u d],[x1eq x2eq x3eq x4eq u d])); % Equilibrium output, converted from symbolic in double


%% Step 5 - find linearized model matrices

A = [diff(f1,x1) diff(f1,x2) diff(f1,x3) diff(f1,x4);
    diff(f2,x1) diff(f2,x2) diff(f2,x3) diff(f2,x4);
    diff(f3,x1) diff(f3,x2) diff(f3,x3) diff(f3,x4);
    diff(f4,x1) diff(f4,x2) diff(f4,x3) diff(f4,x4)]; % State matrix, symbolic computation
A = subs(A,{x1,x2,x3,x4,u,d},{x1eq,x2eq,x3eq,x4eq,ueq,deq}); % State matrix, compute at equilibrium
A = double(A); % State matrix, convert in double

Bu = [diff(f1,u);
    diff(f2,u);
    diff(f3,u);
    diff(f4,u)]; % Control input matrix, symbolic computation
Bu = subs(Bu,{x1,x2,x3,x4,u,d},{x1eq,x2eq,x3eq,x4eq,ueq,deq}); % Control input matrix, compute at equilibrium
Bu = double(Bu); % Control input matrix, convert in double

Bd = [diff(f1,d);
    diff(f2,d);
    diff(f3,d);
    diff(f4,d)]; % Disturbance input matrix, symbolic computation
Bd = subs(Bd,{x1,x2,x3,x4,u,d},{x1eq,x2eq,x3eq,x4eq,ueq,deq}); % Disturbance input matrix, compute at equilibrium
Bd = double(Bd); % Disturbance input matrix, convert in double

C = [diff(h,x1) diff(h,x2) diff(h,x3) diff(h,x4)]; % Output matrix, symbolic computation
C = subs(C,{x1,x2,x3,x4,u,d},{x1eq,x2eq,x3eq,x4eq,ueq,deq}); % Output matrix, compute at equilibrium
C = double(C); % Output matrix, convert in double

Du = diff(h,u); % Direct control input - output matrix, symbolic computation
Du = subs(Du,{x1,x2,x3,x4,u,d},{x1eq,x2eq,x3eq,x4eq,ueq,deq}); % Direct control input - output matrix, compute at equilibrium
Du = double(Du); % Direct control input - output matrix, convert in double

Dd = diff(h,d); % Direct disturbance input - output matrix, symbolic computation
Dd = subs(Dd,{x1,x2,x3,x4,u,d},{x1eq,x2eq,x3eq,x4eq,ueq,deq}); % Direct disturbance input - output matrix, compute at equilibrium
Dd = double(Dd); % Direct disturbance input - output matrix, convert in double


S = ss(A,Bu,C,Du); % Control input - output linearized model
Sd = ss(A,Bd,C,Dd); % Disturbance input - output linearized model






