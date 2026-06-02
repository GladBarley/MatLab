% Skript: JLoad_no_Friction.m
% Lese die Trace-Daten und die Signalnamen aus der Datei ein 
[data, names] = load_traces('JLoadWithoutFriction.trace');

% Extrahiere die Abtastzeitpunkte aus der ersten Spalte (in ms) 
t_ms = data(:, 1);

% Bestimme die konstante Abtastzeit T in Sekunden für die Ableitungsfunktion
T = (t_ms(2) - t_ms(1)) / 1000;

% Dynamische Spaltenzuweisung (limitiert auf den ersten Treffer)
idx_omega = find(contains(names, 'Velocity', 'IgnoreCase', true), 1, 'first') + 1;
idx_iq = find(contains(names, 'Current', 'IgnoreCase', true), 1, 'first') + 1;

% Extrahiere die Winkelgeschwindigkeit und konvertiere in rad/s 
omega = data(:, idx_omega) * (pi / 180);

% Extrahiere den Strom und konvertiere in A 
Iq = data(:, idx_iq) / 1000;

% Berechne die Winkelbeschleunigung in rad/s^2 mit der eigenen Funktion
alpha = num_derivative(omega, T);

% Berechne die Drehmomentkonstante kT in Abhängigkeit von Iq
kT = torqueconstant(Iq);

% Berechne das resultierende Motordrehmoment in Nm 
M_motor = kT .* Iq;

% Erstelle ein neues Fenster für die Diagramme 
figure;

% Erstelle das erste Subplot (1 von 3, oben) 
subplot(3, 1, 1);
% Zeichne die Winkelgeschwindigkeit über der Zeit 
plot(t_ms, omega);
% Beschrifte die y-Achse 
ylabel('omega [rad/s]');
% Aktiviere das Raster für bessere Lesbarkeit
grid on;

% Erstelle das zweite Subplot (2 von 3, mittig) 
subplot(3, 1, 2);
% Zeichne die Winkelbeschleunigung über der Zeit 
plot(t_ms, alpha);
% Beschrifte die y-Achse 
ylabel('alpha [rad/s^2]');
% Aktiviere das Raster
grid on;

% Erstelle das dritte Subplot (3 von 3, unten) 
subplot(3, 1, 3);
% Zeichne das Motordrehmoment über der Zeit 
plot(t_ms, M_motor);
% Beschrifte die y-Achse 
ylabel('M_{motor} [Nm]');
% Aktiviere das Raster
grid on;

% --- Beginn Arbeitsauftrag 6 ---
% Finde den maximalen Betrag der Winkelbeschleunigung 
alpha_max = max(abs(alpha));

% Finde alle Indizes, bei denen der Betrag von alpha größer oder gleich 25% des Maximums ist 
idx = find(abs(alpha) >= 0.25 * alpha_max);

% Berechne J = M/alpha nur für die gefilterten Indizes (Einheit: kg*m^2) 
J_values = M_motor(idx) ./ alpha(idx);

% Bilde den Mittelwert, um das geschätzte Gesamtträgheitsmoment zu erhalten 
J_est = mean(J_values);

% Berechne das theoretische Beschleunigungsmoment mit dem geschätzten J für alle Zeitpunkte 
M_motor_est = J_est * alpha;

% Wähle das dritte Subplot erneut aus, um das neue Signal hinzuzufügen 
subplot(3, 1, 3);
% Behalte den bisherigen Graphen bei 
hold on;
% Zeichne das geschätzte Drehmoment in rot ein 
plot(t_ms, M_motor_est, 'r--');
% Füge eine Legende zur Unterscheidung hinzu
legend('Gemessen', 'Geschätzt');

% Definiere das Motorträgheitsmoment in kg*cm^2
J_Motor = 0.059;

% Konvertiere J_est erst in kg*cm^2 und ziehe dann J_Motor ab
J_Load_kgcm2 = (J_est * 10000) - J_Motor;

% Gib das Ergebnis in der Konsole aus 
disp(['Identifiziertes J_Load: ', num2str(J_Load_kgcm2), ' kg*cm^2']);