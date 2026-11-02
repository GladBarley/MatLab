%% Aufgabe 3.2 - Trajektorie im Gelenkwinkelraum (trapezfoermiges Profil)

clear; clc;

Startposition = [0; pi/4; -pi/2; 0];
Zielposition  = [-pi/4; -pi/4; pi/2; pi/6];
Wegpunkte = [Startposition Zielposition];

[q, qd, qdd, tSamples, pp] = trapveltraj(Wegpunkte, 200);

figure(1);
plot(tSamples, q);
title('Aufgabe 3.2 - Gelenkwinkel q(t)');
xlabel('Zeit'); ylabel('Gelenkwinkel [rad]');
legend('A1', 'A2', 'A3', 'A4'); grid on;

figure(2);
plot(tSamples, qd);
title('Aufgabe 3.2 - Geschwindigkeit qd(t)');
xlabel('Zeit'); ylabel('Geschwindigkeit [rad/s]');
legend('A1', 'A2', 'A3', 'A4'); grid on;
