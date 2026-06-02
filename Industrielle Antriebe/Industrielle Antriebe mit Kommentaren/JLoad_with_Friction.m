% Skript: JLoad_with_Friction.m

% Lese die Trace-Daten mit Reibung ein [cite: 568]
[data, names] = load_traces('JLoadAndFriction.trace');

% Extrahiere die Zeitachse [cite: 512]
t_ms = data(:, 1);
T = (t_ms(2) - t_ms(1)) / 1000;

% Dynamische Spaltenzuweisung (limitiert auf den ersten Treffer)
idx_omega = find(contains(names, 'Velocity', 'IgnoreCase', true), 1, 'first') + 1;
idx_iq = find(contains(names, 'Current', 'IgnoreCase', true), 1, 'first') + 1;

% Extrahiere omega und konvertiere in rad/s [cite: 569]
omega = data(:, idx_omega) * (pi / 180);

% Extrahiere Iq und konvertiere in A [cite: 569]
Iq = data(:, idx_iq) / 1000;

% Berechne die Winkelbeschleunigung [cite: 570]
alpha = num_derivative(omega, T);

% Berechne das Drehmoment [cite: 570]
M_motor = torqueconstant(Iq) .* Iq;

% Zeichne die Signale vor der Filterung [cite: 575]
figure;
subplot(3,1,1); plot(t_ms, omega); hold on; ylabel('omega [rad/s]'); grid on;
subplot(3,1,2); plot(t_ms, alpha); hold on; ylabel('alpha [rad/s^2]'); grid on;
subplot(3,1,3); plot(t_ms, M_motor); hold on; ylabel('M_{motor} [Nm]'); grid on;

% Finde Indizes aller Werte, bei denen der Betrag von omega >= 20 rad/s ist [cite: 586]
valid_idx = find(abs(omega) >= 20);

% Filtere die Signale [cite: 586, 587]
t_sync = t_ms(valid_idx);
omega_filt = omega(valid_idx);
alpha_filt = alpha(valid_idx);
M_motor_filt = M_motor(valid_idx);

% Zeichne die gefilterten Signale zur Überprüfung [cite: 593]
subplot(3,1,1); plot(t_sync, omega_filt, 'r.');
subplot(3,1,2); plot(t_sync, alpha_filt, 'r.');
subplot(3,1,3); plot(t_sync, M_motor_filt, 'r.');

% Erstelle Matrix A und Vektor b [cite: 598, 599, 600]
A = [alpha_filt, omega_filt, sign(omega_filt)];
b = M_motor_filt;

% Löse das Gleichungssystem [cite: 96, 603]
x = A \ b;

% Extrahiere Parameter [cite: 605]
J_est = x(1);
K_Fric_omega = x(2);
K_Fric_0 = x(3);

% Berechne Fehlermaß E [cite: 89, 604]
e = A * x - b;
E = sum(e.^2);

% Konsolenausgabe [cite: 605]
disp(['J: ', num2str(J_est), ' kg*m^2']);
disp(['K_Fric_omega: ', num2str(K_Fric_omega), ' Nm/(rad/s)']);
disp(['K_Fric_0: ', num2str(K_Fric_0), ' Nm']);
disp(['Fehler E: ', num2str(E)]);

% Berechne und zeichne geschätztes Drehmoment [cite: 607, 613, 614]
M_motor_est = J_est * alpha + K_Fric_omega * omega + K_Fric_0 * sign(omega);
subplot(3,1,3); plot(t_ms, M_motor_est, 'g--');

% Korrekte Berechnung von J_Load unter Berücksichtigung der Einheiten [cite: 615]
J_Motor = 0.059; % kg*cm^2
J_Load_kgcm2 = (J_est * 10000) - J_Motor;
disp(['Neues J_Load: ', num2str(J_Load_kgcm2), ' kg*cm^2']);