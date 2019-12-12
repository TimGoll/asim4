function sDE_dispIn(block)


setup(block);

% -------------------------------------------------------------------------
% Initialisierung des Simulationsobjektes block
% -------------------------------------------------------------------------

function setup(block)
  
  % Anzahl der Eingangs- und Ausgangsports
  block.NumInputPorts  = 3;
  block.NumOutputPorts = 8;
  
  % Anzahl der zeitkontinuierlichen Zustaende
  initConds = block.DialogPrm(2).Data;
  x = initConds.epsilon_v;
  block.NumContStates = length(x) + 1;

  % Anzahl der Parameter
  block.NumDialogPrms = 2;
  
  % Dimensionen der Eingangsports
  % Flag DirectFeedthrough kennzeichnet, ob ein Eingang direkt an einem
  % Ausgang auftritt, d.h. y=f(u)
  block.InputPort(1).Dimensions        = 1;
  block.InputPort(1).SamplingMode = 'Sample';
  block.InputPort(1).DirectFeedthrough = true;
  
  block.InputPort(2).Dimensions        = 1;
  block.InputPort(2).SamplingMode = 'Sample';
  block.InputPort(2).DirectFeedthrough = true;
  
  block.InputPort(3).Dimensions        = 1;
  block.InputPort(3).SamplingMode = 'Sample';
  block.InputPort(3).DirectFeedthrough = true;
  
  % Dimensionen der Ausgangsports  
  block.OutputPort(1).Dimensions       = 1;
  block.OutputPort(1).SamplingMode = 'Sample';
  
  block.OutputPort(2).Dimensions       = length(x);
  block.OutputPort(2).SamplingMode = 'Sample';
  
  block.OutputPort(3).Dimensions       = 1;
  block.OutputPort(3).SamplingMode = 'Sample';
  
  block.OutputPort(4).Dimensions       = 1;
  block.OutputPort(4).SamplingMode = 'Sample';
  
  block.OutputPort(5).Dimensions       = 1;
  block.OutputPort(5).SamplingMode = 'Sample';
  
  block.OutputPort(6).Dimensions       = 1;
  block.OutputPort(6).SamplingMode = 'Sample';
  
  block.OutputPort(7).Dimensions       = 1;
  block.OutputPort(7).SamplingMode = 'Sample';
  
  block.OutputPort(8).Dimensions       = 1;
  block.OutputPort(8).SamplingMode = 'Sample';

  
  % Einstellen der Abtastzeit: [0 0] wird verwendet fuer die
  % zeitkontinuierliche Simulation.
  block.SampleTimes = [0 0];
  
  % ------------------------------------------------
  % NICHT VERAENDERN
  % ------------------------------------------------
  % 
  % Registrieren der einzelnen Methoden
  % Hier: InitializeConditions ... Initialisierung
  %       Outputs ...       Berechnung der Ausgaenge
  %       Derivatives ...   Berechnung der Zustaende
  %       Terminate ...     Konsistentes Beenden der Simulation
  block.RegBlockMethod('InitializeConditions',    @InitConditions); 
  block.RegBlockMethod('Outputs',                 @Output);  
  block.RegBlockMethod('Derivatives',             @Derivatives);  
  block.RegBlockMethod('Terminate',               @Terminate);

  % 
  
  
% -------------------------------------------------------------------------
% Setzen der Anfangsbedingungen der Zustaende
% -------------------------------------------------------------------------

function InitConditions(block)
  
  % Einlesen der Anfangsbedingungen
  initConds = block.DialogPrm(2).Data;

    
  % Eingabe der Anfangsbedingungen
  x = [initConds.epsilon_v initConds.q];
  
  % Schreiben auf Objekt block (NICHT VERAENDERN)
  block.ContStates.Data = x;


% -------------------------------------------------------------------------
% Berechnen der Ausgaenge
% -------------------------------------------------------------------------

