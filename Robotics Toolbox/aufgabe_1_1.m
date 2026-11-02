%% Aufgabe 1.1

clear; clc;

% Translationsmatrix aufstellen
T_trans = trvec2tform([15 10 0]);
% Rotationsmatrix aufstellen
T_rot = axang2tform([0 0 1 deg2rad(20)]);
% Gesamttransformation T_A_B = Translation * Rotation
T_A_B = T_trans * T_rot;

% Punkt P in homogenen Koordinaten
P_B = [6 4 0 1]';
% Punkt in System A umrechnen
P_A = T_A_B * P_B;

disp('Transformationsmatrix T_A_B:');
disp(T_A_B);
disp('Punkt P im System A:');
disp(P_A(1:3)');
