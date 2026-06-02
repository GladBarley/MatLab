% Initialisierung der Testparameter
T = 0.001; % Definiert die Abtastzeit von 1 ms
t = (0:T:2*pi)'; % Erzeugt einen Zeitvektor von 0 bis 2*pi als Spaltenvektor

% Erzeugung des Testsignals und der Referenz
u_sine = sin(t); % Generiert Abtastwerte der Sinusfunktion
y_exact = cos(t); % Berechnet die analytisch exakte Ableitung (Ableitung von sin ist cos)

% Berechnung der numerischen Ableitung
y_num = num_derivative(u_sine, T); % Ruft die erstellte Funktion auf

% Grafischer Vergleich gemäß Arbeitsauftrag 2
figure;% Öffnet ein neues Grafikfenster
plot(t, y_exact, 'b', 'LineWidth', 2); % Zeichnet die exakte Lösung in Blau
hold on;
plot(t, y_num, 'r--', 'LineWidth', 1.5); % Zeichnet die numerische Näherung rot gestrichelt

% Formatierung des Diagramms
grid on; % Aktiviert das Koordinatennetz
xlabel('Zeit t [s]'); % Beschriftet die Zeitachse im metrischen System (Sekunden)
ylabel('Amplitude'); % Beschriftet die Ordinatenachse
title('Vergleich: Analytische vs. Numerische Zeitableitung'); % Setzt den Titel
legend('Analytisch (cos)', 'Numerisch (num\_derivative)', 'Location', 'best'); % Fügt die Legende hinzu

max_error = max(abs(y_exact(2:end) - y_num(2:end))); % Berechnet den maximalen Fehler
fprintf('Maximaler Fehler der numerischen Ableitung: %.4f\n', max_error); % Gibt den Fehler im Command Window aus