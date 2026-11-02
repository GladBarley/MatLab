%% Aufgabe 1.2 - Koordinatentransformation

clear; clc;

% Translation und Rotation aufstellen
T_trans = trvec2tform([2 0 2]);
T_rot = axang2tform([0 1 0 deg2rad(72)]);
% Gesamttransformation
T_A_B = T_trans * T_rot;

disp('Transformationsmatrix T_A_B:');
disp(T_A_B);

% Punkt P in homogenen Koordinaten
P_B = [1 2 3 1]';
% Punkt in System A umrechnen
P_A = T_A_B * P_B;

disp('Punkt P im System A:');
disp(P_A(1:3)');
