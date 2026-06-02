
% Lese die Trace-Daten und die Signalnamen aus der Datei ein 
[data, names] = load_traces('JLoadWithoutFriction.trace');

% Extrahiere die Abtastzeitpunkte aus der ersten Spalte (in ms) 
t_ms = data(:, 1);

% Bestimme die konstante Abtastzeit T in Sekunden für die Ableitungsfunktion
T = (t_ms(2) - t_ms(1)) / 1000;

% Dynamische Spaltenzuweisung 
idx_omega = find(contains(names, 'Velocity', 'IgnoreCase', true), 1, 'first') + 1;
idx_iq = find(contains(names, 'Current', 'IgnoreCase', true), 1, 'first') + 1;

omega = data(:, idx_omega) * (pi / 180);
Iq = data(:, idx_iq) / 1000;

% Berechne die Winkelbeschleunigung in rad/s^2 mit der eigenen Funktion
alpha = num_derivative(omega, T);

% Berechne die Drehmomentkonstante kT in Abhängigkeit von Iq
kT = torqueconstant(Iq);

% Berechne das resultierende Motordrehmoment in Nm 
M_motor = kT .* Iq;


figure;

 
subplot(3, 1, 1);
% Zeichne die Winkelgeschwindigkeit über der Zeit 
plot(t_ms, omega);
ylabel('omega [rad/s]');
grid on;
 
subplot(3, 1, 2);
% Zeichne die Winkelbeschleunigung über der Zeit 
plot(t_ms, alpha);
ylabel('alpha [rad/s^2]');
grid on;

subplot(3, 1, 3);
% Zeichne das Motordrehmoment über der Zeit 
plot(t_ms, M_motor);
ylabel('M_{motor} [Nm]');
grid on;

% Arbeitsauftrag 6
% Finde den maximalen Betrag der Winkelbeschleunigung 
alpha_max = max(abs(alpha));

% Finde alle Indizes, bei denen der Betrag von alpha größer oder gleich 25% des Maximums ist 
idx = find(abs(alpha) >= 0.25 * alpha_max);

% Berechne J = M/alpha nur für die gefilterten Indizes
J_values = M_motor(idx) ./ alpha(idx);

% Bilde den Mittelwert, um das geschätzte Gesamtträgheitsmoment zu erhalten 
J_est = mean(J_values);

% Berechne das theoretische Beschleunigungsmoment mit dem geschätzten J für alle Zeitpunkte 
M_motor_est = J_est * alpha;


subplot(3, 1, 3);

hold on;
% Zeichne das geschätzte Drehmoment in rot ein 
plot(t_ms, M_motor_est, 'r--');

legend('Gemessen', 'Geschätzt');

J_Motor = 0.059;

% Konvertiere J_est erst in kg*cm^2 und ziehe dann J_Motor ab
J_Load_kgcm2 = (J_est * 10000) - J_Motor;

disp(['Identifiziertes J_Load: ', num2str(J_Load_kgcm2), ' kg*cm^2']);