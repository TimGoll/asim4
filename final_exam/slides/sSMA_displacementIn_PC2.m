function sSMA_displacementIn_PC2(block)

% Level-2 Matlab M-file s-function
%
% -------------------------------------------------------------------------
%
% Beschreibung: Level-2 Matlab M-file s-function zur Simulation eines
%               SMA-Drahts
%
% -------------------------------------------------------------------------
%
% Eingaenge:    u1(1) ... epsilon   Dehnung
%                        u2(1) ... p_el     el. Leistungsdichte
%
% Zustaende:    x(1)  ... xp        Phasenanteil x+
%               x(2)  ... xm        Phasenanteil x-
%               x(3)  ... T         Temperatur
%
% Ausgaenge:    y1(1) ... sigma
%
%               y2(1) ... xp
%               y2(2) ... xm
%               y2(3) ... xA
% 
%               y3(1) ... T
%
%
% Parameter:    p(1)  ... params (struct)
%						         params.Ea 			
%                                params.Em			
%                                params.epsilonT 	
%                                params.Vd 			
%                                params.tau_x 		
%                                params.TL 			
%                                params.TU 			
%                                params.sigmaL 		
%                                params.sigmaU 		
%                                params.delta_sigma 	
%                                params.alpha 		
%                                params.cv 			
%                                params.T_ext 		
%                                params.rho 			
%                                params.r0 			
%                                params.L0 			
%                                params.kb 			
%                                params.latentHpls 	
%                                params.latentHmns 	
%
%               p(2)  ... initConds (struct)
%                                initConds.xp0
%                                initConds.xm0
%                                initConds.T0 
%   
%
%
% -------------------------------------------------------------------------
% Abtastzeit (sample time): zeitkontinuierlich (continuous)
% -------------------------------------------------------------------------
% Erstellt:     Ullrich, Lehrstuhl für Unkonventionelle Aktorik, 05.2014
% Geaendert:    %
% -------------------------------------------------------------------------


% Die Funktion setup (s.u.) dient der Initialiserung des Matlab Objektes
% (block). Im Objekt block sind alle fuer die Simulation in Simulink
% notwendigen Eigenschaften (Eingaenge, Zustaende, Ausgaenge, Parameter,
% usw.) des dynamischen Systems (math. Modell) zusammengefasst.
setup(block);

% -------------------------------------------------------------------------
% Initialisierung des Simulationsobjektes block
% -------------------------------------------------------------------------