function Output(block)

  % Einlesen der Parameter des Systems
 params = block.DialogPrm(1).Data;
  
  
    epsilon_0 = params.epsilon_0;
    epsilon_r = params.epsilon_r;
    alpha = params.alpha;
    mu = params.mu;
    kv = params.kv;
    bv = params.bv;
    bv0 = params.bv0;
    
    L1 = params.L1;
    L2 = params.L2;
    L3 = params.L3;
    
    rho = params.rho;
    Re_s = params.Re_s;
 
 
    % Shortcut for inputs
    y = block.InputPort(1).Data;
    y_dot = block.InputPort(2).Data;
    v = block.InputPort(3).Data;
  
    % Shortcut for states
    epsilon_v = block.ContStates.Data(1:end-1);
    q = block.ContStates.Data(end);

    % Calculation of additional variables
        
    C = epsilon_0*epsilon_r*L1*L2/L3*(y/L1)^2;
    Rl = rho*L3/L1/L2*(L1/y)^2;
    Re = Re_s/L1/L2;
    
    epsilon = (y - L1)/L1;
    epsilon_dot = y_dot/L1;
    
    v_DE = q/C;
    E = v_DE*y/L1/L3;
    
    % Calculation of outputs
    % Port 1  
    
    lambda = epsilon + 1;
    sigma_m = 0;
    for j = 1:length(alpha)
        sigma_m = sigma_m + mu(j)*(lambda^alpha(j) - lambda^(-alpha(j)));
    end
    sigma_e = - epsilon_0*epsilon_r*(E)^2;
    sigma_v = 0;
    for j = 1:length(kv)
       sigma_v = sigma_v - kv(j)*epsilon_v(j) + kv(j)*epsilon;
    end
    sigma_v = sigma_v + bv0*epsilon_dot;

  sigma = max(sigma_m + sigma_e + sigma_v,0);
  y1 = sigma*L1*L2*L3/y;
  
  % Port 2:
  y2 = epsilon_v;
  
  % Port 3:
  y3 = q;
  
  % Port 4:
  y4 = epsilon;
  
  % Port 5:
  y5 = sigma;
  
  % Port 6:
  y6 = -q/Re/C + v/Re;
  
  % Port 7:
  y7 = v_DE;
  
  % Port 8:
  y8 = C;

  % Schreiben auf Objekt block
  block.OutputPort(1).Data = y1;
  block.OutputPort(2).Data = y2;
  block.OutputPort(3).Data = y3;
  block.OutputPort(4).Data = y4;
  block.OutputPort(5).Data = y5;
  block.OutputPort(6).Data = y6;
  block.OutputPort(7).Data = y7;
  block.OutputPort(8).Data = y8;
  

% -------------------------------------------------------------------------
% Berechnen der Zustaende
% -------------------------------------------------------------------------

function Derivatives(block)

    % Einlesen der Parameter des Systems
    params = block.DialogPrm(1).Data;
 
    epsilon_0 = params.epsilon_0;
    epsilon_r = params.epsilon_r;
    alpha = params.alpha;
    mu = params.mu;
    kv = params.kv;
    bv = params.bv;
    bv0 = params.bv0;
    
    L1 = params.L1;
    L2 = params.L2;
    L3 = params.L3;
    
    rho = params.rho;
    Re_s = params.Re_s;
 
   
    % Shortcut for inputs
    y = block.InputPort(1).Data;
    y_dot = block.InputPort(2).Data;
    v = block.InputPort(3).Data;
  
    % Shortcut for states
    epsilon_v = block.ContStates.Data(1:end-1);
    q = block.ContStates.Data(end);
    
    % Calculation of additional variables
        
    C = epsilon_0*epsilon_r*L1*L2/L3*(y/L1)^2;
    Rl = rho*L3/L1/L2*(L1/y)^2;
    Re = Re_s/L1/L2;
    
    epsilon = (y - L1)/L1;
    
    % Calculation of states derivatives    
  
  dx = zeros(length(kv) + 1,1);
  for j = 1:length(dx)-1
    dx(j) = -kv(j)/bv(j)*epsilon_v(j) + kv(j)/bv(j)*epsilon;
  end
  dx(end) = -q*(1/Re/C + 1/Rl/C) + v/Re;

  % Schreiben auf Objekt block
  block.Derivatives.Data = dx;


% -------------------------------------------------------------------------
% Operationen am Ende der Simulation
% -------------------------------------------------------------------------

% Die function Terminate wird hier nicht verwendet,
% muss aber vorhanden sein!
function Terminate(block)

