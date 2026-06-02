% Arbeitsauftrag 3: Berechnung der Drehmomentkonstanten
M_0 = 0.5;      % Dauerstillstandsmoment in Nm
I_0 = 0.73;     % Dauerstillstandsstrom in A
M_max = 1.5;    % Spitzenmoment in Nm
I_max = 2.9;    % Spitzenstrom in A

% Berechnung von kT
kT_0 = M_0 / I_0;       
kT_max = M_max / I_max; 

% Ausgabe
fprintf('kT bei Dauerstillstand: %.4f Nm/A\n', kT_0);
fprintf('kT bei Spitzenlast: %.4f Nm/A\n', kT_max);