function setup(block)
  
  % Anzahl der Eingangs- und Ausgangsports
  block.NumInputPorts  = 3;
  block.NumOutputPorts = 6;
  
  % Anzahl der zeitkontinuierlichen Zustaende
  block.NumContStates = 3;

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
  block.InputPort(2).DirectFeedthrough = false;
  
  block.InputPort(3).Dimensions        = 1;
  block.InputPort(3).SamplingMode = 'Sample';
  block.InputPort(3).DirectFeedthrough = false;

  % Dimensionen der Ausgangsports  
  block.OutputPort(1).Dimensions       = 1;
  block.OutputPort(1).SamplingMode = 'Sample';
  
  block.OutputPort(2).Dimensions       = 3;
  block.OutputPort(2).SamplingMode = 'Sample';
  
  block.OutputPort(3).Dimensions       = 1;
  block.OutputPort(3).SamplingMode = 'Sample';
  
  block.OutputPort(4).Dimensions       = 1;
  block.OutputPort(4).SamplingMode = 'Sample';
  
  block.OutputPort(5).Dimensions       = 1;
  block.OutputPort(5).SamplingMode = 'Sample';
  
  block.OutputPort(6).Dimensions       = 1;
  block.OutputPort(6).SamplingMode = 'Sample';
  
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
  params = block.DialogPrm(1).Data;
  initConds = block.DialogPrm(2).Data;

    
  % Eingabe der Anfangsbedingungen
  x(1) = initConds.xp0;
  x(2) = initConds.xm0;
  x(3) = initConds.T0;
  
  % Schreiben auf Objekt block (NICHT VERAENDERN)
  block.ContStates.Data = x;
  
  % Initialize global variables
   E_AL = params.E_AL;
   E_AR = params.E_AR;
   E_AC = params.E_AC;
   sigma_AB = params.sigma_AB;
   lambda_AL = params.lambda_AL;
   lambda_AR = params.lambda_AR;

   E_ML = params.E_ML;
   E_MR = params.E_MR;
   E_MC = params.E_MC;
   sigma_MB = params.sigma_MB;
   lambda_ML = params.lambda_ML;
   lambda_MR = params.lambda_MR;


   lambda_ASL = params.lambda_ASL;
   lambda_ASR = params.lambda_ASR;
   x0_ASL = params.x0_ASL;
   x0_ASR = params.x0_ASR;


   lambda_MSL = params.lambda_MSL;
   lambda_MSR = params.lambda_MSR;
   x0_MSL = params.x0_MSL;
   x0_MSR = params.x0_MSR;

   E_ASL = params.E_ASL;
   E_ASR = params.E_ASR; 
   E_ASC = params.E_ASC;
   sigma_bias_AS = params.sigma_bias_AS;

   E_MSL = params.E_MSL;
   E_MSR = params.E_MSR; 
   E_MSC = params.E_MSC;
   sigma_bias_MS = params.sigma_bias_MS;

  
    global nl internal_loops previous i_LUT 
  
    xp_array = (0:0.001:1)';
    
    sigma_A_m_array = xp_array*0;
    sigma_M_m_array = xp_array*0;
    sigma_A_s_array = xp_array*0;
    sigma_M_s_array = xp_array*0;

    for i = 1:length(xp_array)
        sigma_A_m_array(i) = E_AL*log(1 + lambda_AL*xp_array(i)) + E_AR*log(1 + lambda_AR*(1 - xp_array(i))) + E_AC*xp_array(i) + sigma_AB;
        sigma_M_m_array(i) = E_ML*log(1 + lambda_ML*xp_array(i)) + E_MR*log(1 + lambda_MR*(1 - xp_array(i))) + E_MC*xp_array(i) + sigma_MB;

        if sigma_A_m_array(i) < 0
           sigma_A_m_array(i) = 0; 
        end
        if sigma_M_m_array(i) > sigma_A_m_array(i)
            sigma_M_m_array(i) = sigma_A_m_array(i);
        elseif sigma_M_m_array(i) < 0
            sigma_M_m_array(i) = 0;
        end

        sigma_A_s_array(i) = E_ASL/(1 + exp(-lambda_ASL*(xp_array(i) - x0_ASL))) + E_ASR/(1 + exp(lambda_ASR*(xp_array(i) - x0_ASR))) + E_ASC*xp_array(i) + sigma_bias_AS;
        sigma_M_s_array(i) = E_MSL/(1 + exp(-lambda_MSL*(xp_array(i) - x0_MSL))) + E_MSR/(1 + exp(lambda_MSR*(xp_array(i) - x0_MSR))) + E_MSC*xp_array(i) + sigma_bias_MS;
    end

    sigma_A_m_array(1) = 0;
    i = 2;
    while sigma_A_m_array(i) == sigma_A_m_array(i-1)
        i = i + 1;
    end
    if i > 2
        sigma_A_m_array(1:i) = 0:sigma_A_m_array(i)/(i-1):sigma_A_m_array(i);
    end
    
    sigma_M_m_array(end) = sigma_A_m_array(end);
    i = 2;
    while sigma_M_m_array(i) == sigma_M_m_array(i-1)
        i = i + 1;
    end
    if i > 2
        sigma_M_m_array(1:i) = 0:sigma_M_m_array(i)/(i-1):sigma_M_m_array(i);
    end
    
    

    internal_loops = [];
    nl = 1;
    internal_loops(nl).xp_H = 1;
    internal_loops(nl).sigma_H = max(sigma_A_m_array);
    internal_loops(nl).xp_L = 0;
    internal_loops(nl).sigma_L = min(sigma_M_m_array);
    internal_loops(nl).xp_array = xp_array;
    internal_loops(nl).sigma_array = sigma_M_m_array;

    nl = nl + 1;
    internal_loops(nl).xp_H = 1;
    internal_loops(nl).sigma_H = max(sigma_A_m_array);
    internal_loops(nl).xp_L = 0;
    internal_loops(nl).sigma_L = min(sigma_M_m_array);
    internal_loops(nl).xp_array = xp_array;
    internal_loops(nl).sigma_array = sigma_A_m_array;

    previous.direction = 1;
    previous.xpls = x(2);
    previous.epsilon = 0;
    previous.sigmaA = 0;
    previous.sigmaM = 0;
    previous.t = 0;

    i_LUT = 1;


