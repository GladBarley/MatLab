%% Aufgabe 1.3 - Koordinatentransformation

clear; clc;

%% a)

% Translationsmatrix aufstellen
T_trans = trvec2tform([3 4 2]);
% Rotationsachse normieren  -> axang2tform erwartet einen Einheitsvektor
achse = [1 1 0] / norm([1 1 0]);
T_rot = axang2tform([achse deg2rad(50)]);
% Gesamttransformation T_A_B
T_A_B = T_trans * T_rot;

disp('a) Transformationsmatrix T_A_B:');
disp(T_A_B);

% Punkt P in homogenen Koordinaten
P_B = [2 2 2 1]';
% Punkt in System A umrechnen
P_A = T_A_B * P_B;

disp('a) Punkt P im System A:');
disp(P_A(1:3)');

%% b)

T_B_A = inv(T_A_B);

disp('b) Inverse Transformationsmatrix T_B_A:');
disp(T_B_A);

% Punkt P aus System A zurueck in System B rechnen
P_B_kontrolle = T_B_A*P_A;

disp('b) Punkt P zurueck in System B:');
disp(P_B_kontrolle(1:3)');
