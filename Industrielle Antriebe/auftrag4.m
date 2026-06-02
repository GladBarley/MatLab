% Skript zur Berechnung der Koeffizienten a, b, c
clear; clc;

% Gegebene Werte aus Tabelle 1
M_0 = 0.5; 
I_0 = 0.73;
M_max = 1.5; 
I_max = 2.9;

% Definition der Matrix A und des Vektors b
A = [I_0^3,   I_0^2,   I_0;
     I_max^3, I_max^2, I_max;
     0,       1,       0];
     
b = [M_0; M_max; 0];

% Lösung des Gleichungssystems
x = A \ b;

% Ausgabe im Command Window
fprintf('Koeffizient a: %.6f\n', x(1));
fprintf('Koeffizient b: %.6f\n', x(2));
fprintf('Koeffizient c: %.6f\n', x(3));



% Test- und Verifikationsskript
clear; clc; close all;


% Definition des Strombereichs von 0 bis I_max (2.9 A)
I_max = 2.9;
Iq_plot = linspace(0, I_max, 100)';

% Berechnung der Drehmomentkonstanten mit der neuen Funktion
kT_plot = torqueconstant(Iq_plot);

% Referenzwerte aus Arbeitsauftrag 3 zur Überprüfung
I0_ref = 0.73;
kT0_ref = 0.5 / 0.73;
Imax_ref = 2.9;
kTmax_ref = 1.5 / 2.9;

% Diagramm erstellen
figure;
hold on; grid on;

% Plot der berechneten Kennlinie
plot(Iq_plot, kT_plot, 'b', 'LineWidth', 2);

% Plot der beiden Fixpunkte aus Tabelle 1
plot(I0_ref, kT0_ref, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
plot(Imax_ref, kTmax_ref, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

% Achsenbeschriftung und Legende
xlabel('Drehmomentbildende Stromkomponente I_q [A]');
ylabel('Drehmomentkonstante k_T [Nm/A]');
title('Einfluss der Eisensättigung auf die Drehmomentkonstante');
legend('Kennlinie k_T(I_q)', 'Ermittelte Fixpunkte', 'Location', 'southwest');