% -------------------------------------------------------------------------
% Berechnen der Ausgaenge
% -------------------------------------------------------------------------

function Output(block)

  % Einlesen der Parameter des Systems
 params = block.DialogPrm(1).Data;
 
  Ea 			= params.Ea 		;	
  Em			= params.Em			;
  epsilonT 		= params.epsilonT 	;
  r0 			= params.r0 		;	
  L0 			= params.L0 		;	
  T0R           = params.T0R        ;
  rho0A         = params.rho0A      ;
  rho0Mp        = params.rho0Mp     ;
  rho0Mm        = params.rho0Mm     ;
  alphaA        = params.alphaA     ;
  alphaMp       = params.alphaMp    ;
  alphaMm       = params.alphaMm    ;
  poisson       = params.poisson    ;
  

 
 
  % Shortcut fuer den Eingang
  displacement 	= block.InputPort(1).Data;
  epsilon = (displacement - L0)/L0;
  
  % Shortcut fuer den Zustand
  x = block.ContStates.Data;
  xpls = x(1);
  xmns = x(2);
  temp = x(3);
  if xpls < 0
    xpls = 0;
  elseif xpls > 1
      xpls = 1;
  end
  if xmns < 0
    xmns = 0;
  elseif xmns > 1
      xmns = 1;
  end
  
  % Berechnung der Ausgaenge
  % Port 1:
  sigma = (epsilon - epsilonT*(xpls-xmns))/((xpls+xmns)/Em + (1-xpls-xmns)/Ea);
  y1(1) = sigma*pi*r0^2;
  
  % Port 2:
  y2(1) = xpls;
  y2(2) = xmns;
  y2(3) = 1-xpls-xmns;
  
  % Port 3:
  y3(1) = temp;
  
  % Port 4:
  y4(1) = epsilon;
  
  % Port 5:
  y5(1) = sigma;
    
  % Port 6:
  rhoMp = rho0Mp*(1+alphaMp*(temp - T0R));
  rhoA = rho0A*(1+alphaA*(temp - T0R));
  rhoMm = rho0Mm*(1+alphaMm*(temp - T0R));
  rhoR = x(1)*rhoMp + x(2)*rhoMm + (1-x(1)-x(2))*rhoA;
  R = rhoR*(L0*(1+epsilon))/(pi*r0^2*(1-poisson*epsilon)^2);
  y6(1) = R;
  
  
  % Schreiben auf Objekt block
  block.OutputPort(1).Data = y1;
  block.OutputPort(2).Data = y2;
  block.OutputPort(3).Data = y3;
  block.OutputPort(4).Data = y4;
  block.OutputPort(5).Data = y5;
  block.OutputPort(6).Data = y6;
  

% -------------------------------------------------------------------------
% Berechnen der Zustaende
% -------------------------------------------------------------------------

