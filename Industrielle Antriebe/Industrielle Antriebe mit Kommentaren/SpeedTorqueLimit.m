% Skript: SpeedTorqueLimit.m

% Lade die Trace-Daten des Maximalbeschleunigungs-Tests
[data, names] = load_traces('MaxAcc.trace');
t_ms = data(:, 1);

% Finde Spaltenindizes dynamisch (Groß-/Kleinschreibung ignorieren)
% Die +1 ist nötig, da 'names' ab Spalte 2 von 'data' zählt
idx_omega = find(contains(names, 'Velocity', 'IgnoreCase', true)) + 1;
idx_iq = find(contains(names, 'Current', 'IgnoreCase', true)) + 1;

% Extrahiere omega und Iq mit den korrekten Indizes
omega = data(:, idx_omega) * (pi / 180);
Iq = data(:, idx_iq) / 1000;

% Rechne omega (rad/s) in Drehzahl n (U/min) um
n = omega * (60 / (2 * pi));

% Berechne das Motordrehmoment in Nm
M_motor = torqueconstant(Iq) .* Iq;

% --- Filterung nach Vorgabe ---

% 1. Entferne alle Abtastwerte, an denen M_motor < 0.1 Nm ist
valid_mask = M_motor >= 0.1;
M_filt1 = M_motor(valid_mask);
n_filt1 = n(valid_mask);
t_filt1 = t_ms(valid_mask);

% 2. Finde den ersten Abtastzeitpunkt mit M_motor > 1.0 Nm in den verbleibenden Daten
idx_start = find(M_filt1 > 1.0, 1, 'first');

% Lösche alle Abtastwerte, die zu kleineren Zeiten gehören (also Index < idx_start)
M_final = M_filt1(idx_start:end);
n_final = n_filt1(idx_start:end);

% --- Darstellung ---

figure;
% Zeichne die gemessene Kennlinie
plot(n_final, M_final, 'b', 'LineWidth', 1.5);
hold on;

% Definiere die Drehzahlen aus der Tabelle
n_ref = [0, 1000, 1270, 2000, 3000, 4000, 5000, 6000];
% Definiere die zugehörigen M_max Werte (aus Abb. 6 abgelesen)
M_ref = [1.5, 1.5, 1.5, 1.15, 0.82, 0.53, 0.28, 0.05];

% Zeichne die Referenzkennlinie in rot
plot(n_ref, M_ref, 'r--', 'LineWidth', 1.5);

xlabel('Drehzahl n [U/min]');
ylabel('Drehmoment M [Nm]');
legend('Gemessen', 'Datenblatt (230V)');
grid on;