function Derivatives(block)

  % Einlesen der Parameter des Systems
    
  global nl internal_loops previous i_LUT 

  t = block.CurrentTime;  
  
  params = block.DialogPrm(1).Data;
 
  Ea 			= params.Ea 		;	
  Em			= params.Em			;
  epsilonT 		= params.epsilonT 	;
  Vd 			= params.Vd 		;	
  tau_x 		= params.tau_x 		;
  T0 			= params.T0     	;	
  alpha 		= params.alpha 		;
  cv 			= params.cv			;
  rho 			= params.rho 		;	
  r0 			= params.r0 		;	
  L0 			= params.L0 		;	
  kb 			= params.kb 		;	
  latentHpls 	= params.latentHpls ;	
  latentHmns 	= params.latentHmns ;	
  internal_loops_flag = params.internal_loops_flag;
  internal_rate_flag = params.internal_rate_flag;
  
   E_AL = params.E_AL;
   E_AR = params.E_AR;
   E_AC = params.E_AC;
   sigma_AB = params.sigma_AB;
   lambda_AL = params.lambda_AL;
   lambda_AR = params.lambda_AR;

   E_ML = params.E_ML;
   E_MR = params.E_MR;
   E_MC = params.E_MC;
   sigma_MB = params.sigma_MB;
   lambda_ML = params.lambda_ML;
   lambda_MR = params.lambda_MR;  

   lambda_ASL = params.lambda_ASL;
   lambda_ASR = params.lambda_ASR;
   x0_ASL = params.x0_ASL;
   x0_ASR = params.x0_ASR;

   lambda_MSL = params.lambda_MSL;
   lambda_MSR = params.lambda_MSR;
   x0_MSL = params.x0_MSL;
   x0_MSR = params.x0_MSR;

   E_ASL = params.E_ASL;
   E_ASR = params.E_ASR; 
   E_ASC = params.E_ASC;
   sigma_bias_AS = params.sigma_bias_AS;

   E_MSL = params.E_MSL;
   E_MSR = params.E_MSR; 
   E_MSC = params.E_MSC;
   sigma_bias_MS = params.sigma_bias_MS;
  
 
  
  % Shortcut fuer den Eingang
  displacement = block.InputPort(1).Data;
  p_el    = block.InputPort(2).Data;
  T_ext   = block.InputPort(3).Data;
  
  epsilon = (displacement - L0)/L0;
  
  % Shortcut fuer die Zustaende
  x = block.ContStates.Data;
  xpls = x(1);
  xmns = x(2);
  temp = x(3);
  
  if xpls < 0
    xpls = 0;
  elseif xpls > 1
      xpls = 1;
  end
  if xmns < 0
    xmns = 0;
  elseif xmns > 1
      xmns = 1;
  end
  
  % compute stress
  sigma = (epsilon - epsilonT*(xpls-xmns))/((xpls+xmns)/Em + (1-xpls-xmns)/Ea);
  
if internal_loops_flag == 1 % Compute transformation stresses sigmaM and sigmaA in case of internal loops

if internal_rate_flag == 0
   % If completely in martensite or austenite, calculate direction via rate of epsilon (anticausal model)
   if epsilon > previous.epsilon && previous.direction < 0 && t > previous.t
        current_direction = 1;
    else
        if epsilon < previous.epsilon && previous.direction > 0 && t > previous.t
           current_direction = -1;
        else
            current_direction = previous.direction;
        end
   end 
else
    if xpls >= 1e-4 && 1 - xpls >= 1e-4
        % If not completely in austenite or martensite, calculate direction via rate of xpls
        if xpls > previous.xpls && previous.direction < 0 && t > previous.t
            current_direction = 1;
        else
            if xpls < previous.xpls && previous.direction > 0 && t > previous.t
               current_direction = -1;
            else
                current_direction = previous.direction;
            end
        end
    else 
       % If completely in martensite or austenite, calculate direction via rate of epsilon (anticausal model)
       if epsilon > previous.epsilon && previous.direction < 0 && t > previous.t
            current_direction = 1;
        else
            if epsilon < previous.epsilon && previous.direction > 0 && t > previous.t
               current_direction = -1;
            else
                current_direction = previous.direction;
            end
       end 
    end
end

% Compute transformation stresses sigmaM and sigmaA

if current_direction ~= previous.direction % Change of direction
    nl = nl + 1;
%     if (current_direction == 1 && min(internal_loops(nl-1).xp_H,max(internal_loops(nl-2).xp_array)) >= max(previous.xpls,min(internal_loops(nl-2).xp_array)) + 0.001) || (current_direction == -1 && min(previous.xpls,max(internal_loops(nl-2).xp_array)) >= max(internal_loops(nl-1).xp_L,min(internal_loops(nl-2).xp_array)) + 0.001) % The new internal path contains at least 2 points
        if current_direction == 1 
            % Update new loading path
            internal_loops(nl).xp_H = internal_loops(nl-1).xp_H;
            internal_loops(nl).xp_L = previous.xpls;
            internal_loops(nl).sigma_H = internal_loops(nl-1).sigma_H;
            internal_loops(nl).sigma_L = previous.sigmaM;              
        end
        if current_direction == -1 
            % Update new unloading path
            internal_loops(nl).xp_H = previous.xpls; 
            internal_loops(nl).xp_L = internal_loops(nl-1).xp_L; 
            internal_loops(nl).sigma_H = previous.sigmaA;
            internal_loops(nl).sigma_L = internal_loops(nl-1).sigma_L;
        end    
        % Linear scaling parametrization
        xp_H_major = interp1(internal_loops(nl-2).sigma_array,internal_loops(nl-2).xp_array,internal_loops(nl).sigma_H,[],'extrap');
        xp_L_major = interp1(internal_loops(nl-2).sigma_array,internal_loops(nl-2).xp_array,internal_loops(nl).sigma_L,[],'extrap');
        p_scal = (xp_H_major - xp_L_major)/(internal_loops(nl).xp_H - internal_loops(nl).xp_L);
        q_scal = (internal_loops(nl).xp_H*xp_L_major - internal_loops(nl).xp_L*xp_H_major)/(internal_loops(nl).xp_H - internal_loops(nl).xp_L);
        
        % Generate new arrays of xpls and sigma for current path

        xp_plot = (internal_loops(nl).xp_L:(internal_loops(nl).xp_H-internal_loops(nl).xp_L)/999:internal_loops(nl).xp_H)';
        sigma_plot = xp_plot*0;
        sigma_plot = interp1((internal_loops(nl-2).xp_array - q_scal)/p_scal,internal_loops(nl-2).sigma_array,xp_plot,[],'extrap'); % Path with pure linear scaling
        for i = 1:length(xp_plot)
            if current_direction == - 1;
                 % Coefficient lambda which weights distance from upper and lower transformation point, for unloading path
                 lambda = (xp_plot(i) - internal_loops(nl).xp_L)/(internal_loops(nl).xp_H - internal_loops(nl).xp_L);
                 % Update index for fast look-up table computation
                 i_LUT = length(xp_plot) - 1;
            else
                 % Coefficient lambda which weights distance from upper and lower transformation point, for loading path
                 lambda = (internal_loops(nl).xp_H - xp_plot(i))/(internal_loops(nl).xp_H - internal_loops(nl).xp_L);  
                 % Update index for fast look-up table computation
                 i_LUT = 1; 
            end
        % Coefficient gamma which weights distance from xpls = 0.5
        gamma = 1-abs(2*xp_plot(i)-1); 
        % Compute actual array of transformation stress, considering both
        % weighting coefficients lambda and gamma
        sigma_plot(i) = (gamma + lambda - gamma*lambda)*interp1(xp_plot,sigma_plot,xp_plot(i)) + (1 - gamma - lambda + gamma*lambda)*interp1(internal_loops(nl-2).xp_array,internal_loops(nl-2).sigma_array,xp_plot(i),[],'extrap');
        end
        % Update arrays containing current transformation stress path in the structure
        internal_loops(nl).xp_array = xp_plot;
        internal_loops(nl).sigma_array = sigma_plot;
%     else
%        % Current direction inversion is not regognized, come back to
%        % previous path
%        nl = nl - 1; 
%     end
else
    % inner loop closes while loading
    if xpls > internal_loops(nl).xp_H && current_direction == 1 && nl > 3
        % Come back of two inner loops levels
        nl = nl - 2;
        [~,i_LUT] = min(abs(internal_loops(nl).xp_array - xpls));
        if i_LUT >= length(internal_loops(nl).xp_array) - 1
           i_LUT =  length(internal_loops(nl).xp_array) - 1;
        end
    end
    % inner loop closes while unloading
    if xpls < internal_loops(nl).xp_L && current_direction == -1 && nl > 3
        % Come back of two inner loops levels
        nl = nl - 2;
        [~,i_LUT] = min(abs(internal_loops(nl).xp_array - xpls));
        if i_LUT >= length(internal_loops(nl).xp_array) - 1
           i_LUT =  length(internal_loops(nl).xp_array) - 1;
        end
    end
end
% Manual computation of look-up table to simplify computation effort, based
% on index i_LUT (current point must lay between i_LUT and i_LUT + 1)
if internal_loops(nl).xp_array(i_LUT) < xpls
    % We are on the loading branch, i_LUT needs to be increased
    while i_LUT < length(internal_loops(nl).xp_array) - 1 && internal_loops(nl).xp_array(i_LUT + 1) < xpls
       i_LUT = i_LUT + 1;
    end      
elseif internal_loops(nl).xp_array(i_LUT) >= xpls
    % We are on the unloading branch, i_LUT needs to be decreased
    while i_LUT > 1 && internal_loops(nl).xp_array(i_LUT) > xpls
       i_LUT = i_LUT - 1; 
    end    
end

% Compute transformation stress by performing linear interpolation on the
% current path, between i_LUT and i_LUT + 1
sigma_A =  (internal_loops(nl).sigma_array(i_LUT + 1) - internal_loops(nl).sigma_array(i_LUT))/(internal_loops(nl).xp_array(i_LUT + 1) - internal_loops(nl).xp_array(i_LUT))*(xpls - internal_loops(nl).xp_array(i_LUT)) + internal_loops(nl).sigma_array(i_LUT);
sigma_M = sigma_A;

% Update global variables

if t > previous.t
	previous.t = t;      
    previous.direction = current_direction;
    previous.xpls = xpls;
    previous.epsilon = epsilon;
    previous.sigmaA = sigma_A;
    previous.sigmaM = sigma_M;
end

% Include temperature dependence

if current_direction > 0
    % Update transformation stress temperature scaling coefficient according to loading curve
    sigma_scal_T = max(0,E_ASL/(1 + exp(-lambda_ASL*(xpls - x0_ASL))) + E_ASR/(1 + exp(lambda_ASR*(xpls - x0_ASR))) + E_ASC*xpls + sigma_bias_AS);
else
    % Update transformation stress temperature scaling coefficient according to unloading curve
    sigma_scal_T = max(0,E_MSL/(1 + exp(-lambda_MSL*(xpls - x0_MSL))) + E_MSR/(1 + exp(lambda_MSR*(xpls - x0_MSR))) + E_MSC*xpls + sigma_bias_MS);
end   
% Update transformation stresses
sigma_A = max(0,sigma_A + sigma_scal_T*(temp - T0));
sigma_M = sigma_A;

else  % In case no inner loops have to be simulated
    
sigma_A = E_AL*log(1 + lambda_AL*xpls) + E_AR*log(1 + lambda_AR*(1 - xpls)) + E_AC*xpls + sigma_AB;
sigma_M = E_ML*log(1 + lambda_ML*xpls) + E_MR*log(1 + lambda_MR*(1 - xpls)) + E_MC*xpls + sigma_MB;

if sigma_A < 0
   sigma_A = 0; 
end
if sigma_M > sigma_A
    sigma_M = sigma_A;
elseif sigma_M < 0
    sigma_M = 0;
end   

sigma_scal_T_A = max(0,E_ASL/(1 + exp(-lambda_ASL*(xpls - x0_ASL))) + E_ASR/(1 + exp(lambda_ASR*(xpls - x0_ASR))) + E_ASC*xpls + sigma_bias_AS);
sigma_scal_T_M = max(0,E_MSL/(1 + exp(-lambda_MSL*(xpls - x0_MSL))) + E_MSR/(1 + exp(lambda_MSR*(xpls - x0_MSR))) + E_MSC*xpls + sigma_bias_MS);
 
sigma_A = max(0,sigma_A + sigma_scal_T_A*(temp - T0));
sigma_M = min(sigma_A,sigma_M + sigma_scal_T_M*(temp - T0));

end

% Compute strain values associated with each of energy well extremum:
    w_A = sigma_A/Ea;
    w_M = sigma_M/Em + epsilonT;
    deltaBeta = 1/2*(Em*(epsilonT-w_A)*(epsilonT-w_M)-Ea*w_A*w_M);

    a(1) = Em/2;
    a(2) = (Em*(epsilonT-w_M)+Ea*w_A)/2/(w_A-w_M);
    a(3) = Ea/2;
    a(4) = a(2);
    a(5) = a(1);

    b(1) = Em*epsilonT;
    b(2) = w_A*(Em*(epsilonT-w_M)+Ea*w_M)/(w_A-w_M);
    b(3) = 0;
    b(4) = -b(2);
    b(5) = -Em*epsilonT;

    c(1) = Em/2*epsilonT^2;
    c(2) = (2*deltaBeta*(w_A-w_M)+w_A^2*(Em*(epsilonT-w_M)+Ea*w_M))/2/(w_A-w_M);
    c(3) = deltaBeta;
    c(4) = c(2);
    c(5) = c(1);

    % Change for eliminating numerical ill conditioning

    eps_ext = b*0;
    eps_ext(1) = (sigma - b(1))/a(1)/2;
    eps_ext(3) = (sigma - b(3))/a(3)/2;
    eps_ext(5) = (sigma - b(5))/a(5)/2;

    if eps_ext(1) > -w_M
        eps_ext(1)=-w_M;
    end

    if eps_ext(3) < -w_A
        eps_ext(3)=-w_A;
    elseif eps_ext(3) > w_A
        eps_ext(3)=w_A;
    end

    if eps_ext(5) < w_M
        eps_ext(5)=w_M;
    end

    if abs(sigma_A - sigma_M) < 10
        if (sigma + sigma_A)*(w_M - w_A) > 0
           eps_ext(2) = -w_M;
        else
           eps_ext(2) = -w_A; 
        end

        if (sigma - sigma_A)*(w_M - w_A) < 0
           eps_ext(4) = w_M;
        else
           eps_ext(4) = w_A; 
        end
    else
        eps_ext(2) = (sigma - b(2))/a(2)/2;
        eps_ext(4) = (sigma - b(4))/a(4)/2;

        if eps_ext(2) < -w_M
            eps_ext(2)=-w_M;
        elseif eps_ext(2) > -w_A
            eps_ext(2)=-w_A;
        end

        if eps_ext(4) < w_A
            eps_ext(4)=w_A;
        elseif eps_ext(4) > w_M
            eps_ext(4)=w_M;
        end
    end

    G = a.*eps_ext.^2 + b.*eps_ext + c - sigma*eps_ext;

    % deltaG 
    deltaG_mA = G(2)-G(1);
    deltaG_Am = G(2)-G(3);
    deltaG_Ap = G(4)-G(3);
    deltaG_pA = G(4)-G(5);

    lambda = Vd/kb/temp;


%     pma = 1/tau_x*exp(-lambda*(deltaG_mA));
%     pam = 1/tau_x*exp(-lambda*(deltaG_Am));
    ppa = 1/tau_x*exp(-lambda*(deltaG_pA));
    pap = 1/tau_x*exp(-lambda*(deltaG_Ap));

  A_surface = 2*pi*r0*L0;		% SMA wire side surface
  A_crosssec = pi*r0^2;			% SMA wire cross section area
  V_wire = A_crosssec*L0;       % SMA wire volume
  
  % Berechnen der Ableitungen der Zustaende
  
  dx(1) = -ppa*xpls + pap*(1-xpls-xmns);
  dx(2) = 0; %-pma*xmns + pam*(1-xpls-xmns);
  dx(3) = 1/rho/cv*(-alpha*(temp-T_ext)*A_surface/A_crosssec/L0+p_el/V_wire+latentHpls*dx(1)+latentHmns*dx(2));

  % Schreiben auf Objekt block
  block.Derivatives.Data = dx;


% -------------------------------------------------------------------------
% Operationen am Ende der Simulation
% -------------------------------------------------------------------------

% Die function Terminate wird hier nicht verwendet,
% muss aber vorhanden sein!
function Terminate(block)

